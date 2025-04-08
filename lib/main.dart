import 'package:finney/assets/theme/app_color.dart';
import 'package:finney/pages/2-chatbot/models/chat_message_model.dart';
import 'package:finney/pages/1-auth/auth_page.dart';
import 'package:finney/assets/path/api.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'firebase_options.dart';
import 'pages/1-auth/models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(ChatMessageModelAdapter());
  await Hive.openBox<UserModel>('userBox');
  await Hive.openBox<ChatMessageModel>('chatMessage');

  Gemini.init(
    apiKey: geminiApiKey,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: AppColors.primary,
        fontFamily: 'Poppins',
      ),
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
    );
  }
}
