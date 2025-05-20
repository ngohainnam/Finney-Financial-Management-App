import 'package:finney/shared/theme/app_color.dart';
import 'package:finney/shared/localization/locales.dart';
import 'package:finney/core/network/no_internet_screen.dart';
import 'package:finney/pages/3-dashboard/dashboard.dart';
import 'package:finney/pages/0-onboarding/onboarding.dart';
import 'package:finney/pages/1-auth/auth_page.dart';
import 'package:finney/pages/9-setting/language_selection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:finney/shared/path/api_key.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_localization/flutter_localization.dart';
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

  // Initialize StorageManager (now just initializes Firebase and connectivity services)
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
    // Initialize currency from shared preferences
    final prefs = await SharedPreferences.getInstance();
    
    // Check for first-time onboarding status
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
  late SharedPreferences _prefs;
  bool _initialized = false;
  String _languageCode = 'en';

  @override
  void initState() {
    _loadPreferences();
    super.initState();
  }

  Future<void> _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _languageCode = _prefs.getString('language') ?? 'en';
    
    configureLocalization();
    
    setState(() {
      _initialized = true;
    });
  }

  void configureLocalization() {
    localization.init(
      mapLocales: [
        MapLocale('en', LocaleData.en),
        MapLocale('bn', LocaleData.bd),
      ],
      initLanguageCode: _languageCode,
    );
    localization.onTranslatedLanguage = onTranslatedLanguage;
  }

  void onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Show loading spinner while initializing preferences
    if (!_initialized) {
      return MaterialApp(
        theme: ThemeData(
          primaryColor: AppColors.primary,
          fontFamily: 'NotoSerifBengali',
        ),
        home: const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    // Check if language is set
    bool hasLanguage = _prefs.containsKey('language');
    
    // Wrap the entire app with InternetConnectionHandler
    return InternetConnectionHandler(
      child: MaterialApp(
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
        home: !hasLanguage 
          ? const LanguageSelectionPage()
          : FutureBuilder<bool>(
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
                      return const Dashboard();
                    }
                    
                    // User is not logged in, show auth page
                    return const AuthPage();
                  },
                );
              },
            ),
      ),
    );
  }
  
  Future<bool> _checkFirstTimeUser() async {
    final hasCompletedOnboarding = _prefs.getBool('onboarding_completed') ?? false;
    return !hasCompletedOnboarding;
  }
  
  // Method to save language preference
  Future<void> saveLanguagePreference(String languageCode) async {
    await _prefs.setString('language', languageCode);
    setState(() {
      _languageCode = languageCode;
    });
  }
}