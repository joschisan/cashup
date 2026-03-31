import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:cashup/widgets/async_button_widget.dart';
import 'package:cashup/widgets/amount_display_widget.dart';
import 'package:cashup/utils/styles.dart';

class ConfirmationScreen extends StatelessWidget {
  final String currencySymbol;
  final int amountFiat;
  final int amountSats;

  const ConfirmationScreen({
    super.key,
    required this.currencySymbol,
    required this.amountFiat,
    required this.amountSats,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment Confirmed')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      PhosphorIconsRegular.checkCircle,
                      color: Colors.green,
                      size: heroIconSize * 3,
                    ),
                    AmountDisplay(
                      amountFiat: amountFiat,
                      amountSats: amountSats,
                      currencySymbol: currencySymbol,
                    ),
                  ],
                ),
              ),
              AsyncButton(
                text: 'Continue',
                onPressed: () async {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
