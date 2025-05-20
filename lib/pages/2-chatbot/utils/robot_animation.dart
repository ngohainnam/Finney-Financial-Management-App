import 'package:finney/shared/path/app_animations.dart';
import 'package:flutter/material.dart';
import 'package:finney/shared/theme/app_color.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:finney/shared/localization/locales.dart';

class RobotAnimationHeader extends StatelessWidget {
  final bool isTyping;
  
  const RobotAnimationHeader({
    super.key,
    this.isTyping = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
      ),

      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 200,
              width: 200,
              child: Lottie.asset(
                isTyping ? AppAnimations.roboTyping : AppAnimations.robotIdle,
                repeat: true,
                frameRate: FrameRate.max, 
                fit: BoxFit.contain, 
              ),
            ),

            Text(
              isTyping ? LocaleData.thinking.getString(context) : "",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}