import '../../../../core/utils/logger.dart';
import '../../domain/repositories/reminder_repository.dart';

/// Runs reminder recalculation on app open / dashboard refresh.
class ReminderBackgroundService {
  ReminderBackgroundService(this._repository);

  final ReminderRepository _repository;
  bool _running = false;

  /// Idempotent check — safe to call frequently.
  Future<int> runCheck() async {
    if (_running) return 0;
    _running = true;
    try {
      final int updated = await _repository.recalculateAllStatuses();
      AppLogger.info('Reminder check complete — updated $updated');
      return updated;
    } catch (e, st) {
      AppLogger.error('Reminder check failed', error: e, stackTrace: st);
      return 0;
    } finally {
      _running = false;
    }
  }
}
