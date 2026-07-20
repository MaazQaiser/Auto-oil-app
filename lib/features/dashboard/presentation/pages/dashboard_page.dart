import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../shared/providers/navigation_provider.dart';
import '../../../notifications/presentation/providers/notification_providers.dart';
import '../../../reminders/domain/entities/maintenance_reminder.dart';
import '../../../reminders/presentation/providers/reminder_providers.dart';
import '../../../settings/providers/settings_provider.dart';
import '../../domain/entities/dashboard_models.dart';
import '../providers/dashboard_providers.dart';
import '../widgets/global_search_sheet.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  static const List<_NavItem> _navItems = [
    _NavItem(
      label: 'Home',
      icon: Icons.home_outlined,
      route: AppRoutes.dashboard,
    ),
    _NavItem(
      label: 'Customer',
      icon: Icons.people_alt_outlined,
      route: AppRoutes.customers,
    ),
    _NavItem(
      label: 'Vehicles',
      icon: Icons.directions_car_outlined,
      route: AppRoutes.vehicles,
    ),
    _NavItem(
      label: 'Settings',
      icon: Icons.settings_outlined,
      route: AppRoutes.settings,
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationManagerProvider).runReminderCheck();
    });
  }

  Future<void> _refresh() async {
    await ref.read(notificationManagerProvider).runReminderCheck();
    ref.invalidate(dashboardSummaryProvider);
    ref.invalidate(recentActivityProvider);
    ref.invalidate(allRemindersStreamProvider);
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(navigationIndexProvider);
    final summaryAsync = ref.watch(dashboardSummaryProvider);
    final activityAsync = ref.watch(recentActivityProvider);
    final upcomingAsync = ref.watch(upcomingThisWeekProvider);
    final userName = ref.watch(settingsServiceProvider).userName;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'HOME',
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: Badge(
              backgroundColor: AppColors.error,
              smallSize: 9,
              child: IconButton(
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: AppColors.white,
                ),
                onPressed: () => context.push(AppRoutes.reminders),
                tooltip: 'Reminders',
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: summaryAsync.when(
          loading: () => const Center(child: LoadingIndicator()),
          error: (error, _) => ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppSpacing.xl),
            children: [Text(error.toString())],
          ),
          data: (summary) => ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: AppSpacing.huge),
            children: [
              _BrandHeader(
                greeting: _greeting(),
                userName: userName,
                dateTimeLabel: DateFormat(
                  'EEEE, MMMM d, yyyy · h:mm a',
                ).format(DateTime.now()),
              ),
              ColoredBox(
                color: AppColors.lightBackground,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPadding,
                    AppSpacing.xl,
                    AppSpacing.screenPadding,
                    AppSpacing.huge,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _HomeActions(
                        onAddCustomer: () =>
                            context.push(AppRoutes.addCustomer),
                        onAddService: () => context.push(AppRoutes.inventory),
                        onSearch: () => GlobalSearchDelegateSheet.show(context),
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      const _SectionTitle(title: 'Recent Services This Week'),
                      const SizedBox(height: AppSpacing.md),
                      _RecentServices(
                        activityAsync: activityAsync,
                        onViewAll: () => context.push(AppRoutes.serviceRecords),
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      const _SectionTitle(title: 'Workshop Overview'),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          Expanded(
                            child: _TotalCard(
                              label: 'Total Customers',
                              value: summary.totalCustomers.toString(),
                              icon: Icons.people_alt_rounded,
                              onTap: () => context.push(AppRoutes.customers),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: _TotalCard(
                              label: 'Total Vehicles',
                              value: summary.totalVehicles.toString(),
                              icon: Icons.directions_car_filled_rounded,
                              onTap: () => context.push(AppRoutes.vehicles),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      _SectionTitle(
                        title: 'Upcoming Service Customers',
                        actionLabel: 'See All',
                        onAction: () => context.push(AppRoutes.reminders),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _UpcomingServices(async: upcomingAsync),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex.clamp(0, _navItems.length - 1),
        onDestinationSelected: (index) {
          if (index == 0) {
            ref.read(navigationIndexProvider.notifier).state = 0;
            return;
          }
          ref.read(navigationIndexProvider.notifier).state = index;
          context.push(_navItems[index].route).then((_) {
            if (mounted) {
              ref.read(navigationIndexProvider.notifier).state = 0;
            }
          });
        },
        destinations: [
          for (final item in _navItems)
            NavigationDestination(
              icon: Icon(item.icon),
              selectedIcon: Icon(item.icon),
              label: item.label,
            ),
        ],
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  const _BrandHeader({
    required this.greeting,
    required this.userName,
    required this.dateTimeLabel,
  });

  final String greeting;
  final String userName;
  final String dateTimeLabel;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.charcoal,
      child: Column(
        children: [
          SizedBox(
            height: 190,
            child: Center(
              child: Image.asset(
                AppConfig.logoAsset,
                width: 165,
                height: 165,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => const Icon(
                  Icons.settings_suggest_rounded,
                  color: AppColors.gold,
                  size: 88,
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.xl,
              AppSpacing.xl,
              AppSpacing.xxl,
            ),
            decoration: const BoxDecoration(
              color: AppColors.lightBackground,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '$greeting, ',
                        style: AppTextStyles.headlineSmall.copyWith(
                          color: AppColors.charcoal,
                        ),
                      ),
                      TextSpan(
                        text: userName,
                        style: AppTextStyles.headlineSmall.copyWith(
                          color: AppColors.gold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  dateTimeLabel,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.grey800,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeActions extends StatelessWidget {
  const _HomeActions({
    required this.onAddCustomer,
    required this.onAddService,
    required this.onSearch,
  });

  final VoidCallback onAddCustomer;
  final VoidCallback onAddService;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ActionCard(
          label: 'Search Customer or Car',
          icon: Icons.search_rounded,
          onTap: onSearch,
          horizontal: true,
          backgroundColor: AppColors.beige,
          foregroundColor: AppColors.charcoal,
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _ActionCard(
                label: 'Add Customer',
                icon: Icons.person_add_alt_1_rounded,
                onTap: onAddCustomer,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _ActionCard(
                label: 'Add Parts & Service',
                icon: Icons.build_circle_rounded,
                onTap: onAddService,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.label,
    required this.icon,
    required this.onTap,
    this.horizontal = false,
    this.backgroundColor = AppColors.charcoal,
    this.foregroundColor = AppColors.white,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool horizontal;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    final children = [
      Icon(icon, color: AppColors.gold, size: horizontal ? 25 : 30),
      SizedBox(
        width: horizontal ? AppSpacing.md : 0,
        height: horizontal ? 0 : AppSpacing.sm,
      ),
      if (horizontal)
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.labelLarge.copyWith(color: foregroundColor),
          ),
        )
      else
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          style: AppTextStyles.labelMedium.copyWith(color: foregroundColor),
        ),
    ];

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: horizontal ? 58 : 96,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: horizontal
                ? Row(children: children)
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: children,
                  ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, this.actionLabel, this.onAction});

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.charcoal,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (actionLabel != null)
          TextButton(onPressed: onAction, child: Text(actionLabel!)),
      ],
    );
  }
}

class _RecentServices extends StatelessWidget {
  const _RecentServices({required this.activityAsync, required this.onViewAll});

  final AsyncValue<List<ActivityItem>> activityAsync;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    return activityAsync.when(
      loading: () => const Center(child: LoadingIndicator(size: 26)),
      error: (_, _) =>
          const _EmptyCard(message: 'Recent services are unavailable.'),
      data: (items) {
        final weekAgo = DateTime.now().subtract(const Duration(days: 7));
        final services = items
            .where(
              (item) =>
                  item.type == ActivityType.serviceAdded &&
                  item.timestamp.isAfter(weekAgo),
            )
            .take(4)
            .toList();

        if (services.isEmpty) {
          return const _EmptyCard(message: 'No services recorded this week.');
        }

        return AppCard(
          color: AppColors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          child: Column(
            children: [
              for (final item in services)
                ListTile(
                  onTap: onViewAll,
                  contentPadding: EdgeInsets.zero,
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.charcoal,
                    child: Icon(
                      Icons.build_rounded,
                      color: AppColors.gold,
                      size: 20,
                    ),
                  ),
                  title: Text(item.title, style: AppTextStyles.titleSmall),
                  subtitle: Text(
                    item.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.grey600,
                    ),
                  ),
                  trailing: Text(
                    DateFormat.MMMd().format(item.timestamp),
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.grey600,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _TotalCard extends StatelessWidget {
  const _TotalCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      color: AppColors.white,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.gold, size: 28),
          const SizedBox(height: AppSpacing.lg),
          Text(
            value,
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.charcoal,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.labelSmall.copyWith(color: AppColors.grey600),
          ),
        ],
      ),
    );
  }
}

class _UpcomingServices extends StatelessWidget {
  const _UpcomingServices({required this.async});

  final AsyncValue<List<MaintenanceReminder>> async;

  @override
  Widget build(BuildContext context) {
    return async.when(
      loading: () => const Center(child: LoadingIndicator(size: 26)),
      error: (_, _) =>
          const _EmptyCard(message: 'Upcoming services are unavailable.'),
      data: (items) {
        if (items.isEmpty) {
          return const _EmptyCard(
            message: 'No customers have an upcoming service this week.',
          );
        }

        return AppCard(
          color: AppColors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          child: Column(
            children: [
              for (final reminder in items.take(5))
                ListTile(
                  onTap: () => context.push(
                    AppRoutes.vehicleDetailPath(reminder.vehicleId),
                  ),
                  contentPadding: EdgeInsets.zero,
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.charcoal,
                    child: Icon(
                      Icons.event_available_rounded,
                      color: AppColors.gold,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    reminder.ownerName ?? 'Customer',
                    style: AppTextStyles.titleSmall,
                  ),
                  subtitle: Text(
                    [
                      reminder.vehicleDisplayName ?? 'Vehicle',
                      if (reminder.registrationNumber != null)
                        reminder.registrationNumber!,
                    ].join(' · '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.grey600,
                    ),
                  ),
                  trailing: reminder.nextServiceDate == null
                      ? null
                      : Text(
                          DateFormat.MMMd().format(reminder.nextServiceDate!),
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.gold,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.white,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Text(
        message,
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey600),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.route,
  });

  final String label;
  final IconData icon;
  final String route;
}
