import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:visualize_infinance/models/expense_model.dart';
import 'package:visualize_infinance/screens/dashboard_screen.dart';
import 'package:visualize_infinance/screens/add_transaction_screen.dart';
import 'package:visualize_infinance/utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    print("Firebase initialized successfully");
  } catch (e) {
    print("Failed to initialize Firebase: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
      ),
      themeMode: ThemeMode.system,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => const DashboardScreen());

          case '/add_transaction':
          // Get the isIncome argument
            final isIncome = settings.arguments as bool? ?? false;
            return MaterialPageRoute(
              builder: (_) => AddTransactionScreen(isIncome: isIncome),
            );

          case '/transactions':
            return MaterialPageRoute(builder: (_) => const DashboardScreen());

          default:
            return MaterialPageRoute(builder: (_) => const DashboardScreen());
        }
      },
    );
  }
}