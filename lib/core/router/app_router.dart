import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/customers/presentation/pages/add_customer_page.dart';
import '../../features/customers/presentation/pages/archived_customers_page.dart';
import '../../features/customers/presentation/pages/customer_detail_page.dart';
import '../../features/customers/presentation/pages/customers_page.dart';
import '../../features/customers/presentation/pages/edit_customer_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/inventory/domain/entities/inventory_item.dart';
import '../../features/inventory/presentation/pages/add_inventory_item_page.dart';
import '../../features/inventory/presentation/pages/inventory_page.dart';
import '../../features/invoices/presentation/pages/invoices_page.dart';
import '../../features/notifications/presentation/pages/message_editor_page.dart';
import '../../features/notifications/presentation/pages/reminder_detail_page.dart';
import '../../features/reminders/presentation/pages/reminders_page.dart';
import '../../features/reports/presentation/pages/reports_page.dart';
import '../../features/service_records/presentation/pages/add_service_record_page.dart';
import '../../features/service_records/presentation/pages/service_records_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/vehicles/presentation/pages/add_vehicle_page.dart';
import '../../features/vehicles/presentation/pages/archived_vehicles_page.dart';
import '../../features/vehicles/presentation/pages/edit_vehicle_page.dart';
import '../../features/vehicles/presentation/pages/update_service_history_page.dart';
import '../../features/vehicles/presentation/pages/vehicle_detail_page.dart';
import '../../features/vehicles/presentation/pages/vehicles_page.dart';
import 'route_names.dart';

/// Root navigator key for global navigation (dialogs, snackbars, etc.).
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  final authNotifier = ref.read(authChangeNotifierProvider);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    // A route must be immediately usable even when startup services are still
    // warming up. The old splash route waited on a delayed callback that could
    // be starved by plugin initialization on iOS simulators.
    initialLocation: fb.FirebaseAuth.instance.currentUser != null
        ? AppRoutes.dashboard
        : AppRoutes.login,
    refreshListenable: authNotifier,
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final location = state.matchedLocation;

      final isLoggedIn = fb.FirebaseAuth.instance.currentUser != null;

      if (location == AppRoutes.splash) {
        return isLoggedIn ? AppRoutes.dashboard : AppRoutes.login;
      }
      if (!isLoggedIn && location != AppRoutes.login) {
        return AppRoutes.login;
      }
      if (isLoggedIn && location == AppRoutes.login) {
        return AppRoutes.dashboard;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.splash,
        name: RouteNames.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.dashboard,
        name: RouteNames.dashboard,
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(
        path: AppRoutes.customers,
        name: RouteNames.customers,
        builder: (context, state) => const CustomersPage(),
        routes: [
          GoRoute(
            path: 'add',
            name: RouteNames.addCustomer,
            builder: (context, state) => const AddCustomerPage(),
          ),
          GoRoute(
            path: 'archived',
            name: RouteNames.archivedCustomers,
            builder: (context, state) => const ArchivedCustomersPage(),
          ),
          GoRoute(
            path: ':id',
            name: RouteNames.customerDetail,
            builder: (context, state) {
              final String id = state.pathParameters['id']!;
              return CustomerDetailPage(customerId: id);
            },
            routes: [
              GoRoute(
                path: 'edit',
                name: RouteNames.editCustomer,
                builder: (context, state) {
                  final String id = state.pathParameters['id']!;
                  return EditCustomerPage(customerId: id);
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.vehicles,
        name: RouteNames.vehicles,
        builder: (context, state) => const VehiclesPage(),
        routes: [
          GoRoute(
            path: 'add',
            name: RouteNames.addVehicle,
            builder: (context, state) {
              final String? customerId =
                  state.uri.queryParameters['customerId'];
              return AddVehiclePage(customerId: customerId);
            },
          ),
          GoRoute(
            path: 'archived',
            name: RouteNames.archivedVehicles,
            builder: (context, state) => const ArchivedVehiclesPage(),
          ),
          GoRoute(
            path: ':id',
            name: RouteNames.vehicleDetail,
            builder: (context, state) {
              final String id = state.pathParameters['id']!;
              return VehicleDetailPage(vehicleId: id);
            },
            routes: [
              GoRoute(
                path: 'edit',
                name: RouteNames.editVehicle,
                builder: (context, state) {
                  final String id = state.pathParameters['id']!;
                  return EditVehiclePage(vehicleId: id);
                },
              ),
              GoRoute(
                path: 'update-service',
                name: RouteNames.updateServiceHistory,
                builder: (context, state) {
                  final String id = state.pathParameters['id']!;
                  return UpdateServiceHistoryPage(vehicleId: id);
                },
              ),
              GoRoute(
                path: 'service-records/add',
                name: RouteNames.addServiceRecord,
                builder: (context, state) {
                  final String id = state.pathParameters['id']!;
                  return AddServiceRecordPage(vehicleId: id);
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.serviceRecords,
        name: RouteNames.serviceRecords,
        builder: (context, state) => const ServiceRecordsPage(),
      ),
      GoRoute(
        path: AppRoutes.reminders,
        name: RouteNames.reminders,
        builder: (context, state) => const RemindersPage(),
        routes: [
          GoRoute(
            path: 'message-editor',
            name: RouteNames.messageEditor,
            builder: (context, state) {
              final String reminderId =
                  state.uri.queryParameters['reminderId'] ?? '';
              return MessageEditorPage(reminderId: reminderId);
            },
          ),
          GoRoute(
            path: ':id',
            name: RouteNames.reminderDetail,
            builder: (context, state) {
              final String id = state.pathParameters['id']!;
              return ReminderDetailPage(reminderId: id);
            },
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.reports,
        name: RouteNames.reports,
        builder: (context, state) => const ReportsPage(),
      ),
      GoRoute(
        path: AppRoutes.invoices,
        name: RouteNames.invoices,
        builder: (context, state) => const InvoicesPage(),
        routes: [
          GoRoute(
            path: ':id',
            name: RouteNames.invoiceDetail,
            builder: (context, state) {
              final String id = state.pathParameters['id']!;
              return InvoiceDetailPage(invoiceId: id);
            },
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.inventory,
        name: RouteNames.inventory,
        builder: (context, state) => const InventoryPage(),
        routes: [
          GoRoute(
            path: 'add',
            name: RouteNames.addInventoryItem,
            builder: (context, state) {
              final typeParam = state.uri.queryParameters['type'] ?? 'part';
              final itemType = InventoryItemType.fromStorage(typeParam);
              return AddInventoryItemPage(itemType: itemType);
            },
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: RouteNames.settings,
        builder: (context, state) => const SettingsPage(),
        routes: [
          GoRoute(
            path: 'templates',
            name: RouteNames.messageTemplates,
            builder: (context, state) => const MessageTemplatesPage(),
          ),
          GoRoute(
            path: 'reminder-history',
            name: RouteNames.reminderHistory,
            builder: (context, state) => const ReminderHistoryPage(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.uri}'))),
  );
});
