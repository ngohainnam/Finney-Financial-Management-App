import 'package:finney/pages/1-auth/auth_page.dart';
import 'package:finney/assets/path/api.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart'; // Import provider
import './pages/provider.dart/ExpenseProvider.dart'; // Import ExpenseProvider
import './pages/provider.dart/BudgetProvider.dart'; // Import BudgetProvider
import './pages/provider.dart/CategoryProvider.dart'; // Import CategoryProvider
import './pages/provider.dart/expense_screen.dart'; // Import ExpenseScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Gemini.init(apiKey: geminiApiKey);

  runApp(
    // Wrap your app with MultiProvider
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ExpenseProvider()),
        // Use ProxyProvider to pass ExpenseProvider to CategoryProvider
        ProxyProvider<ExpenseProvider, CategoryProvider>(
          update:
              (context, expenseProvider, _) =>
                  CategoryProvider(expenseProvider),
        ),

        // Use ProxyProvider to pass ExpenseProvider to BudgetProvider
        ProxyProvider<ExpenseProvider, BudgetProvider>(
          update:
              (context, expenseProvider, _) => BudgetProvider(expenseProvider),
        ),
      ],
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
      routes: {
        '/expense': (context) => ExpenseScreen(), // Add route for ExpenseScreen
      },
    );
  }
}
