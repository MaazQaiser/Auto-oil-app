enum PaymentMethod {
  cash,
  card,
  bankTransfer,
  online,
  other;

  String get storageValue => switch (this) {
        PaymentMethod.cash => 'cash',
        PaymentMethod.card => 'card',
        PaymentMethod.bankTransfer => 'bank_transfer',
        PaymentMethod.online => 'online',
        PaymentMethod.other => 'other',
      };

  String get label => switch (this) {
        PaymentMethod.cash => 'Cash',
        PaymentMethod.card => 'Card',
        PaymentMethod.bankTransfer => 'Bank Transfer',
        PaymentMethod.online => 'Online',
        PaymentMethod.other => 'Other',
      };

  static PaymentMethod fromStorage(String value) {
    return PaymentMethod.values.firstWhere(
      (e) => e.storageValue == value,
      orElse: () => PaymentMethod.other,
    );
  }
}

enum PaymentStatus {
  paid,
  pending,
  partiallyPaid,
  cancelled;

  String get storageValue => switch (this) {
        PaymentStatus.paid => 'paid',
        PaymentStatus.pending => 'pending',
        PaymentStatus.partiallyPaid => 'partially_paid',
        PaymentStatus.cancelled => 'cancelled',
      };

  String get label => switch (this) {
        PaymentStatus.paid => 'Paid',
        PaymentStatus.pending => 'Pending',
        PaymentStatus.partiallyPaid => 'Partially Paid',
        PaymentStatus.cancelled => 'Cancelled',
      };

  static PaymentStatus fromStorage(String value) {
    return PaymentStatus.values.firstWhere(
      (e) => e.storageValue == value,
      orElse: () => PaymentStatus.pending,
    );
  }
}
