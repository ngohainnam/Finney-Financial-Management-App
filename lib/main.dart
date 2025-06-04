import 'package:finney/shared/theme/app_color.dart';
import 'package:finney/shared/localization/locales.dart';
import 'package:finney/core/network/no_internet_screen.dart';
import 'package:finney/pages/1-auth/auth_page.dart';
import 'package:finney/pages/9-setting/language_selection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:finney/shared/path/api_key.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:finney/shared/utils/notification_service.dart';
import 'package:finney/core/storage/cloud/firebase_options.dart';
import 'package:finney/core/storage/storage_manager.dart';
import 'pages/1-auth/presentation/inactivity_handler.dart';
import 'package:finney/pages/1-auth/presentation/pin_creation.dart';
import 'package:finney/pages/1-auth/presentation/pin_entry.dart';
import 'shared/utils/global_navigator.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterLocalization.instance.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await StorageManager().initialize();
  Gemini.init(apiKey: geminiApiKey);

  // Timezone config
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Dhaka'));

  // Notification init
  await NotificationService.init();

  // Show daily notification if not already shown today
  final prefs = await SharedPreferences.getInstance();
  final today = DateTime.now().toIso8601String().substring(0, 10);
  final lastShown = prefs.getString('startup_notification_last_date') ?? '';
  if (lastShown != today) {
    await NotificationService.showStartupReminder();
    await prefs.setString('startup_notification_last_date', today);
  }

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

  Future<Widget> _getInitialPage(User user) async {
    final storage = FlutterSecureStorage();
    final storedPin = await storage.read(key: 'pin_${user.uid}');
    return storedPin == null || storedPin.isEmpty ? const PinCreationPage() : const PinEntryPage();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return MaterialApp(
        theme: ThemeData(
          primaryColor: AppColors.primary,
          fontFamily: 'NotoSerifBengali',
        ),
        home: const Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    final hasLanguage = _prefs.containsKey('language');

    final app = MaterialApp(
      navigatorKey: navigatorKey,
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
          if (authSnapshot.hasData) {
            return FutureBuilder<Widget>(
              future: _getInitialPage(authSnapshot.data!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(body: Center(child: CircularProgressIndicator()));
                }
                return snapshot.data ?? const AuthPage();
              },
            );
          }
          return const AuthPage();
        },
      ),
    );

    return InternetConnectionHandler(child: InactivityHandler(child: app));
  }
}
