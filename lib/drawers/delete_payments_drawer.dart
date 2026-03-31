import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:cashup/bridge_generated.dart/lib.dart';
import 'package:cashup/widgets/async_button_widget.dart';
import 'package:cashup/widgets/drawer_shell_widget.dart';
import 'package:cashup/utils/drawer_utils.dart';

class DeletePaymentsDrawer extends StatefulWidget {
  final LnurlClient lnurlClient;
  final VoidCallback onSuccess;

  const DeletePaymentsDrawer({
    super.key,
    required this.lnurlClient,
    required this.onSuccess,
  });

  static Future<void> show(
    BuildContext context, {
    required LnurlClient lnurlClient,
    required VoidCallback onSuccess,
  }) {
    return DrawerUtils.show(
      context: context,
      child: DeletePaymentsDrawer(
        lnurlClient: lnurlClient,
        onSuccess: onSuccess,
      ),
    );
  }

  @override
  State<DeletePaymentsDrawer> createState() => _DeletePaymentsDrawerState();
}

class _DeletePaymentsDrawerState extends State<DeletePaymentsDrawer> {
  Future<void> _handleConfirm() async {
    widget.lnurlClient.deletePayments();
    Navigator.pop(context);
    widget.onSuccess();
  }

  @override
  Widget build(BuildContext context) {
    return DrawerShell(
      icon: PhosphorIconsRegular.trash,
      title: 'Delete Payment History?',
      children: [AsyncButton(text: 'Confirm', onPressed: _handleConfirm)],
    );
  }
}
