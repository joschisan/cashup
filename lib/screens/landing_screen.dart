import 'dart:async';

import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:cashup/utils/styles.dart';
import 'package:cashup/widgets/async_button_widget.dart';
import 'package:cashup/screens/setup_screen.dart';

const _variants = [
  (PhosphorIconsRegular.lightning, 'Receive'),
  (PhosphorIconsRegular.listPlus, 'Review'),
  (PhosphorIconsRegular.floppyDisk, 'Export'),
];

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final _pageController = PageController();
  late final Timer _carouselTimer;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Spacer(),
              SizedBox(
                height: heroIconSize,
                child: PageView.builder(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final (icon, name) = _variants[index % _variants.length];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PhosphorIcon(
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
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  'Accept lightning payments.',
                  style: mediumStyle.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(),
              AsyncButton(
                text: 'Continue',
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SetupScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
