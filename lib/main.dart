import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'package:finney/firebase_options.dart';
import 'package:finney/assets/path/api.dart';
import 'package:finney/assets/theme/app_color.dart';
import 'package:finney/localization/locales.dart';
import 'package:finney/pages/0-onboarding/onboarding.dart';
import 'package:finney/pages/1-auth/auth_page.dart';
import 'package:finney/pages/1-auth/models/user_model.dart';
import 'package:finney/pages/2-chatbot/models/chat_message_model.dart';
import 'package:finney/pages/3-dashboard/models/transaction_model.dart';
import 'package:finney/pages/5-learn/quiz/quiz_result_model.dart';
import 'package:finney/pages/language_selection.dart';
import 'package:finney/pages/layout.dart';
import 'package:finney/utils/currency_formatter.dart';
import 'package:finney/utils/notification_service.dart';

import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Step 1: Initialize all services
  await FlutterLocalization.instance.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  tz.initializeTimeZones();
  await NotificationService.init();

  await NotificationService.requestPermission();


  final adapters = {
    0: () => Hive.registerAdapter(UserModelAdapter()),
    1: () => Hive.registerAdapter(ChatMessageModelAdapter()),
    2: () => Hive.registerAdapter(TransactionModelAdapter()),
    3: () => Hive.registerAdapter(QuizResultAdapter()),
  };
  adapters.forEach((id, fn) {
    if (!Hive.isAdapterRegistered(id)) fn();
  });

  await Hive.openBox<UserModel>('userBox');
  await Hive.openBox<ChatMessageModel>('chatMessage');
  await Hive.openBox<TransactionModel>('transactions');
  await Hive.openBox('learning_progress');
  await Hive.openBox<QuizResult>('quiz_results');
  await Hive.openBox('appSettings');
  await Hive.openBox('settings');

  await initializeAppSettings();

  Gemini.init(apiKey: geminiApiKey);

  runApp(const MyApp());
}

Future<void> initializeAppSettings() async {
  final prefs = await SharedPreferences.getInstance();

  if (!prefs.containsKey('onboarding_completed')) {
    await prefs.setBool('onboarding_completed', false);
  }

  if (Hive.isBoxOpen('settings')) {
    final settingsBox = Hive.box('settings');
    final savedCurrency = settingsBox.get('currency', defaultValue: 'BDT') as String;
    CurrencyFormatter.updateCurrency(savedCurrency);
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
    super.initState();
    configureLocalization();
  }

  void configureLocalization() {
    final box = Hive.box('appSettings');
    String initLang = box.get('language', defaultValue: 'en') as String;

    localization.init(
      mapLocales: [MapLocale('en', LocaleData.en), MapLocale('bn', LocaleData.bd)],
      initLanguageCode: initLang,
    );
    localization.onTranslatedLanguage = (_) => setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('appSettings');
    final bool hasLanguage = box.containsKey('language');

    final theme = ThemeData(
      primaryColor: AppColors.primary,
      fontFamily: 'NotoSerifBengali',
      textTheme: const TextTheme(
        headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        bodyMedium: TextStyle(fontSize: 14),
      ),
    );

    return MaterialApp(
      theme: theme,
      debugShowCheckedModeBanner: false,
      locale: localization.currentLocale,
      supportedLocales: const [Locale('en', 'US'), Locale('bn', 'BD')],
      localizationsDelegates: localization.localizationsDelegates,
      home: hasLanguage ? _getHomeWidget() : const LanguageSelectionPage(),
    );
  }

  Widget _getHomeWidget() {
    return FutureBuilder<bool>(
      future: _checkFirstTimeUser(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final needsOnboarding = snapshot.data == true;

        return StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, authSnapshot) {
            if (authSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }

            if (authSnapshot.hasData) {
              return needsOnboarding
                  ? Onboarding(onComplete: () => setState(() {}))
                  : const MainLayout();
            }

            return const AuthPage();
          },
        );
      },
    );
  }

  Future<bool> _checkFirstTimeUser() async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool('onboarding_completed') ?? false);
  }
}
