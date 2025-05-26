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
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterLocalization.instance.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize StorageManager (now just initializes Firebase and connectivity services)
  await StorageManager().initialize();
  
  // Initialize Gemini AI
  Gemini.init(apiKey: geminiApiKey);
  
  runApp(const MyApp());
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
        MapLocale('bn', LocaleData.bn),
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
          : StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, authSnapshot) {
                if (authSnapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(body: Center(child: CircularProgressIndicator()));
                }
                
                // User is logged in
                if (authSnapshot.hasData) {
                  final user = authSnapshot.data!;
                  
                  // Check if user has completed onboarding in Firestore
                  return FutureBuilder<bool>(
                    future: _checkNeedsOnboarding(user),
                    builder: (context, onboardingSnapshot) {
                      if (onboardingSnapshot.connectionState == ConnectionState.waiting) {
                        return const Scaffold(body: Center(child: CircularProgressIndicator()));
                      }
                      
                      final needsOnboarding = onboardingSnapshot.data ?? true;
                      
                      if (needsOnboarding) {
                        return Onboarding(
                          onComplete: () async {
                            // Mark onboarding as completed in Firestore
                            await _markOnboardingCompleted(user.uid);
                            setState(() {});  // Refresh to show main app
                          },
                        );
                      }
                      
                      // Otherwise show the main app layout
                      return const Dashboard();
                    },
                  );
                }
                
                // User is not logged in, show auth page
                return const AuthPage();
              },
            ),
      ),
    );
  }
  
  // Check if user needs onboarding by looking at Firestore
  Future<bool> _checkNeedsOnboarding(User user) async {
    try {
      // First check - is this a brand new user?
      final isNewUser = user.metadata.creationTime!
          .isAfter(DateTime.now().subtract(const Duration(minutes: 1)));
      
      if (isNewUser) {
        return true; // New users always need onboarding
      }
      
      // Otherwise check the user's profile in Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      
      // If the user document doesn't exist or doesn't have onboardingCompleted field
      if (!userDoc.exists || !userDoc.data()!.containsKey('onboardingCompleted')) {
        return true;
      }
      
      // Return based on the value in Firestore
      return !(userDoc.data()!['onboardingCompleted'] as bool);
    } catch (e) {
      debugPrint('Error checking onboarding status: $e');
      return true; // Default to showing onboarding if there's an error
    }
  }
  
  // Mark onboarding as completed in Firestore
  Future<void> _markOnboardingCompleted(String userId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .set({
        'onboardingCompleted': true,
        'onboardingCompletedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error marking onboarding as completed: $e');
    }
  }
  
  // Method to save language preference
  Future<void> saveLanguagePreference(String languageCode) async {
    await _prefs.setString('language', languageCode);
    setState(() {
      _languageCode = languageCode;
    });
  }
}