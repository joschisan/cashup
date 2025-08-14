import 'package:flutter/material.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cashup/bridge_generated.dart/lib.dart';
import 'package:cashup/widgets/drawer_shell_widget.dart';
import 'package:cashup/widgets/async_button_widget.dart';
import 'package:cashup/utils/drawer_utils.dart';
import 'package:cashup/screens/amount_screen.dart';

class ConfirmCurrencyDrawer extends StatefulWidget {
  final Currency currency;
  final LnUrlWrapper lnurlWrapper;

  const ConfirmCurrencyDrawer({
    super.key,
    required this.currency,
    required this.lnurlWrapper,
  });

  static Future<void> show(
    BuildContext context, {
    required Currency currency,
    required LnUrlWrapper lnurlWrapper,
  }) {
    return DrawerUtils.show(
      context: context,
      child: ConfirmCurrencyDrawer(
        currency: currency,
        lnurlWrapper: lnurlWrapper,
      ),
    );
  }

  @override
  State<ConfirmCurrencyDrawer> createState() => _ConfirmCurrencyDrawerState();
}

class _ConfirmCurrencyDrawerState extends State<ConfirmCurrencyDrawer> {
  Future<void> _handleConfirm() async {
    final dir = await getApplicationDocumentsDirectory();

    LnurlClient.persist(
      dataDir: dir.path,
      lnurl: widget.lnurlWrapper,
      currencyCode: widget.currency.code,
      currencySymbol: widget.currency.symbol,
      currencyName: widget.currency.name,
    );

    final client = LnurlClient.load(dataDir: dir.path);

    if (!mounted || client == null) return;

    Navigator.pop(context); // Close drawer

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AmountScreen(lnurlClient: client),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DrawerShell(
      icon: Icons.currency_exchange,
      title: 'Select ${widget.currency.name}?',
      children: [AsyncButton(text: 'Confirm', onPressed: _handleConfirm)],
    );
  }
}
