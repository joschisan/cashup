import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:cashup/widgets/async_button_widget.dart';
import 'package:cashup/widgets/drawer_shell_widget.dart';
import 'package:cashup/utils/drawer_utils.dart';

class DismissInvoiceDrawer extends StatefulWidget {
  const DismissInvoiceDrawer({super.key});

  static Future<void> show(BuildContext context) {
    return DrawerUtils.show(
      context: context,
      child: const DismissInvoiceDrawer(),
    );
  }

  @override
  State<DismissInvoiceDrawer> createState() => _DismissInvoiceDrawerState();
}

class _DismissInvoiceDrawerState extends State<DismissInvoiceDrawer> {
  Future<void> _handleConfirm() async {
    Navigator.pop(context); // Close drawer
    Navigator.pop(context); // Go back to previous screen
  }

  @override
  Widget build(BuildContext context) {
    return DrawerShell(
      icon: PhosphorIconsRegular.warningCircle,
      title: 'Dismiss Unpaid Invoice?',
      children: [AsyncButton(text: 'Confirm', onPressed: _handleConfirm)],
    );
  }
}
