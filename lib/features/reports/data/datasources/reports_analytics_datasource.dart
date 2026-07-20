import 'package:drift/drift.dart';
import 'package:intl/intl.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../invoices/domain/entities/invoice_enums.dart';
import '../../domain/entities/report_models.dart';

/// Aggregate Drift queries for the Reports module.
class ReportsAnalyticsDataSource {
  ReportsAnalyticsDataSource(this._db);

  final AppDatabase _db;

  DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  Future<BusinessReportsBundle> loadAll({ReportDateRange? custom}) async {
    try {
      final revenue = await getRevenueReport(custom: custom);
      final customers = await getCustomerReport();
      final vehicles = await getVehicleReport();
      final services = await getServiceReport();
      final reminders = await getReminderReport();
      final financial = await getFinancialReport();
      return BusinessReportsBundle(
        revenue: revenue,
        customers: customers,
        vehicles: vehicles,
        services: services,
        reminders: reminders,
        financial: financial,
      );
    } catch (e) {
      throw DatabaseException('Failed to load reports: $e');
    }
  }

  Future<RevenueReport> getRevenueReport({ReportDateRange? custom}) async {
    final now = DateTime.now();
    final today = _dateOnly(now);
    final tomorrow = today.add(const Duration(days: 1));
    final weekStart = today.subtract(Duration(days: today.weekday - 1));
    final monthStart = DateTime(today.year, today.month);
    final yearStart = DateTime(today.year);

    final todayRev = await _sumPaid(today, tomorrow);
    final weekRev = await _sumPaid(weekStart, tomorrow);
    final monthRev = await _sumPaid(monthStart, tomorrow);
    final yearRev = await _sumPaid(yearStart, tomorrow);
    final customRev = custom == null
        ? monthRev
        : await _sumPaid(custom.start, custom.end);

    final stats = await _invoiceStats();
    final trend = await _monthlyInvoiceTrend();

    return RevenueReport(
      today: todayRev,
      week: weekRev,
      month: monthRev,
      year: yearRev,
      customRange: customRev,
      averageInvoice: stats.$1,
      highestInvoice: stats.$2,
      lowestInvoice: stats.$3,
      monthlyTrend: trend,
    );
  }

  Future<double> _sumPaid(DateTime start, DateTime end) async {
    final sumExp = _db.invoices.grandTotal.sum();
    final row = await (_db.selectOnly(_db.invoices)
          ..addColumns([sumExp])
          ..where(
            _db.invoices.paymentStatus
                    .equals(PaymentStatus.paid.storageValue) &
                _db.invoices.invoiceDate.isBiggerOrEqualValue(start) &
                _db.invoices.invoiceDate.isSmallerThanValue(end),
          ))
        .getSingle();
    return row.read(sumExp) ?? 0;
  }

  Future<(double, double, double)> _invoiceStats() async {
    final avg = _db.invoices.grandTotal.avg();
    final max = _db.invoices.grandTotal.max();
    final min = _db.invoices.grandTotal.min();
    final row = await (_db.selectOnly(_db.invoices)
          ..addColumns([avg, max, min])
          ..where(
            _db.invoices.paymentStatus
                .isNotValue(PaymentStatus.cancelled.storageValue),
          ))
        .getSingle();
    return (row.read(avg) ?? 0, row.read(max) ?? 0, row.read(min) ?? 0);
  }

  Future<List<MonthlyPoint>> _monthlyInvoiceTrend() async {
    final now = DateTime.now();
    final fmt = DateFormat('MMM');
    final points = <MonthlyPoint>[];
    for (int i = 5; i >= 0; i--) {
      final start = DateTime(now.year, now.month - i);
      final end = DateTime(now.year, now.month - i + 1);
      final rev = await _sumPaid(start, end);
      points.add(MonthlyPoint(label: fmt.format(start), value: rev));
    }
    return points;
  }

  Future<CustomerReport> getCustomerReport() async {
    final totalExp = _db.customers.id.count();
    final totalRow = await (_db.selectOnly(_db.customers)
          ..addColumns([totalExp])
          ..where(_db.customers.isArchived.equals(false)))
        .getSingle();
    final archivedRow = await (_db.selectOnly(_db.customers)
          ..addColumns([totalExp])
          ..where(_db.customers.isArchived.equals(true)))
        .getSingle();

    final total = totalRow.read(totalExp) ?? 0;
    final inactive = archivedRow.read(totalExp) ?? 0;

    // Top spending via invoices
    final sumExp = _db.invoices.grandTotal.sum();
    final spendRows = await (_db.selectOnly(_db.invoices).join([
          innerJoin(
            _db.customers,
            _db.customers.id.equalsExp(_db.invoices.customerId),
          ),
        ])
          ..addColumns([_db.customers.fullName, sumExp])
          ..where(
            _db.invoices.paymentStatus
                .isNotValue(PaymentStatus.cancelled.storageValue),
          )
          ..groupBy([_db.customers.id, _db.customers.fullName])
          ..orderBy([OrderingTerm.desc(sumExp)])
          ..limit(5))
        .get();

    final topSpending = spendRows
        .map(
          (r) => NamedMetric(
            name: r.read(_db.customers.fullName) ?? 'Unknown',
            value: r.read(sumExp) ?? 0,
          ),
        )
        .toList();

    // Most frequent by service count
    final svcCount = _db.serviceRecords.id.count();
    final freqRows = await (_db.selectOnly(_db.serviceRecords).join([
          innerJoin(
            _db.vehicles,
            _db.vehicles.id.equalsExp(_db.serviceRecords.vehicleId),
          ),
          innerJoin(
            _db.customers,
            _db.customers.id.equalsExp(_db.vehicles.customerId),
          ),
        ])
          ..addColumns([_db.customers.fullName, svcCount])
          ..where(_db.serviceRecords.isArchived.equals(false))
          ..groupBy([_db.customers.id, _db.customers.fullName])
          ..orderBy([OrderingTerm.desc(svcCount)])
          ..limit(5))
        .get();

    final mostFrequent = freqRows
        .map(
          (r) => NamedCount(
            name: r.read(_db.customers.fullName) ?? 'Unknown',
            count: r.read(svcCount) ?? 0,
          ),
        )
        .toList();

    final newestRows = await (_db.select(_db.customers)
          ..where((t) => t.isArchived.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
          ..limit(5))
        .get();
    final newest = newestRows
        .map((c) => NamedCount(name: c.fullName, count: 1))
        .toList();

    // Growth trend — customers created per month (last 6)
    final now = DateTime.now();
    final fmt = DateFormat('MMM');
    final growth = <MonthlyPoint>[];
    for (int i = 5; i >= 0; i--) {
      final start = DateTime(now.year, now.month - i);
      final end = DateTime(now.year, now.month - i + 1);
      final countRow = await (_db.selectOnly(_db.customers)
            ..addColumns([totalExp])
            ..where(
              _db.customers.createdAt.isBiggerOrEqualValue(start) &
                  _db.customers.createdAt.isSmallerThanValue(end),
            ))
          .getSingle();
      growth.add(
        MonthlyPoint(
          label: fmt.format(start),
          value: (countRow.read(totalExp) ?? 0).toDouble(),
        ),
      );
    }

    return CustomerReport(
      total: total + inactive,
      active: total,
      inactive: inactive,
      topSpending: topSpending,
      mostFrequent: mostFrequent,
      newest: newest,
      growthTrend: growth,
    );
  }

  Future<VehicleReport> getVehicleReport() async {
    final brandCount = _db.vehicles.id.count();
    final brandRows = await (_db.selectOnly(_db.vehicles)
          ..addColumns([_db.vehicles.make, brandCount])
          ..where(_db.vehicles.isArchived.equals(false))
          ..groupBy([_db.vehicles.make])
          ..orderBy([OrderingTerm.desc(brandCount)])
          ..limit(8))
        .get();
    final brands = brandRows
        .map(
          (r) => NamedCount(
            name: r.read(_db.vehicles.make) ?? 'Unknown',
            count: r.read(brandCount) ?? 0,
          ),
        )
        .toList();

    final modelCount = _db.serviceRecords.id.count();
    final modelRows = await (_db.selectOnly(_db.serviceRecords).join([
          innerJoin(
            _db.vehicles,
            _db.vehicles.id.equalsExp(_db.serviceRecords.vehicleId),
          ),
        ])
          ..addColumns([_db.vehicles.model, modelCount])
          ..where(_db.serviceRecords.isArchived.equals(false))
          ..groupBy([_db.vehicles.model])
          ..orderBy([OrderingTerm.desc(modelCount)])
          ..limit(8))
        .get();
    final models = modelRows
        .map(
          (r) => NamedCount(
            name: r.read(_db.vehicles.model) ?? 'Unknown',
            count: r.read(modelCount) ?? 0,
          ),
        )
        .toList();

    final avgOdo = _db.vehicles.currentOdo.avg();
    final odoRow = await (_db.selectOnly(_db.vehicles)
          ..addColumns([avgOdo])
          ..where(_db.vehicles.isArchived.equals(false)))
        .getSingle();

    final dueCount = _db.maintenanceReminders.id.count();
    final dueRow = await (_db.selectOnly(_db.maintenanceReminders)
          ..addColumns([dueCount])
          ..where(_db.maintenanceReminders.status.equals('due')))
        .getSingle();
    final overdueRow = await (_db.selectOnly(_db.maintenanceReminders)
          ..addColumns([dueCount])
          ..where(_db.maintenanceReminders.status.equals('overdue')))
        .getSingle();

    return VehicleReport(
      mostServicedBrands: brands,
      mostServicedModels: models,
      averageOdo: odoRow.read(avgOdo) ?? 0,
      vehiclesDue: dueRow.read(dueCount) ?? 0,
      overdueVehicles: overdueRow.read(dueCount) ?? 0,
    );
  }

  Future<ServiceReport> getServiceReport() async {
    final today = _dateOnly(DateTime.now());
    final tomorrow = today.add(const Duration(days: 1));
    final monthStart = DateTime(today.year, today.month);
    final countExp = _db.serviceRecords.id.count();

    final todayRow = await (_db.selectOnly(_db.serviceRecords)
          ..addColumns([countExp])
          ..where(
            _db.serviceRecords.isArchived.equals(false) &
                _db.serviceRecords.serviceDate.isBiggerOrEqualValue(today) &
                _db.serviceRecords.serviceDate.isSmallerThanValue(tomorrow),
          ))
        .getSingle();
    final monthRow = await (_db.selectOnly(_db.serviceRecords)
          ..addColumns([countExp])
          ..where(
            _db.serviceRecords.isArchived.equals(false) &
                _db.serviceRecords.serviceDate
                    .isBiggerOrEqualValue(monthStart) &
                _db.serviceRecords.serviceDate.isSmallerThanValue(tomorrow),
          ))
        .getSingle();

    final oilCount = _db.serviceRecords.id.count();
    final oilRows = await (_db.selectOnly(_db.serviceRecords)
          ..addColumns([_db.serviceRecords.oilBrand, oilCount])
          ..where(
            _db.serviceRecords.isArchived.equals(false) &
                _db.serviceRecords.oilBrand.isNotNull(),
          )
          ..groupBy([_db.serviceRecords.oilBrand])
          ..orderBy([OrderingTerm.desc(oilCount)])
          ..limit(1))
        .get();

    final filterRows = await (_db.selectOnly(_db.serviceRecords)
          ..addColumns([_db.serviceRecords.serviceType, oilCount])
          ..where(
            _db.serviceRecords.isArchived.equals(false) &
                _db.serviceRecords.serviceType.lower().like('%filter%'),
          )
          ..groupBy([_db.serviceRecords.serviceType])
          ..orderBy([OrderingTerm.desc(oilCount)])
          ..limit(1))
        .get();

    final avgCost = _db.serviceRecords.totalCost.avg();
    final avgRow = await (_db.selectOnly(_db.serviceRecords)
          ..addColumns([avgCost])
          ..where(_db.serviceRecords.isArchived.equals(false)))
        .getSingle();

    // Average days between services (sample vehicles)
    double avgDays = 0;
    final vehicles = await (_db.select(_db.vehicles)
          ..where((t) => t.isArchived.equals(false))
          ..limit(40))
        .get();
    final gaps = <int>[];
    for (final v in vehicles) {
      final records = await (_db.select(_db.serviceRecords)
            ..where(
              (t) =>
                  t.vehicleId.equals(v.id) & t.isArchived.equals(false),
            )
            ..orderBy([(t) => OrderingTerm.asc(t.serviceDate)]))
          .get();
      for (int i = 1; i < records.length; i++) {
        gaps.add(
          records[i].serviceDate.difference(records[i - 1].serviceDate).inDays,
        );
      }
    }
    if (gaps.isNotEmpty) {
      avgDays = gaps.reduce((a, b) => a + b) / gaps.length;
    }

    final now = DateTime.now();
    final fmt = DateFormat('MMM');
    final monthly = <MonthlyPoint>[];
    for (int i = 5; i >= 0; i--) {
      final start = DateTime(now.year, now.month - i);
      final end = DateTime(now.year, now.month - i + 1);
      final row = await (_db.selectOnly(_db.serviceRecords)
            ..addColumns([countExp])
            ..where(
              _db.serviceRecords.isArchived.equals(false) &
                  _db.serviceRecords.serviceDate.isBiggerOrEqualValue(start) &
                  _db.serviceRecords.serviceDate.isSmallerThanValue(end),
            ))
          .getSingle();
      monthly.add(
        MonthlyPoint(
          label: fmt.format(start),
          value: (row.read(countExp) ?? 0).toDouble(),
        ),
      );
    }

    return ServiceReport(
      today: todayRow.read(countExp) ?? 0,
      thisMonth: monthRow.read(countExp) ?? 0,
      mostUsedOil:
          oilRows.isEmpty ? null : oilRows.first.read(_db.serviceRecords.oilBrand),
      mostReplacedFilter: filterRows.isEmpty
          ? null
          : filterRows.first.read(_db.serviceRecords.serviceType),
      averageServiceCost: avgRow.read(avgCost) ?? 0,
      averageDaysBetweenServices: avgDays,
      monthlyServices: monthly,
    );
  }

  Future<ReminderReport> getReminderReport() async {
    Future<int> count(String status) async {
      final c = _db.maintenanceReminders.id.count();
      final row = await (_db.selectOnly(_db.maintenanceReminders)
            ..addColumns([c])
            ..where(_db.maintenanceReminders.status.equals(status)))
          .getSingle();
      return row.read(c) ?? 0;
    }

    final upcoming = await count('upcoming');
    final due = await count('due');
    final overdue = await count('overdue');
    final completed = await count('completed');
    final total = upcoming + due + overdue + completed;
    final rate = total == 0 ? 0.0 : (completed / total) * 100;

    return ReminderReport(
      upcoming: upcoming,
      due: due,
      overdue: overdue,
      completed: completed,
      completionRate: rate,
      statusDistribution: [
        NamedCount(name: 'Upcoming', count: upcoming),
        NamedCount(name: 'Due', count: due),
        NamedCount(name: 'Overdue', count: overdue),
        NamedCount(name: 'Completed', count: completed),
      ],
    );
  }

  Future<FinancialReport> getFinancialReport() async {
    final paidSumExp = _db.invoices.grandTotal.sum();
    final paidRow = await (_db.selectOnly(_db.invoices)
          ..addColumns([paidSumExp])
          ..where(
            _db.invoices.paymentStatus.equals(PaymentStatus.paid.storageValue),
          ))
        .getSingle();
    final revenue = paidRow.read(paidSumExp) ?? 0;

    final outstandingSum = _db.invoices.grandTotal.sum();
    final outstandingRow = await (_db.selectOnly(_db.invoices)
          ..addColumns([outstandingSum])
          ..where(
            _db.invoices.paymentStatus
                    .equals(PaymentStatus.pending.storageValue) |
                _db.invoices.paymentStatus
                    .equals(PaymentStatus.partiallyPaid.storageValue),
          ))
        .getSingle();

    final countExp = _db.invoices.id.count();
    final paidCount = await (_db.selectOnly(_db.invoices)
          ..addColumns([countExp])
          ..where(
            _db.invoices.paymentStatus.equals(PaymentStatus.paid.storageValue),
          ))
        .getSingle();
    final pendingCount = await (_db.selectOnly(_db.invoices)
          ..addColumns([countExp])
          ..where(
            _db.invoices.paymentStatus
                .equals(PaymentStatus.pending.storageValue),
          ))
        .getSingle();

    final avgProfit = _db.invoices.grandTotal.avg();
    final avgRow = await (_db.selectOnly(_db.invoices)
          ..addColumns([avgProfit])
          ..where(
            _db.invoices.paymentStatus.equals(PaymentStatus.paid.storageValue),
          ))
        .getSingle();

    final statusCount = _db.invoices.id.count();
    final statusRows = await (_db.selectOnly(_db.invoices)
          ..addColumns([_db.invoices.paymentStatus, statusCount])
          ..groupBy([_db.invoices.paymentStatus])
          ..orderBy([OrderingTerm.desc(statusCount)]))
        .get();

    return FinancialReport(
      revenue: revenue,
      outstanding: outstandingRow.read(outstandingSum) ?? 0,
      paidInvoices: paidCount.read(countExp) ?? 0,
      pendingInvoices: pendingCount.read(countExp) ?? 0,
      averageProfit: avgRow.read(avgProfit) ?? 0,
      monthlyTrend: await _monthlyInvoiceTrend(),
      paymentStatusDistribution: statusRows
          .map(
            (r) => NamedCount(
              name: PaymentStatus.fromStorage(
                r.read(_db.invoices.paymentStatus) ?? 'pending',
              ).label,
              count: r.read(statusCount) ?? 0,
            ),
          )
          .toList(),
    );
  }
}
