import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:cashup/utils/notification_utils.dart';
import 'package:cashup/bridge_generated.dart/lib.dart';
import 'package:cashup/screens/currency_screen.dart';
import 'package:cashup/utils/styles.dart';

Widget _buildQrScanner(
  MobileScannerController controller,
  void Function(BarcodeCapture) onDetect,
  VoidCallback onPaste,
) => LayoutBuilder(
  builder: (context, constraints) {
    final size = constraints.maxWidth;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: MobileScanner(controller: controller, onDetect: onDetect),
          ),
          Positioned(
            bottom: 8,
            right: 8,
            child: IconButton(
              onPressed: onPaste,
              icon: Icon(
                PhosphorIconsRegular.clipboard,
                color: Colors.white,
                size: smallIconSize,
              ),
            ),
          ),
        ],
      ),
    );
  },
);

Future<String> _getClipboardText() async {
  try {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    final text = clipboardData?.text;
    if (text == null || text.isEmpty) {
      throw Exception('Clipboard is empty');
    }
    return text;
  } catch (e) {
    throw Exception('Clipboard access error: $e');
  }
}

const _variants = [
  (PhosphorIconsRegular.lightning, 'Receive'),
  (PhosphorIconsRegular.listPlus, 'Review'),
  (PhosphorIconsRegular.floppyDisk, 'Export'),
];

class LnurlScreen extends StatefulWidget {
  const LnurlScreen({super.key});

  @override
  State<LnurlScreen> createState() => _LnurlScreenState();
}

class _LnurlScreenState extends State<LnurlScreen> {
  final _controller = MobileScannerController();
  final _pageController = PageController();
  late final Timer _carouselTimer;
  bool _isScanning = true;

  @override
  void initState() {
    super.initState();
    _carouselTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _carouselTimer.cancel();
    _pageController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (!_isScanning) return;

    if (!mounted) return;

    if (capture.barcodes.isEmpty) return;

    if (capture.barcodes.first.rawValue == null) return;

    _processInput(capture.barcodes.first.rawValue!);
  }

  void _processInput(String lnurl) {
    try {
      final lnurlWrapper = parseLnurl(lnurl: lnurl);

      setState(() {
        _isScanning = false;
      });

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CurrencyScreen(lnurlWrapper: lnurlWrapper),
          ),
        );
      }

      return;
    } catch (e) {
      NotificationUtils.showError(context, e.toString());
    }
  }

  Future<void> _handleClipboardPaste() async {
    try {
      final text = await _getClipboardText();
      _processInput(text);
    } catch (e) {
      if (!mounted) return;
      NotificationUtils.showError(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SizedBox(
                  height: heroIconSize,
                  child: PageView.builder(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final (icon, name) = _variants[index % _variants.length];
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            icon,
                            size: heroIconSize,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            name,
                            style: heroStyle.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
            _buildQrScanner(_controller, _onDetect, _handleClipboardPaste),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Text(
                    'Scan a lightning url payment code from a lightning wallet that supports lnurl payment verification.',
                    style: smallStyle.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
