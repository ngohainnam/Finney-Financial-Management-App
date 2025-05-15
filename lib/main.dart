import 'package:finney/assets/theme/app_color.dart';
import 'package:finney/assets/localization/locales.dart';
import 'package:finney/pages/onboarding/onboarding.dart';
import 'package:finney/pages/auth/auth_page.dart';
import 'package:finney/pages/language_selection.dart';
import 'package:finney/pages/layout.dart';
import 'package:finney/utils/currency_formatter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:finney/assets/path/api.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/storage/cloud/firebase_options.dart';
import 'package:finney/core/storage/storage_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterLocalization.instance.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize StorageManager (handles Hive setup, adapters, and box opening)
  await StorageManager().initialize();

  // Initialize app settings
  await initializeAppSettings();

  // Initialize Gemini AI
  Gemini.init(apiKey: geminiApiKey);
  
  runApp(const MyApp());
}

/// Initialize app settings from storage
Future<void> initializeAppSettings() async {
  try {
    // Initialize currency from settings box
    if (Hive.isBoxOpen('settings')) {
      final settingsBox = Hive.box('settings');
      final savedCurrency = settingsBox.get('currency', defaultValue: 'BDT') as String;
      CurrencyFormatter.updateCurrency(savedCurrency);
    }
    
    // Check for first-time onboarding status
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('onboarding_completed')) {
      await prefs.setBool('onboarding_completed', false);
    }
  } catch (e) {
    debugPrint('Error initializing app settings: $e');
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterLocalization localization = FlutterLocalization.instance;

  @override
  void initState() {
    configureLocalization();
    super.initState();
  }

  void configureLocalization() {
    var box = Hive.box('appSettings');
    String initLanguageCode = box.get('language', defaultValue: 'en') as String;
    localization.init(
      mapLocales: [
        MapLocale('en', LocaleData.en),
        MapLocale('bn', LocaleData.bd),
      ],
      initLanguageCode: initLanguageCode,
    );
    localization.onTranslatedLanguage = onTranslatedLanguage;
  }

  void onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var box = Hive.box('appSettings');
    bool hasLanguage = box.containsKey('language');

    if (!hasLanguage) {
      return MaterialApp(
        theme: ThemeData(
          primaryColor: AppColors.primary,
          fontFamily: 'NotoSerifBengali',
          textTheme: const TextTheme(
            headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            bodyMedium: TextStyle(fontSize: 14),
          ),
        ),
        debugShowCheckedModeBanner: false,
        locale: localization.currentLocale,
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('bn', 'BD'),
        ],
        localizationsDelegates: localization.localizationsDelegates,
        home: const LanguageSelectionPage(),
      );
    }

    return MaterialApp(
      theme: ThemeData(
        primaryColor: AppColors.primary,
        fontFamily: 'NotoSerifBengali',
        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          bodyMedium: TextStyle(fontSize: 14),
        ),
      ),
      debugShowCheckedModeBanner: false,
      locale: localization.currentLocale,
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('bn', 'BD'),
      ],
      localizationsDelegates: localization.localizationsDelegates,
      home: FutureBuilder<bool>(
        future: _checkFirstTimeUser(),
        builder: (context, prefSnapshot) {
          // Still loading preferences
          if (!prefSnapshot.hasData) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          
          // Check if this is a first-time user that needs onboarding
          final needsOnboarding = prefSnapshot.data == true;
          
          return StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, authSnapshot) {
              if (authSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(body: Center(child: CircularProgressIndicator()));
              }
              
              // User is logged in
              if (authSnapshot.hasData) {
                // Show onboarding if it's the first time
                if (needsOnboarding) {
                  return Onboarding(
                    onComplete: () {
                      setState(() {});  // Refresh to show main app
                    },
                  );
                }
                // Otherwise show the main app layout
                return const MainLayout();
              }
              
              // User is not logged in, show auth page
              return const AuthPage();
            },
          );
        },
      ),
    );
  }
  
  Future<bool> _checkFirstTimeUser() async {
    final prefs = await SharedPreferences.getInstance();
    final hasCompletedOnboarding = prefs.getBool('onboarding_completed') ?? false;
    return !hasCompletedOnboarding;
  }
}