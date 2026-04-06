import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:cashup/bridge_generated.dart/lib.dart';
import 'package:cashup/drawers/scanner_drawer.dart';
import 'package:cashup/screens/currency_screen.dart';
import 'package:cashup/screens/amount_screen.dart';
import 'package:cashup/widgets/async_button_widget.dart';
import 'package:cashup/widgets/bordered_list_widget.dart';
import 'package:cashup/utils/styles.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  LnUrlWrapper? _lnurlWrapper;
  FiatCurrency? _currency;

  bool get _isComplete => _lnurlWrapper != null && _currency != null;

  Future<void> _scanPaymentCode() async {
    final result = await ScannerDrawer.show(context);
    if (result != null) {
      setState(() => _lnurlWrapper = result);
    }
  }

  Future<void> _selectCurrency() async {
    final result = await Navigator.push<FiatCurrency>(
      context,
      MaterialPageRoute(builder: (context) => const CurrencyScreen()),
    );
    if (result != null) {
      setState(() => _currency = result);
    }
  }

  Future<void> _handleConfirm() async {
    final dir = await getApplicationDocumentsDirectory();

    LnurlClient.persist(
      dataDir: dir.path,
      lnurl: _lnurlWrapper!,
      currencyCode: _currency!.code,
      currencySymbol: _currency!.symbol,
      currencyName: _currency!.name,
    );

    final client = LnurlClient.load(dataDir: dir.path);

    if (!mounted || client == null) return;

    Navigator.pop(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AmountScreen(lnurlClient: client),
      ),
    );
  }

  Widget _buildLeading(
    BuildContext context,
    bool complete,
    IconData incompleteIcon,
  ) => PhosphorIcon(
    complete ? PhosphorIconsFill.checkCircle : incompleteIcon,
    color:
        complete
            ? Colors.green
            : Theme.of(context).colorScheme.onSurfaceVariant,
    size: largeIconSize,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Setup')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              BorderedList.column(
                children: [
                  ListTile(
                    contentPadding: listTilePadding,
                    leading: _buildLeading(
                      context,
                      _lnurlWrapper != null,
                      PhosphorIconsRegular.lightning,
                    ),
                    title: const Text('Enter Payment Code', style: mediumStyle),
                    subtitle:
                        _lnurlWrapper != null
                            ? Text(
                              _lnurlWrapper!.toString(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                            : const Text('Tap to scan or paste'),
                    onTap: _scanPaymentCode,
                  ),
                  ListTile(
                    contentPadding: listTilePadding,
                    leading: _buildLeading(
                      context,
                      _currency != null,
                      PhosphorIconsRegular.currencyDollar,
                    ),
                    title: const Text('Select Currency', style: mediumStyle),
                    subtitle:
                        _currency != null
                            ? Text('${_currency!.name} (${_currency!.code})')
                            : const Text('Tap to select'),
                    onTap: _selectCurrency,
                  ),
                ],
              ),
              const Spacer(),
              if (_isComplete)
                AsyncButton(text: 'Confirm', onPressed: _handleConfirm),
            ],
          ),
        ),
      ),
    );
  }
}
