import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:cashup/widgets/bordered_list_widget.dart';
import 'package:cashup/widgets/detail_row_widget.dart';

class AmountDisplay extends StatelessWidget {
  final int amountFiat;
  final int amountSats;
  final String currencySymbol;
  final String currencyName;

  const AmountDisplay({
    super.key,
    required this.amountFiat,
    required this.amountSats,
    required this.currencySymbol,
    required this.currencyName,
  });

  @override
  Widget build(BuildContext context) {
    return BorderedList.column(
      children: [
        DetailRow(
          icon: PhosphorIconsRegular.currencyBtc,
          label: 'Amount in Bitcoin',
          value: '${NumberFormat('#,###').format(amountSats)} sat',
        ),
        DetailRow(
          icon: PhosphorIconsRegular.currencyDollar,
          label: 'Amount in $currencyName',
          value:
              '$currencySymbol ${NumberFormat('#,##0.00').format(amountFiat / 100)}',
        ),
      ],
    );
  }
}
