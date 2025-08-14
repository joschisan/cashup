import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:cashup/bridge_generated.dart/lib.dart';
import 'package:cashup/widgets/amount_display_widget.dart';
import 'package:cashup/drawers/dismiss_invoice_drawer.dart';
import 'package:cashup/utils/notification_utils.dart';
import 'package:cashup/screens/confirmation_screen.dart';

class InvoiceScreen extends StatefulWidget {
  final LnurlClient lnurlClient;
  final int amountFiat;
  final Invoice invoice;

  const InvoiceScreen({
    super.key,
    required this.lnurlClient,
    required this.amountFiat,
    required this.invoice,
  });

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  @override
  void initState() {
    super.initState();
    _startPaymentVerification();
  }

  void _startPaymentVerification() async {
    try {
      await widget.invoice.verifyPayment();

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => ConfirmationScreen(
                currencySymbol: widget.lnurlClient.currencySymbol(),
                amountFiat: widget.amountFiat,
                amountSats: widget.invoice.amountMsat() ~/ 1000,
              ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      NotificationUtils.showError(context, e.toString());
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Lightning Invoice'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => DismissInvoiceDrawer.show(context),
      ),
    ),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Top section: Amount centered in available space
            Expanded(
              child: Center(
                child: AmountDisplay(
                  amountFiat: widget.amountFiat,
                  amountSats: widget.invoice.amountMsat() ~/ 1000,
                  currencySymbol: widget.lnurlClient.currencySymbol(),
                ),
              ),
            ),
            // Center: QR code
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black, width: 1),
              ),
              child: PrettyQrView.data(
                data: widget.invoice.raw(),
                decoration: const PrettyQrDecoration(
                  shape: PrettyQrSmoothSymbol(color: Colors.black),
                  background: Colors.white,
                ),
              ),
            ),
            // Bottom section: Loading indicator centered in available space
            Expanded(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary,
                        strokeWidth: 2,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Waiting for payment...',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
