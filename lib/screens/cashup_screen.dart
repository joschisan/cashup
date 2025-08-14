import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cashup/bridge_generated.dart/lib.dart';
import 'package:cashup/widgets/amount_card_widget.dart';
import 'package:cashup/widgets/amount_display_widget.dart';
import 'package:cashup/drawers/payment_details_drawer.dart';
import 'package:cashup/drawers/delete_payments_drawer.dart';
import 'package:cashup/utils/notification_utils.dart';

class CashupScreen extends StatefulWidget {
  final LnurlClient lnurlClient;

  const CashupScreen({super.key, required this.lnurlClient});

  @override
  State<CashupScreen> createState() => _CashupScreenState();
}

class _CashupScreenState extends State<CashupScreen> {
  Widget buildPaymentTile(Payment payment) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onTap:
            () => PaymentDetailsDrawer.show(
              context,
              payment: payment,
              lnurlClient: widget.lnurlClient,
            ),
        leading: Icon(
          Icons.bolt,
          color: Theme.of(context).colorScheme.primary,
          size: 32,
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
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        trailing: Text(
          _formatTime(payment.createdAt),
          style: TextStyle(
            fontSize: 18,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }

  String _formatTime(int createdAt) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(createdAt);
    return DateFormat('HH:mm').format(dateTime);
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
            icon: const Icon(Icons.save),
            onPressed: () => _saveTransactions(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
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
        child: Column(
          children: [
            // Summary section
            Padding(
              padding: const EdgeInsets.all(16),
              child: AmountCard(
                child: AmountDisplay(
                  amountFiat: widget.lnurlClient.sumAmountsFiat(),
                  amountSats:
                      widget.lnurlClient.sumAmountsMsat() ~/
                      1000, // Convert msat to sats
                  currencySymbol: widget.lnurlClient.currencySymbol(),
                ),
              ),
            ),
            // Payment list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: payments.length,
                itemBuilder: (context, index) {
                  final payment = payments[index];
                  return buildPaymentTile(payment);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
