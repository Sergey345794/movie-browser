import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app.dart';
import 'core/l10n/app_localizations.dart';
import 'core/logging/talker_service.dart';
import 'core/storage/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load localization early
  final l10n = await AppLocalizations.loadWithoutContext();

  // Load .env file
  await dotenv.load(fileName: ".env");

  // Get API key from .env or fallback to dart-define
  final apiKey = dotenv.env['OMDB_API_KEY'] ??
      const String.fromEnvironment('OMDB_API_KEY');

  final talkerService = TalkerService();

  talkerService.info(l10n.logAppStarting);
  talkerService.info(l10n.logApiKeyConfigured(apiKey.isNotEmpty));

  if (apiKey.isEmpty) {
    talkerService.error(l10n.logInvalidApiKey);
    runApp(const _ApiKeyErrorApp());
    return;
  }

  final hiveService = HiveService(
    talkerService: talkerService,
    l10n: l10n,
  );
  await hiveService.init();

  runApp(
    MovieBrowserApp(
      apiKey: apiKey,
      talkerService: talkerService,
      hiveService: hiveService,
      l10n: l10n,
    ),
  );
}

class _ApiKeyErrorApp extends StatelessWidget {
  const _ApiKeyErrorApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      supportedLocales: const [
        Locale('en'),
        Locale('he'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Builder(
        builder: (context) {
          final l10n = AppLocalizations.of(context);
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      l10n.apiKeyRequired,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.apiKeyInstructions,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
