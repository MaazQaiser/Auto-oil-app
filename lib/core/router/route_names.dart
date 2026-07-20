/// Named route path constants.
class AppRoutes {
  const AppRoutes._();

  static const String splash = '/';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String customers = '/customers';
  static const String addCustomer = '/customers/add';
  static const String archivedCustomers = '/customers/archived';
  static const String vehicles = '/vehicles';
  static const String addVehicle = '/vehicles/add';
  static const String archivedVehicles = '/vehicles/archived';
  static const String serviceRecords = '/service-records';
  static const String reminders = '/reminders';
  static const String reports = '/reports';
  static const String invoices = '/invoices';
  static const String inventory = '/inventory';
  static const String settings = '/settings';
  static const String messageTemplates = '/settings/templates';
  static const String reminderHistory = '/settings/reminder-history';
  static const String messageEditor = '/reminders/message-editor';

  static String customerDetailPath(String id) => '/customers/$id';
  static String editCustomerPath(String id) => '/customers/$id/edit';
  static String vehicleDetailPath(String id) => '/vehicles/$id';
  static String editVehiclePath(String id) => '/vehicles/$id/edit';
  static String addVehicleForCustomer(String customerId) =>
      '/vehicles/add?customerId=$customerId';
  static String addServiceRecordPath(String vehicleId) =>
      '/vehicles/$vehicleId/service-records/add';
  static String updateServiceHistoryPath(String vehicleId) =>
      '/vehicles/$vehicleId/update-service';
  static String addInventoryItemPath(String type) =>
      '/inventory/add?type=$type';
  static String reminderDetailPath(String id) => '/reminders/$id';
  static String messageEditorPath(String reminderId) =>
      '/reminders/message-editor?reminderId=$reminderId';
  static String invoiceDetailPath(String id) => '/invoices/$id';
}

/// Route name identifiers (useful for analytics / deep links later).
class RouteNames {
  const RouteNames._();

  static const String splash = 'splash';
  static const String login = 'login';
  static const String dashboard = 'dashboard';
  static const String customers = 'customers';
  static const String addCustomer = 'addCustomer';
  static const String archivedCustomers = 'archivedCustomers';
  static const String customerDetail = 'customerDetail';
  static const String editCustomer = 'editCustomer';
  static const String vehicles = 'vehicles';
  static const String addVehicle = 'addVehicle';
  static const String archivedVehicles = 'archivedVehicles';
  static const String vehicleDetail = 'vehicleDetail';
  static const String editVehicle = 'editVehicle';
  static const String addServiceRecord = 'addServiceRecord';
  static const String updateServiceHistory = 'updateServiceHistory';
  static const String serviceRecords = 'serviceRecords';
  static const String reminders = 'reminders';
  static const String reminderDetail = 'reminderDetail';
  static const String messageEditor = 'messageEditor';
  static const String reports = 'reports';
  static const String invoices = 'invoices';
  static const String invoiceDetail = 'invoiceDetail';
  static const String inventory = 'inventory';
  static const String addInventoryItem = 'addInventoryItem';
  static const String settings = 'settings';
  static const String messageTemplates = 'messageTemplates';
  static const String reminderHistory = 'reminderHistory';
}
