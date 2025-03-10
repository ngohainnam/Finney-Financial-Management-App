import 'package:finney/assets/theme/app_color.dart';
import 'package:finney/assets/widgets/app_drawer.dart';
import 'package:flutter/material.dart';

class Visualize extends StatelessWidget {
  const Visualize({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightBackground,
        title: const Text('Report'),
      ),
      drawer: const AppDrawer(),
      body: const Center(child: Text("Report page")),
    );
  }
}