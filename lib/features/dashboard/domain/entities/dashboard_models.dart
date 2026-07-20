import 'package:equatable/equatable.dart';

/// Date-range filter for dashboard analytics.
enum DashboardPeriod {
  today,
  thisWeek,
  thisMonth,
  custom,
}

class DateRange extends Equatable {
  const DateRange({required this.start, required this.end});

  final DateTime start;
  final DateTime end;

  @override
  List<Object?> get props => [start, end];
}

/// Top-level dashboard KPI summary.
class DashboardSummary extends Equatable {
  const DashboardSummary({
    this.totalCustomers = 0,
    this.totalVehicles = 0,
    this.totalServices = 0,
    this.todayRevenue = 0,
    this.monthlyRevenue = 0,
    this.dueToday = 0,
    this.upcoming = 0,
    this.overdue = 0,
  });

  final int totalCustomers;
  final int totalVehicles;
  final int totalServices;
  final double todayRevenue;
  final double monthlyRevenue;
  final int dueToday;
  final int upcoming;
  final int overdue;

  bool get isEmpty =>
      totalCustomers == 0 && totalVehicles == 0 && totalServices == 0;

  @override
  List<Object?> get props => [
        totalCustomers,
        totalVehicles,
        totalServices,
        todayRevenue,
        monthlyRevenue,
        dueToday,
        upcoming,
        overdue,
      ];
}

class RevenueSummary extends Equatable {
  const RevenueSummary({
    this.today = 0,
    this.month = 0,
    this.year = 0,
    this.total = 0,
    this.periodRevenue = 0,
    this.periodServices = 0,
    this.averageServiceCost = 0,
    this.averageMonthlyServices = 0,
    this.monthlyRevenue = const [],
    this.monthlyServices = const [],
  });

  final double today;
  final double month;
  final double year;
  final double total;
  final double periodRevenue;
  final int periodServices;
  final double averageServiceCost;
  final double averageMonthlyServices;
  final List<MonthlyPoint> monthlyRevenue;
  final List<MonthlyPoint> monthlyServices;

  @override
  List<Object?> get props => [
        today,
        month,
        year,
        total,
        periodRevenue,
        periodServices,
        averageServiceCost,
        averageMonthlyServices,
        monthlyRevenue,
        monthlyServices,
      ];
}

class MonthlyPoint extends Equatable {
  const MonthlyPoint({required this.label, required this.value});

  final String label;
  final double value;

  @override
  List<Object?> get props => [label, value];
}

class NamedCount extends Equatable {
  const NamedCount({required this.name, required this.count});

  final String name;
  final int count;

  @override
  List<Object?> get props => [name, count];
}

class BusinessInsights extends Equatable {
  const BusinessInsights({
    this.averageServiceCost = 0,
    this.averageOdometerBetweenServices = 0,
    this.mostServicedBrand,
    this.mostUsedOilBrand,
    this.highestSpendingCustomer,
    this.totalRevenue = 0,
    this.monthlyRevenue = 0,
    this.yearlyRevenue = 0,
    this.averageMonthlyServices = 0,
    this.brandDistribution = const [],
    this.serviceTypeDistribution = const [],
    this.reminderStatusDistribution = const [],
  });

  final double averageServiceCost;
  final double averageOdometerBetweenServices;
  final String? mostServicedBrand;
  final String? mostUsedOilBrand;
  final String? highestSpendingCustomer;
  final double totalRevenue;
  final double monthlyRevenue;
  final double yearlyRevenue;
  final double averageMonthlyServices;
  final List<NamedCount> brandDistribution;
  final List<NamedCount> serviceTypeDistribution;
  final List<NamedCount> reminderStatusDistribution;

  @override
  List<Object?> get props => [
        averageServiceCost,
        averageOdometerBetweenServices,
        mostServicedBrand,
        mostUsedOilBrand,
        highestSpendingCustomer,
        totalRevenue,
        monthlyRevenue,
        yearlyRevenue,
        averageMonthlyServices,
        brandDistribution,
        serviceTypeDistribution,
        reminderStatusDistribution,
      ];
}

enum ActivityType {
  customerAdded,
  vehicleAdded,
  serviceAdded,
  reminderCompleted,
}

class ActivityItem extends Equatable {
  const ActivityItem({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.timestamp,
  });

  final String id;
  final ActivityType type;
  final String title;
  final String subtitle;
  final DateTime timestamp;

  @override
  List<Object?> get props => [id, type, title, subtitle, timestamp];
}

class GlobalSearchResult extends Equatable {
  const GlobalSearchResult({
    required this.id,
    required this.category,
    required this.title,
    required this.subtitle,
    required this.route,
  });

  final String id;
  final String category;
  final String title;
  final String subtitle;
  final String route;

  @override
  List<Object?> get props => [id, category, title, subtitle, route];
}
