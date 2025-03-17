import 'package:finney/pages/1-auth/auth_page.dart';
import 'package:finney/assets/path/api.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart'; // ✅ Import provider
import './pages/provider.dart/ExpenseProvider.dart'; // ✅ Import your ExpenseProvider

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Gemini.init(apiKey: geminiApiKey);

  runApp(
    // ✅ Wrap your app with ChangeNotifierProvider
    ChangeNotifierProvider(
      create: (context) => ExpenseProvider(), // ✅ Initialize ExpenseProvider
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPage(), // Your existing home page
    );
  }
}
