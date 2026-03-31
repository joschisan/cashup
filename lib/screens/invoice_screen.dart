import 'package:flutter/material.dart';
import 'package:cashup/bridge_generated.dart/lib.dart';
import 'package:cashup/widgets/amount_display_widget.dart';
import 'package:cashup/widgets/qr_code_widget.dart';
import 'package:cashup/drawers/dismiss_invoice_drawer.dart';
import 'package:cashup/utils/notification_utils.dart';
import 'package:cashup/screens/confirmation_screen.dart';
import 'package:cashup/utils/async_button_mixin.dart';
import 'package:cashup/utils/styles.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

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
        icon: const Icon(PhosphorIconsRegular.arrowLeft),
        onPressed: () => DismissInvoiceDrawer.show(context),
      ),
    ),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            QrCodeWidget(
              data: widget.invoice.raw(),
              iconAsset: 'assets/qr_icon_lightning.png',
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AmountDisplay(
                    amountFiat: widget.amountFiat,
                    amountSats: widget.invoice.amountMsat() ~/ 1000,
                    currencySymbol: widget.lnurlClient.currencySymbol(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildSmallSpinner(context),
                      const SizedBox(width: 12),
                      Text(
                        'Waiting for payment...',
                        style: smallStyle.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
