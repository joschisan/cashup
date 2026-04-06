import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter/material.dart';
import 'package:cashup/bridge_generated.dart/lib.dart';
import 'package:cashup/utils/styles.dart';
import 'package:cashup/widgets/grouped_list_widget.dart';
import 'package:cashup/widgets/search_field_widget.dart';

class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({super.key});

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  String _query = '';

  List<FiatCurrency> get _filtered =>
      listFiatCurrencies()
          .where(
            (c) =>
                c.code.toLowerCase().contains(_query.toLowerCase()) ||
                c.name.toLowerCase().contains(_query.toLowerCase()),
          )
          .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Currency')),
      body: GroupedList<FiatCurrency>(
        items: _filtered,
        header: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: SearchField(
            onChanged: (value) => setState(() => _query = value),
          ),
        ),
        groupKey: (currency) => currency.code[0],
        itemBuilder:
            (context, currency) => ListTile(
              contentPadding: listTilePadding,
              leading: PhosphorIcon(
                PhosphorIconsRegular.currencyDollar,
                color: Theme.of(context).colorScheme.primary,
                size: mediumIconSize,
              ),
              title: Text(currency.name, style: mediumStyle),
              onTap: () => Navigator.pop(context, currency),
            ),
      ),
    );
  }
}
