import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cashup/bridge_generated.dart/lib.dart';
import 'package:cashup/widgets/amount_card_widget.dart';
import 'package:cashup/widgets/amount_display_widget.dart';
import 'package:cashup/widgets/drawer_shell_widget.dart';
import 'package:cashup/utils/drawer_utils.dart';

class PaymentDetailsDrawer extends StatelessWidget {
  final Payment payment;
  final LnurlClient lnurlClient;

  const PaymentDetailsDrawer({
    super.key,
    required this.payment,
    required this.lnurlClient,
  });

  static Future<void> show(
    BuildContext context, {
    required Payment payment,
    required LnurlClient lnurlClient,
  }) {
    return DrawerUtils.show(
      context: context,
      child: PaymentDetailsDrawer(payment: payment, lnurlClient: lnurlClient),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DrawerShell(
      icon: Icons.bolt,
      title: DateFormat(
        'MMM dd, HH:mm:ss',
      ).format(DateTime.fromMillisecondsSinceEpoch(payment.createdAt)),
      children: [
        AmountCard(
          child: AmountDisplay(
            amountFiat: payment.amountFiat,
            amountSats: payment.amountMsat ~/ 1000,
            currencySymbol: lnurlClient.currencySymbol(),
          ),
        ),
      ],
    );
  }
}
