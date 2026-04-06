import 'package:flutter/material.dart';
import 'package:cashup/bridge_generated.dart/lib.dart';
import 'package:cashup/utils/drawer_utils.dart';
import 'package:cashup/utils/notification_utils.dart';
import 'package:cashup/widgets/qr_scanner_widget.dart';

class ScannerDrawer extends StatefulWidget {
  const ScannerDrawer({super.key});

  static Future<LnUrlWrapper?> show(BuildContext context) {
    return DrawerUtils.show<LnUrlWrapper>(
      context: context,
      child: const ScannerDrawer(),
    );
  }

  @override
  State<ScannerDrawer> createState() => _ScannerDrawerState();
}

class _ScannerDrawerState extends State<ScannerDrawer> {
  bool _isScanning = true;

  void _processInput(String input) {
    if (!_isScanning) return;

    try {
      final lnurlWrapper = parseLnurl(lnurl: input);
      _isScanning = false;
      Navigator.pop(context, lnurlWrapper);
    } catch (e) {
      if (mounted) {
        NotificationUtils.showError(context, e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return QrScannerWidget(onScan: _processInput);
  }
}
