import 'package:flutter/material.dart';
import 'package:cashup/bridge_generated.dart/lib.dart';
import 'package:cashup/drawers/confirm_currency_drawer.dart';
import 'package:cashup/utils/currency_utils.dart';
import 'package:cashup/utils/styles.dart';
import 'package:cashup/widgets/grouped_list_widget.dart';
import 'package:cashup/widgets/search_field_widget.dart';

class CurrencyScreen extends StatefulWidget {
  final LnUrlWrapper lnurlWrapper;

  const CurrencyScreen({super.key, required this.lnurlWrapper});

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  String _query = '';

  List<FiatCurrency> get _filtered =>
      fiatCurrencies
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
        padding: const EdgeInsets.symmetric(horizontal: 16),
        groupKey: (currency) => currency.code[0],
        itemBuilder:
            (context, currency) => ListTile(
              contentPadding: listTilePadding,
              leading: SizedBox(
                width: 64,
                child: Text(
                  currency.code,
                  textAlign: TextAlign.center,
                  style: largeStyle.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              title: Text(currency.name, style: mediumStyle),
              onTap: () {
                ConfirmCurrencyDrawer.show(
                  context,
                  currency: currency,
                  lnurlWrapper: widget.lnurlWrapper,
                );
              },
            ),
      ),
    );
  }
}
