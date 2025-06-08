import 'package:finney/shared/localization/locales.dart';
import 'package:finney/shared/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:finney/shared/widgets/common/my_button.dart';

class ProfileDialog extends StatelessWidget {
  final String initialName;
  final String email;

  const ProfileDialog({
    super.key,
    required this.initialName,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 38,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: Icon(Icons.person, size: 48, color: AppColors.primary),
              ),
              const SizedBox(height: 18),
              Text(
                LocaleData.profileInformation.getString(context),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 24),
              // Name (display only)
              _profileField(
                context,
                icon: Icons.person,
                label: LocaleData.fullName.getString(context),
                value: initialName,
              ),
              // Gmail (display only)
              _profileField(
                context,
                icon: Icons.email,
                label: LocaleData.email.getString(context),
                value: email,
              ),
              const SizedBox(height: 24),
              MyButton(
                text: LocaleData.close.getString(context),
                backgroundColor: AppColors.darkBlue,
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileField(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    value,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}