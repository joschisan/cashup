import 'package:flutter/material.dart';
import 'package:cashup/widgets/async_button_widget.dart';
import 'package:cashup/widgets/amount_display_widget.dart';

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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: AmountDisplay(
                    amountFiat: amountFiat,
                    amountSats: amountSats,
                    currencySymbol: currencySymbol,
                  ),
                ),
              ),
              const Icon(Icons.check_circle, color: Colors.green, size: 200),
              const Expanded(child: SizedBox()),
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
