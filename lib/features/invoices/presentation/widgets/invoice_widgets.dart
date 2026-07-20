import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/entities/invoice_enums.dart';

class PaymentBadge extends StatelessWidget {
  const PaymentBadge({super.key, required this.status});

  final PaymentStatus status;

  Color get _color => switch (status) {
        PaymentStatus.paid => AppColors.success,
        PaymentStatus.pending => AppColors.warning,
        PaymentStatus.partiallyPaid => AppColors.info,
        PaymentStatus.cancelled => AppColors.grey500,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.label,
        style: AppTextStyles.labelSmall.copyWith(
          color: _color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class InvoiceCard extends StatelessWidget {
  const InvoiceCard({
    super.key,
    required this.invoice,
    this.onTap,
    this.currencySymbol = '\$',
  });

  final Invoice invoice;
  final VoidCallback? onTap;
  final String currencySymbol;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(symbol: currencySymbol);
    final dateFmt = DateFormat.yMMMd();

    return AppCard(
      onTap: onTap,
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  invoice.invoiceNumber,
                  style: AppTextStyles.titleSmall.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              PaymentBadge(status: invoice.paymentStatus),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            [
              invoice.customerName ?? 'Customer',
              if (invoice.vehicleDisplayName != null)
                invoice.vehicleDisplayName!,
            ].join(' · '),
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey600),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Text(
                dateFmt.format(invoice.invoiceDate),
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.grey500,
                ),
              ),
              const Spacer(),
              Text(
                currency.format(invoice.grandTotal),
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class InvoiceSummary extends StatelessWidget {
  const InvoiceSummary({
    super.key,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.grandTotal,
    this.currencySymbol = '\$',
  });

  final double subtotal;
  final double discount;
  final double tax;
  final double grandTotal;
  final String currencySymbol;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(symbol: currencySymbol);
    Widget row(String label, String value, {bool bold = false}) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Text(
              label,
              style: bold
                  ? AppTextStyles.titleSmall
                  : AppTextStyles.bodyMedium.copyWith(color: AppColors.grey600),
            ),
            const Spacer(),
            Text(
              value,
              style: bold
                  ? AppTextStyles.titleSmall.copyWith(
                      fontWeight: FontWeight.w700,
                    )
                  : AppTextStyles.bodyMedium,
            ),
          ],
        ),
      );
    }

    return AppCard(
      child: Column(
        children: [
          row('Subtotal', currency.format(subtotal)),
          row('Discount', currency.format(discount)),
          row('Tax', currency.format(tax)),
          const Divider(),
          row('Grand Total', currency.format(grandTotal), bold: true),
        ],
      ),
    );
  }
}
