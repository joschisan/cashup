import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:cashup/bridge_generated.dart/lib.dart';
import 'package:cashup/widgets/primary_card_widget.dart';
import 'package:cashup/widgets/amount_display_widget.dart';
import 'package:cashup/drawers/payment_details_drawer.dart';
import 'package:cashup/drawers/delete_payments_drawer.dart';
import 'package:cashup/utils/notification_utils.dart';
import 'package:cashup/utils/styles.dart';
import 'package:cashup/widgets/grouped_list_widget.dart';

class CashupScreen extends StatefulWidget {
  final LnurlClient lnurlClient;

  const CashupScreen({super.key, required this.lnurlClient});

  @override
  State<CashupScreen> createState() => _CashupScreenState();
}

class _CashupScreenState extends State<CashupScreen> {
  Widget buildPaymentTile(Payment payment) {
    return ListTile(
      contentPadding: listTilePadding,
      onTap:
          () => PaymentDetailsDrawer.show(
            context,
            payment: payment,
            lnurlClient: widget.lnurlClient,
          ),
      leading: Icon(
        PhosphorIconsRegular.lightning,
        color: Theme.of(context).colorScheme.primary,
        size: mediumIconSize,
      ),
      title: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '${widget.lnurlClient.currencySymbol()} ${NumberFormat('#,##0.00').format(payment.amountFiat / 100.0)}',
            style: mediumStyle.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      trailing: Text(
        _formatTime(payment.createdAt),
        style: smallStyle.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  String _formatTime(int createdAt) {
    final difference = DateTime.now().difference(
      DateTime.fromMillisecondsSinceEpoch(createdAt),
    );

    return switch (difference) {
      _ when difference.inMinutes < 1 => 'Now',
      _ when difference.inMinutes < 60 => '${difference.inMinutes}m ago',
      _ when difference.inHours < 24 => '${difference.inHours}h ago',
      _ => '${difference.inDays}d ago',
    };
  }

  static String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateDay = DateTime(date.year, date.month, date.day);
    final difference = today.difference(dateDay).inDays;

    return switch (difference) {
      0 => 'Today',
      1 => 'Yesterday',
      _ => DateFormat('EEEE d MMMM').format(date),
    };
  }

  Future<void> _saveTransactions(BuildContext context) async {
    try {
      final csvContent = widget.lnurlClient.exportTransactionsCsv();
      final bytes = Uint8List.fromList(csvContent.codeUnits);
      final date = DateFormat('yyyy-MM-dd').format(DateTime.now());

      await FilePicker.platform.saveFile(
        dialogTitle: 'Save Transaction Summary',
        fileName: 'cashup-$date.csv',
        type: FileType.custom,
        allowedExtensions: ['csv'],
        bytes: bytes,
      );
    } catch (e) {
      if (!context.mounted) return;
      NotificationUtils.showError(context, 'Failed to save: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final payments = widget.lnurlClient.listPayments();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cashup'),
        actions: [
          IconButton(
            icon: const Icon(PhosphorIconsRegular.floppyDisk),
            onPressed: () => _saveTransactions(context),
          ),
          IconButton(
            icon: const Icon(PhosphorIconsRegular.trash),
            onPressed:
                () => DeletePaymentsDrawer.show(
                  context,
                  lnurlClient: widget.lnurlClient,
                  onSuccess: () => setState(() {}),
                ),
          ),
        ],
      ),
      body: SafeArea(
        child: GroupedList<Payment>(
          items: payments,
          header: PrimaryCard(
            margin: const EdgeInsets.only(bottom: 8),
            child: AmountDisplay(
              amountFiat: widget.lnurlClient.sumAmountsFiat(),
              amountSats: widget.lnurlClient.sumAmountsMsat() ~/ 1000,
              currencySymbol: widget.lnurlClient.currencySymbol(),
            ),
          ),
          groupKey:
              (payment) => _formatDateHeader(
                DateTime.fromMillisecondsSinceEpoch(payment.createdAt),
              ),
          itemBuilder: (context, payment) => buildPaymentTile(payment),
        ),
      ),
    );
  }
}
