import 'package:finney/assets/theme/app_color.dart';
import 'package:finney/localization/locales.dart';
import 'package:finney/pages/1-auth/auth_page.dart';
import 'package:finney/pages/2-chatbot/models/chat_message_model.dart';
import 'package:finney/pages/3-dashboard/models/transaction_model.dart';
import 'package:finney/pages/5-learn/quiz/quiz_result_model.dart';
import 'package:finney/pages/language_selection.dart';
import 'package:finney/pages/layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'firebase_options.dart';
import 'pages/1-auth/models/user_model.dart';
import 'package:finney/assets/path/api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterLocalization.instance.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(ChatMessageModelAdapter());
  Hive.registerAdapter(QuizResultAdapter());
  Hive.registerAdapter(TransactionModelAdapter());

  // Open boxes
  await Hive.openBox<UserModel>('userBox');
  await Hive.openBox<ChatMessageModel>('chatMessage');
  await Hive.openBox('learning_progress');
  await Hive.openBox<TransactionModel>('transactions');
  await Hive.openBox<QuizResult>('quiz_results');
  await Hive.openBox('appSettings');

  // Initialize Gemini
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
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if (snapshot.hasData) {
            return const MainLayout();
          }
          return const AuthPage();
        },
      ),
    );
  }
}