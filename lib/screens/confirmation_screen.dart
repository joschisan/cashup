import 'package:flutter/material.dart';
import '../widgets/action_button.dart';
import '../widgets/amount_display.dart';

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
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 1000),
                curve: Curves.elasticOut,
                builder:
                    (context, scale, child) =>
                        Transform.scale(scale: scale, child: child),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 200,
                ),
              ),
              const Expanded(child: SizedBox()),
              ActionButton(
                text: 'Continue',
                onPressed: () {
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
