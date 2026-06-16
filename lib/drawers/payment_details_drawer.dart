import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:cashup/bridge_generated.dart/lib.dart';
import 'package:cashup/widgets/bordered_list_widget.dart';
import 'package:cashup/widgets/detail_row_widget.dart';
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
      icon: PhosphorIconsRegular.lightning,
      title: 'Lightning Receive',
      children: [
        BorderedList.column(
          children: [
            DetailRow(
              icon: PhosphorIconsRegular.currencyBtc,
              label: 'Amount in Bitcoin',
              value:
                  '${NumberFormat('#,###').format(payment.amountMsat ~/ 1000)} sat',
            ),
            DetailRow(
              icon: PhosphorIconsRegular.currencyDollar,
              label: 'Amount in ${lnurlClient.currencyName()}',
              value:
                  '${lnurlClient.currencySymbol()} ${NumberFormat('#,##0.00').format(payment.amountFiat / 100)}',
            ),
            DetailRow(
              icon: PhosphorIconsRegular.calendarBlank,
              label: 'Date',
              value: DateFormat('EEEE d MMMM, HH:mm').format(
                DateTime.fromMillisecondsSinceEpoch(payment.createdAt),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
