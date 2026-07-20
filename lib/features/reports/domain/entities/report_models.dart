import 'package:equatable/equatable.dart';

/// Shared date range for reports / invoices.
class ReportDateRange extends Equatable {
  const ReportDateRange({required this.start, required this.end});

  final DateTime start;
  final DateTime end;

  @override
  List<Object?> get props => [start, end];
}

class NamedMetric extends Equatable {
  const NamedMetric({required this.name, required this.value});

  final String name;
  final double value;

  @override
  List<Object?> get props => [name, value];
}

class NamedCount extends Equatable {
  const NamedCount({required this.name, required this.count});

  final String name;
  final int count;

  @override
  List<Object?> get props => [name, count];
}

class MonthlyPoint extends Equatable {
  const MonthlyPoint({required this.label, required this.value});

  final String label;
  final double value;

  @override
  List<Object?> get props => [label, value];
}

class RevenueReport extends Equatable {
  const RevenueReport({
    this.today = 0,
    this.week = 0,
    this.month = 0,
    this.year = 0,
    this.customRange = 0,
    this.averageInvoice = 0,
    this.highestInvoice = 0,
    this.lowestInvoice = 0,
    this.monthlyTrend = const [],
  });

  final double today;
  final double week;
  final double month;
  final double year;
  final double customRange;
  final double averageInvoice;
  final double highestInvoice;
  final double lowestInvoice;
  final List<MonthlyPoint> monthlyTrend;

  @override
  List<Object?> get props => [
        today,
        week,
        month,
        year,
        customRange,
        averageInvoice,
        highestInvoice,
        lowestInvoice,
        monthlyTrend,
      ];
}

class CustomerReport extends Equatable {
  const CustomerReport({
    this.total = 0,
    this.active = 0,
    this.inactive = 0,
    this.topSpending = const [],
    this.mostFrequent = const [],
    this.newest = const [],
    this.growthTrend = const [],
  });

  final int total;
  final int active;
  final int inactive;
  final List<NamedMetric> topSpending;
  final List<NamedCount> mostFrequent;
  final List<NamedCount> newest;
  final List<MonthlyPoint> growthTrend;

  @override
  List<Object?> get props => [
        total,
        active,
        inactive,
        topSpending,
        mostFrequent,
        newest,
        growthTrend,
      ];
}

class VehicleReport extends Equatable {
  const VehicleReport({
    this.mostServicedBrands = const [],
    this.mostServicedModels = const [],
    this.averageOdo = 0,
    this.vehiclesDue = 0,
    this.overdueVehicles = 0,
  });

  final List<NamedCount> mostServicedBrands;
  final List<NamedCount> mostServicedModels;
  final double averageOdo;
  final int vehiclesDue;
  final int overdueVehicles;

  @override
  List<Object?> get props => [
        mostServicedBrands,
        mostServicedModels,
        averageOdo,
        vehiclesDue,
        overdueVehicles,
      ];
}

class ServiceReport extends Equatable {
  const ServiceReport({
    this.today = 0,
    this.thisMonth = 0,
    this.mostUsedOil,
    this.mostReplacedFilter,
    this.averageServiceCost = 0,
    this.averageDaysBetweenServices = 0,
    this.monthlyServices = const [],
  });

  final int today;
  final int thisMonth;
  final String? mostUsedOil;
  final String? mostReplacedFilter;
  final double averageServiceCost;
  final double averageDaysBetweenServices;
  final List<MonthlyPoint> monthlyServices;

  @override
  List<Object?> get props => [
        today,
        thisMonth,
        mostUsedOil,
        mostReplacedFilter,
        averageServiceCost,
        averageDaysBetweenServices,
        monthlyServices,
      ];
}

class ReminderReport extends Equatable {
  const ReminderReport({
    this.upcoming = 0,
    this.due = 0,
    this.overdue = 0,
    this.completed = 0,
    this.completionRate = 0,
    this.statusDistribution = const [],
  });

  final int upcoming;
  final int due;
  final int overdue;
  final int completed;
  final double completionRate;
  final List<NamedCount> statusDistribution;

  @override
  List<Object?> get props => [
        upcoming,
        due,
        overdue,
        completed,
        completionRate,
        statusDistribution,
      ];
}

class FinancialReport extends Equatable {
  const FinancialReport({
    this.revenue = 0,
    this.outstanding = 0,
    this.paidInvoices = 0,
    this.pendingInvoices = 0,
    this.averageProfit = 0,
    this.monthlyTrend = const [],
    this.paymentStatusDistribution = const [],
  });

  final double revenue;
  final double outstanding;
  final int paidInvoices;
  final int pendingInvoices;
  final double averageProfit;
  final List<MonthlyPoint> monthlyTrend;
  final List<NamedCount> paymentStatusDistribution;

  @override
  List<Object?> get props => [
        revenue,
        outstanding,
        paidInvoices,
        pendingInvoices,
        averageProfit,
        monthlyTrend,
        paymentStatusDistribution,
      ];
}

class BusinessReportsBundle extends Equatable {
  const BusinessReportsBundle({
    required this.revenue,
    required this.customers,
    required this.vehicles,
    required this.services,
    required this.reminders,
    required this.financial,
  });

  final RevenueReport revenue;
  final CustomerReport customers;
  final VehicleReport vehicles;
  final ServiceReport services;
  final ReminderReport reminders;
  final FinancialReport financial;

  @override
  List<Object?> get props =>
      [revenue, customers, vehicles, services, reminders, financial];
}
