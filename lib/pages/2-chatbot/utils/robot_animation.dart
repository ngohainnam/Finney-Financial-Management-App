import 'package:flutter/material.dart';
import 'package:finney/assets/theme/app_color.dart';
import 'package:lottie/lottie.dart';

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
      padding: const EdgeInsets.only(top: 5, bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.softGray.withValues(alpha: 0.5),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
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
                isTyping ? 'lib/animations/robot_typing.json' : 'lib/animations/robot_idle.json',
                repeat: true,
                frameRate: FrameRate.max, 
                fit: BoxFit.contain, 
              ),
            ),

            Text(
              isTyping ? "Thinking..." : "",
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