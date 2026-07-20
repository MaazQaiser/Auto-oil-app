/// Abstract messaging channel — swap implementations without changing UI.
abstract class MessagingService {
  String get channelName;

  /// Whether this channel is available on the current device/environment.
  Future<bool> isAvailable();

  /// Opens / sends a message for [phone] with [message] body.
  /// Returns true when the channel was opened successfully.
  Future<bool> sendMessage({
    required String phone,
    required String message,
  });
}
