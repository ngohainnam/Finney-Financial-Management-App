import 'package:finney/assets/theme/app_color.dart';
import 'package:finney/localization/locales.dart';
import 'package:finney/pages/2-chatbot/models/chat_message_model.dart';
import 'package:finney/pages/1-auth/auth_page.dart';
import 'package:finney/assets/path/api.dart';
import 'package:finney/pages/3-dashboard/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'firebase_options.dart';
import 'pages/1-auth/models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterLocalization.instance.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(ChatMessageModelAdapter());
  Hive.registerAdapter(TransactionModelAdapter());
  await Hive.openBox<UserModel>('userBox');
  await Hive.openBox<ChatMessageModel>('chatMessage');
  await Hive.openBox<TransactionModel>('transactions');

  Gemini.init(
    apiKey: geminiApiKey,
  );
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: AppColors.primary,
        fontFamily: 'Poppins',
      ),
      debugShowCheckedModeBanner: false,
      locale: localization.currentLocale,
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('bn', 'BD'),
      ],
      localizationsDelegates: localization.localizationsDelegates,
      home: const AuthPage(),
    );
  }

  void configureLocalization() {
    localization.init(mapLocales: locales, initLanguageCode: "bn");
    localization.onTranslatedLanguage = onTranslatedLanguage;
  }

  void onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }
}