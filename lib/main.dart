import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cashup/screens/lnurl_screen.dart';
import 'package:cashup/screens/amount_screen.dart';
import 'package:cashup/bridge_generated.dart/frb_generated.dart';
import 'package:cashup/bridge_generated.dart/lib.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await RustLib.init();

  final directory = await getApplicationDocumentsDirectory();

  final existingClient = LnurlClient.load(dataDir: directory.path);

  runApp(MyApp(existingClient: existingClient));
}

class MyApp extends StatelessWidget {
  final LnurlClient? existingClient;

  const MyApp({super.key, this.existingClient});

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        title: 'Cashup Terminal',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFF7931A)),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(centerTitle: true),
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xFFF7931A),
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(centerTitle: true),
        ),
        themeMode: ThemeMode.dark,
        home:
            existingClient != null
                ? AmountScreen(lnurlClient: existingClient!)
                : const LnurlScreen(),
      ),
    );
  }
}
