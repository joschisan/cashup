import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cashup/widgets/async_button_widget.dart';
import 'package:cashup/bridge_generated.dart/lib.dart';
import 'package:cashup/screens/invoice_screen.dart';
import 'package:cashup/screens/cashup_screen.dart';
import 'package:cashup/utils/styles.dart';

class AmountScreen extends StatefulWidget {
  final LnurlClient lnurlClient;

  const AmountScreen({super.key, required this.lnurlClient});

  @override
  State<AmountScreen> createState() => _AmountScreenState();
}

class _AmountScreenState extends State<AmountScreen> {
  int _amountFiat = 0;

  void _onKeyboardTap(int value) {
    if (_amountFiat > 9999999999) return;

    setState(() {
      _amountFiat = (_amountFiat * 10) + value;
    });

    widget.lnurlClient.updateCaches();
  }

  void _onBackspace() {
    if (_amountFiat > 0) {
      setState(() {
        _amountFiat = _amountFiat ~/ 10;
      });
    }
  }

  void _onClear() {
    setState(() {
      _amountFiat = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Amount'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          CashupScreen(lnurlClient: widget.lnurlClient),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${widget.lnurlClient.currencySymbol()} ${NumberFormat('#,##0.00').format(_amountFiat / 100)}',
                      style: heroStyle.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.lnurlClient.currencyName(),
                      style: mediumStyle.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: AsyncButton(text: 'Continue', onPressed: _handleSubmit),
            ),

            const SizedBox(height: 16),

            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 2.0,
              children: [
                _buildNumberButton(1),
                _buildNumberButton(2),
                _buildNumberButton(3),
                _buildNumberButton(4),
                _buildNumberButton(5),
                _buildNumberButton(6),
                _buildNumberButton(7),
                _buildNumberButton(8),
                _buildNumberButton(9),
                _buildActionButton(Icons.clear, _onClear),
                _buildNumberButton(0),
                _buildActionButton(Icons.arrow_back, _onBackspace),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberButton(int number) {
    return Material(
      color: Colors.transparent,
      borderRadius: borderRadiusLarge,
      child: InkWell(
        borderRadius: borderRadiusLarge,
        onTap: () => _onKeyboardTap(number),
        child: Center(
          child: Text(
            number.toString(),
            style: largeStyle.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      borderRadius: borderRadiusLarge,
      child: InkWell(
        borderRadius: borderRadiusLarge,
        onTap: onTap,
        child: Center(child: Icon(icon, size: smallIconSize)),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (_amountFiat == 0) {
      throw Exception('Please enter an amount');
    }

    final invoice = await widget.lnurlClient.resolve(amountFiat: _amountFiat);

    if (!mounted) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => InvoiceScreen(
              lnurlClient: widget.lnurlClient,
              amountFiat: _amountFiat,
              invoice: invoice,
            ),
      ),
    );

    if (!mounted) return;

    setState(() {
      _amountFiat = 0;
    });
  }
}
