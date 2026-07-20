import 'package:drift/drift.dart';
import 'package:intl/intl.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/router/route_names.dart';
import '../../domain/entities/dashboard_models.dart';

/// Optimized Drift aggregate queries for the dashboard.
class DashboardAnalyticsDataSource {
  DashboardAnalyticsDataSource(this._db);

  final AppDatabase _db;

  DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  DateRange resolveRange(DashboardPeriod period, {DateRange? custom}) {
    final DateTime now = DateTime.now();
    final DateTime today = _dateOnly(now);
    switch (period) {
      case DashboardPeriod.today:
        return DateRange(
          start: today,
          end: today.add(const Duration(days: 1)),
        );
      case DashboardPeriod.thisWeek:
        final int weekday = today.weekday; // Mon=1
        final DateTime start = today.subtract(Duration(days: weekday - 1));
        return DateRange(start: start, end: start.add(const Duration(days: 7)));
      case DashboardPeriod.thisMonth:
        final DateTime start = DateTime(today.year, today.month);
        final DateTime end = DateTime(today.year, today.month + 1);
        return DateRange(start: start, end: end);
      case DashboardPeriod.custom:
        return custom ??
            DateRange(
              start: today.subtract(const Duration(days: 30)),
              end: today.add(const Duration(days: 1)),
            );
    }
  }

  Future<DashboardSummary> getSummary() async {
    try {
      final customers = await (_db.selectOnly(_db.customers)
            ..addColumns([_db.customers.id.count()])
            ..where(_db.customers.isArchived.equals(false)))
          .getSingle();
      final vehicles = await (_db.selectOnly(_db.vehicles)
            ..addColumns([_db.vehicles.id.count()])
            ..where(_db.vehicles.isArchived.equals(false)))
          .getSingle();
      final services = await (_db.selectOnly(_db.serviceRecords)
            ..addColumns([_db.serviceRecords.id.count()])
            ..where(_db.serviceRecords.isArchived.equals(false)))
          .getSingle();

      final DateTime today = _dateOnly(DateTime.now());
      final DateTime tomorrow = today.add(const Duration(days: 1));
      final DateTime monthStart = DateTime(today.year, today.month);

      final todayRev = await _sumRevenue(today, tomorrow);
      final monthRev = await _sumRevenue(monthStart, tomorrow);

      final due = await _countReminders('due');
      final upcoming = await _countReminders('upcoming');
      final overdue = await _countReminders('overdue');

      return DashboardSummary(
        totalCustomers: customers.read(_db.customers.id.count()) ?? 0,
        totalVehicles: vehicles.read(_db.vehicles.id.count()) ?? 0,
        totalServices: services.read(_db.serviceRecords.id.count()) ?? 0,
        todayRevenue: todayRev,
        monthlyRevenue: monthRev,
        dueToday: due,
        upcoming: upcoming,
        overdue: overdue,
      );
    } catch (e) {
      throw DatabaseException('Failed to load dashboard summary: $e');
    }
  }

  Future<double> _sumRevenue(DateTime start, DateTime end) async {
    final sumExp = _db.serviceRecords.totalCost.sum();
    final row = await (_db.selectOnly(_db.serviceRecords)
          ..addColumns([sumExp])
          ..where(
            _db.serviceRecords.isArchived.equals(false) &
                _db.serviceRecords.serviceDate.isBiggerOrEqualValue(start) &
                _db.serviceRecords.serviceDate.isSmallerThanValue(end),
          ))
        .getSingle();
    return row.read(sumExp) ?? 0;
  }

  Future<int> _countReminders(String status) async {
    final countExp = _db.maintenanceReminders.id.count();
    final row = await (_db.selectOnly(_db.maintenanceReminders)
          ..addColumns([countExp])
          ..where(_db.maintenanceReminders.status.equals(status)))
        .getSingle();
    return row.read(countExp) ?? 0;
  }

  Future<RevenueSummary> getRevenueSummary({
    DashboardPeriod period = DashboardPeriod.thisMonth,
    DateRange? customRange,
  }) async {
    try {
      final DateTime now = DateTime.now();
      final DateTime today = _dateOnly(now);
      final DateTime tomorrow = today.add(const Duration(days: 1));
      final DateTime monthStart = DateTime(today.year, today.month);
      final DateTime yearStart = DateTime(today.year);
      final DateRange range = resolveRange(period, custom: customRange);

      final double todayRev = await _sumRevenue(today, tomorrow);
      final double monthRev = await _sumRevenue(monthStart, tomorrow);
      final double yearRev = await _sumRevenue(yearStart, tomorrow);
      final double periodRev = await _sumRevenue(range.start, range.end);
      final periodSvcRow = await (_db.selectOnly(_db.serviceRecords)
            ..addColumns([_db.serviceRecords.id.count()])
            ..where(
              _db.serviceRecords.isArchived.equals(false) &
                  _db.serviceRecords.serviceDate
                      .isBiggerOrEqualValue(range.start) &
                  _db.serviceRecords.serviceDate.isSmallerThanValue(range.end),
            ))
          .getSingle();
      final int periodServices =
          periodSvcRow.read(_db.serviceRecords.id.count()) ?? 0;

      final totalSum = _db.serviceRecords.totalCost.sum();
      final totalCount = _db.serviceRecords.id.count();
      final avgRow = await (_db.selectOnly(_db.serviceRecords)
            ..addColumns([totalSum, totalCount])
            ..where(_db.serviceRecords.isArchived.equals(false)))
          .getSingle();
      final double total = avgRow.read(totalSum) ?? 0;
      final int count = avgRow.read(totalCount) ?? 0;
      final double avgCost = count == 0 ? 0 : total / count;

      final List<MonthlyPoint> monthlyRevenue = [];
      final List<MonthlyPoint> monthlyServices = [];
      final DateFormat labelFmt = DateFormat('MMM');

      for (int i = 5; i >= 0; i--) {
        final DateTime start = DateTime(now.year, now.month - i);
        final DateTime end = DateTime(now.year, now.month - i + 1);
        final rev = await _sumRevenue(start, end);
        final svcCount = await (_db.selectOnly(_db.serviceRecords)
              ..addColumns([_db.serviceRecords.id.count()])
              ..where(
                _db.serviceRecords.isArchived.equals(false) &
                    _db.serviceRecords.serviceDate.isBiggerOrEqualValue(start) &
                    _db.serviceRecords.serviceDate.isSmallerThanValue(end),
              ))
            .getSingle();
        final label = labelFmt.format(start);
        monthlyRevenue.add(MonthlyPoint(label: label, value: rev));
        monthlyServices.add(
          MonthlyPoint(
            label: label,
            value: (svcCount.read(_db.serviceRecords.id.count()) ?? 0)
                .toDouble(),
          ),
        );
      }

      final double avgMonthly = monthlyServices.isEmpty
          ? 0
          : monthlyServices.map((e) => e.value).reduce((a, b) => a + b) /
              monthlyServices.length;

      return RevenueSummary(
        today: todayRev,
        month: monthRev,
        year: yearRev,
        total: total,
        periodRevenue: periodRev,
        periodServices: periodServices,
        averageServiceCost: avgCost,
        averageMonthlyServices: avgMonthly,
        monthlyRevenue: monthlyRevenue,
        monthlyServices: monthlyServices,
      );
    } catch (e) {
      throw DatabaseException('Failed to load revenue summary: $e');
    }
  }

  Future<BusinessInsights> getBusinessInsights() async {
    try {
      final revenue = await getRevenueSummary();

      // Average odometer delta between consecutive services per vehicle
      double avgOdoGap = 0;
      final vehicles = await (_db.select(_db.vehicles)
            ..where((t) => t.isArchived.equals(false)))
          .get();
      final List<int> gaps = [];
      for (final v in vehicles.take(50)) {
        final records = await (_db.select(_db.serviceRecords)
              ..where(
                (t) =>
                    t.vehicleId.equals(v.id) & t.isArchived.equals(false),
              )
              ..orderBy([(t) => OrderingTerm.asc(t.serviceDate)]))
            .get();
        for (int i = 1; i < records.length; i++) {
          final gap =
              records[i].odometerReading - records[i - 1].odometerReading;
          if (gap > 0) gaps.add(gap);
        }
      }
      if (gaps.isNotEmpty) {
        avgOdoGap = gaps.reduce((a, b) => a + b) / gaps.length;
      }

      final brandDist = await _groupVehicleBrands();
      final serviceDist = await _groupServiceTypes();
      final reminderDist = await _groupReminderStatuses();
      final oilBrand = await _topOilBrand();
      final topCustomer = await _highestSpendingCustomer();

      return BusinessInsights(
        averageServiceCost: revenue.averageServiceCost,
        averageOdometerBetweenServices: avgOdoGap,
        mostServicedBrand:
            brandDist.isEmpty ? null : brandDist.first.name,
        mostUsedOilBrand: oilBrand,
        highestSpendingCustomer: topCustomer,
        totalRevenue: revenue.total,
        monthlyRevenue: revenue.month,
        yearlyRevenue: revenue.year,
        averageMonthlyServices: revenue.averageMonthlyServices,
        brandDistribution: brandDist,
        serviceTypeDistribution: serviceDist,
        reminderStatusDistribution: reminderDist,
      );
    } catch (e) {
      throw DatabaseException('Failed to load business insights: $e');
    }
  }

  Future<List<NamedCount>> _groupVehicleBrands() async {
    final makeCol = _db.vehicles.make;
    final countExp = _db.vehicles.id.count();
    final rows = await (_db.selectOnly(_db.vehicles)
          ..addColumns([makeCol, countExp])
          ..where(_db.vehicles.isArchived.equals(false))
          ..groupBy([makeCol])
          ..orderBy([OrderingTerm.desc(countExp)])
          ..limit(8))
        .get();
    return rows
        .map(
          (r) => NamedCount(
            name: r.read(makeCol) ?? 'Unknown',
            count: r.read(countExp) ?? 0,
          ),
        )
        .toList();
  }

  Future<List<NamedCount>> _groupServiceTypes() async {
    final typeCol = _db.serviceRecords.serviceType;
    final countExp = _db.serviceRecords.id.count();
    final rows = await (_db.selectOnly(_db.serviceRecords)
          ..addColumns([typeCol, countExp])
          ..where(_db.serviceRecords.isArchived.equals(false))
          ..groupBy([typeCol])
          ..orderBy([OrderingTerm.desc(countExp)])
          ..limit(8))
        .get();
    return rows
        .map(
          (r) => NamedCount(
            name: r.read(typeCol) ?? 'Other',
            count: r.read(countExp) ?? 0,
          ),
        )
        .toList();
  }

  Future<List<NamedCount>> _groupReminderStatuses() async {
    final statusCol = _db.maintenanceReminders.status;
    final countExp = _db.maintenanceReminders.id.count();
    final rows = await (_db.selectOnly(_db.maintenanceReminders)
          ..addColumns([statusCol, countExp])
          ..groupBy([statusCol])
          ..orderBy([OrderingTerm.desc(countExp)]))
        .get();
    return rows
        .map(
          (r) => NamedCount(
            name: (r.read(statusCol) ?? 'unknown').toUpperCase(),
            count: r.read(countExp) ?? 0,
          ),
        )
        .toList();
  }

  Future<String?> _topOilBrand() async {
    final oilCol = _db.serviceRecords.oilBrand;
    final countExp = _db.serviceRecords.id.count();
    final rows = await (_db.selectOnly(_db.serviceRecords)
          ..addColumns([oilCol, countExp])
          ..where(
            _db.serviceRecords.isArchived.equals(false) &
                _db.serviceRecords.oilBrand.isNotNull(),
          )
          ..groupBy([oilCol])
          ..orderBy([OrderingTerm.desc(countExp)])
          ..limit(1))
        .get();
    if (rows.isEmpty) return null;
    return rows.first.read(oilCol);
  }

  Future<String?> _highestSpendingCustomer() async {
    final sumExp = _db.serviceRecords.totalCost.sum();
    final query = _db.selectOnly(_db.serviceRecords).join([
          innerJoin(
            _db.vehicles,
            _db.vehicles.id.equalsExp(_db.serviceRecords.vehicleId),
          ),
          innerJoin(
            _db.customers,
            _db.customers.id.equalsExp(_db.vehicles.customerId),
          ),
        ])
          ..addColumns([_db.customers.fullName, sumExp])
          ..where(_db.serviceRecords.isArchived.equals(false))
          ..groupBy([_db.customers.id, _db.customers.fullName])
          ..orderBy([OrderingTerm.desc(sumExp)])
          ..limit(1);
    final rows = await query.get();
    if (rows.isEmpty) return null;
    return rows.first.read(_db.customers.fullName);
  }

  Future<List<ActivityItem>> getRecentActivity({int limit = 20}) async {
    try {
      final List<ActivityItem> items = [];

      final customers = await (_db.select(_db.customers)
            ..where((t) => t.isArchived.equals(false))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
            ..limit(8))
          .get();
      for (final c in customers) {
        items.add(
          ActivityItem(
            id: 'c-${c.id}',
            type: ActivityType.customerAdded,
            title: 'Customer Added',
            subtitle: c.fullName,
            timestamp: c.createdAt,
          ),
        );
      }

      final vehicles = await (_db.select(_db.vehicles)
            ..where((t) => t.isArchived.equals(false))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
            ..limit(8))
          .get();
      for (final v in vehicles) {
        items.add(
          ActivityItem(
            id: 'v-${v.id}',
            type: ActivityType.vehicleAdded,
            title: 'Vehicle Added',
            subtitle: '${v.make} ${v.model} · ${v.registrationNumber}',
            timestamp: v.createdAt,
          ),
        );
      }

      final services = await (_db.select(_db.serviceRecords)
            ..where((t) => t.isArchived.equals(false))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
            ..limit(8))
          .get();
      for (final s in services) {
        items.add(
          ActivityItem(
            id: 's-${s.id}',
            type: ActivityType.serviceAdded,
            title: 'Service Added',
            subtitle: s.serviceType,
            timestamp: s.createdAt,
          ),
        );
      }

      final completed = await (_db.select(_db.maintenanceReminders)
            ..where((t) => t.status.equals('completed'))
            ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])
            ..limit(8))
          .get();
      for (final r in completed) {
        items.add(
          ActivityItem(
            id: 'r-${r.id}',
            type: ActivityType.reminderCompleted,
            title: 'Reminder Completed',
            subtitle: 'Service follow-up closed',
            timestamp: r.updatedAt,
          ),
        );
      }

      items.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return items.take(limit).toList();
    } catch (e) {
      throw DatabaseException('Failed to load recent activity: $e');
    }
  }

  Future<List<GlobalSearchResult>> globalSearch(String query) async {
    final String q = query.trim().toLowerCase();
    if (q.isEmpty) return [];

    try {
      final String pattern = '%$q%';
      final List<GlobalSearchResult> results = [];

      final customers = await (_db.select(_db.customers)
            ..where(
              (t) =>
                  t.isArchived.equals(false) &
                  (t.fullName.lower().like(pattern) |
                      t.phoneNumber.lower().like(pattern) |
                      (t.city.isNotNull() & t.city.lower().like(pattern))),
            )
            ..limit(10))
          .get();
      for (final c in customers) {
        results.add(
          GlobalSearchResult(
            id: c.id,
            category: 'Customer',
            title: c.fullName,
            subtitle: c.phoneNumber,
            route: AppRoutes.customerDetailPath(c.id),
          ),
        );
      }

      final vehicles = await (_db.select(_db.vehicles).join([
            innerJoin(
              _db.customers,
              _db.customers.id.equalsExp(_db.vehicles.customerId),
            ),
          ])
            ..where(
              _db.vehicles.isArchived.equals(false) &
                  (_db.vehicles.registrationNumber.lower().like(pattern) |
                      _db.vehicles.make.lower().like(pattern) |
                      _db.vehicles.model.lower().like(pattern) |
                      _db.customers.fullName.lower().like(pattern)),
            )
            ..limit(10))
          .get();
      for (final row in vehicles) {
        final v = row.readTable(_db.vehicles);
        final c = row.readTable(_db.customers);
        results.add(
          GlobalSearchResult(
            id: v.id,
            category: 'Vehicle',
            title: '${v.make} ${v.model}',
            subtitle: '${v.registrationNumber} · ${c.fullName}',
            route: AppRoutes.vehicleDetailPath(v.id),
          ),
        );
      }

      // Invoice placeholder — search service records by type / oil as proxy
      final services = await (_db.select(_db.serviceRecords)
            ..where(
              (t) =>
                  t.isArchived.equals(false) &
                  (t.serviceType.lower().like(pattern) |
                      (t.oilBrand.isNotNull() &
                          t.oilBrand.lower().like(pattern)) |
                      (t.notes.isNotNull() & t.notes.lower().like(pattern))),
            )
            ..limit(8))
          .get();
      for (final s in services) {
        results.add(
          GlobalSearchResult(
            id: s.id,
            category: 'Service / Invoice',
            title: s.serviceType,
            subtitle: 'ODO ${s.odometerReading}',
            route: AppRoutes.vehicleDetailPath(s.vehicleId),
          ),
        );
      }

      return results;
    } catch (e) {
      throw DatabaseException('Global search failed: $e');
    }
  }
}
