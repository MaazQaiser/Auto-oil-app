import '../../../../core/utils/logger.dart';
import 'messaging_service.dart';

/// Placeholder for future WhatsApp Business Cloud API integration.
/// Not used at runtime until credentials and API wiring are added.
class WhatsAppBusinessCloudService implements MessagingService {
  WhatsAppBusinessCloudService({
    this.apiToken,
    this.phoneNumberId,
  });

  final String? apiToken;
  final String? phoneNumberId;

  @override
  String get channelName => 'WhatsApp Business Cloud';

  @override
  Future<bool> isAvailable() async => false;

  @override
  Future<bool> sendMessage({
    required String phone,
    required String message,
  }) async {
    AppLogger.warning(
      'WhatsAppBusinessCloudService is not configured. '
      'Use LocalWhatsAppService until Cloud API credentials are provided.',
    );
    // Future: POST https://graph.facebook.com/v19.0/{phone-number-id}/messages
    throw UnimplementedError(
      'WhatsApp Business Cloud API is not enabled yet.',
    );
  }
}
