import 'package:url_launcher/url_launcher.dart';

import '../../../../core/utils/logger.dart';
import 'messaging_service.dart';

/// Opens the WhatsApp app / web with a pre-filled message via url_launcher.
/// Does NOT auto-send — the user confirms in WhatsApp.
class LocalWhatsAppService implements MessagingService {
  @override
  String get channelName => 'WhatsApp';

  @override
  Future<bool> isAvailable() async {
    final Uri uri = Uri.parse('https://wa.me/');
    return canLaunchUrl(uri);
  }

  @override
  Future<bool> sendMessage({
    required String phone,
    required String message,
  }) async {
    final String digits = phone.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) {
      AppLogger.warning('WhatsApp launch failed: empty phone');
      return false;
    }

    final Uri uri = Uri.parse(
      'https://wa.me/$digits?text=${Uri.encodeComponent(message)}',
    );

    try {
      if (await canLaunchUrl(uri)) {
        final bool launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        AppLogger.info('WhatsApp opened for $digits: $launched');
        return launched;
      }
      AppLogger.warning('WhatsApp not available for $digits');
      return false;
    } catch (e, st) {
      AppLogger.error('WhatsApp launch error', error: e, stackTrace: st);
      return false;
    }
  }
}
