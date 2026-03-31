import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cashup/utils/styles.dart';

class AmountDisplay extends StatelessWidget {
  final int amountFiat;
  final int amountSats;
  final String currencySymbol;

  const AmountDisplay({
    super.key,
    required this.amountFiat,
    required this.amountSats,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text.rich(
          TextSpan(
            text:
                '$currencySymbol ${NumberFormat('#,##0.00').format(amountFiat / 100)}',
            style: heroStyle.copyWith(fontWeight: FontWeight.bold),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text.rich(
          TextSpan(
            text: '${NumberFormat('#,###').format(amountSats)} sat',
            style: largeStyle.copyWith(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
