import 'package:finney/pages/9-setting/change_pin.page.dart';
import 'package:finney/shared/localization/locales.dart';
import 'package:finney/pages/9-setting/language_selection.dart';
import 'package:finney/pages/9-setting/widgets/dropdown_setting.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:finney/shared/theme/app_color.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:finney/shared/widgets/common/snack_bar.dart';
import 'package:finney/shared/widgets/common/settings_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/profile_dialog.dart';
import 'widgets/setting_option.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  String fullName = '';
  String email = '';
  String selectedLanguage = 'Bengali';
  String selectedTextSize = 'Medium';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadFirebaseUser();
  }

  Future<void> _loadFirebaseUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        fullName = user.displayName ?? '';
        email = user.email ?? '';
      });
    }
  }

  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final loadedLanguage = prefs.getString('language') ?? 'bn';
      final loadedTextSize = prefs.getString('textSize') ?? 'Medium';
      if (mounted) {
        setState(() {
          selectedLanguage = loadedLanguage == 'en' ? 'English' : 'Bengali';
          selectedTextSize = loadedTextSize;
        });
        SettingsNotifier().updateTextSize(loadedTextSize);
        FlutterLocalization.instance.translate(loadedLanguage);
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
    }
  }

  Future<bool> _saveUserData({
    required String textSize,
    required String language,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String languageCode = language == 'English' ? 'en' : 'bn';
      await prefs.setString('textSize', textSize);
      await prefs.setString('language', languageCode);

      SettingsNotifier().updateTextSize(textSize);
      FlutterLocalization.instance.translate(languageCode);
      return true;
    } catch (e) {
      debugPrint('Error saving user data: $e');
      return false;
    }
  }

  void _showProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => ProfileDialog(
        initialName: fullName,
        email: email,
      ),
    );
  }

  void _showSecuritySettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChangePinPage()),
    );
  }

  void _showHelpSupport() {
    AppSnackBar.showInfo(
      context,
      message: LocaleData.helpSupportComingSoon.getString(context),
    );
  }

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      final prefs = await SharedPreferences.getInstance();
      final language = prefs.getString('language');
      await prefs.clear();
      if (language != null) {
        await prefs.setString('language', language);
      }
      AppSnackBar.showSuccess(
        context,
        message: LocaleData.logOut.getString(context),
      );
      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LanguageSelectionPage()),
        (route) => false,
      );
    } catch (e) {
      debugPrint('Sign-out error: $e');
      AppSnackBar.showError(
        context,
        message: LocaleData.queryError.getString(context),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: SettingsNotifier().textSizeNotifier,
      builder: (context, textSize, child) {
        double textScaleFactor;
        switch (textSize) {
          case 'Small':
            textScaleFactor = 0.8;
            break;
          case 'Large':
            textScaleFactor = 1.2;
            break;
          default:
            textScaleFactor = 1.0;
        }

        final languageOptions = {
          'English': LocaleData.languageEnglish.getString(context),
          'Bengali': LocaleData.languageBengali.getString(context),
        };
        final textSizeOptions = {
          'Small': LocaleData.small.getString(context),
          'Medium': LocaleData.medium.getString(context),
          'Large': LocaleData.large.getString(context),
        };

        final selectedLanguageDisplay = languageOptions.entries
            .firstWhere((entry) => entry.key == selectedLanguage)
            .value;
        final selectedTextSizeDisplay = textSizeOptions.entries
            .firstWhere((entry) => entry.key == selectedTextSize)
            .value;

        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(textScaleFactor),
          ),
          child: Scaffold(
            backgroundColor: Colors.grey[300],
            body: Stack(
              children: [
                Positioned.fill(
                  child: Column(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          color: AppColors.darkBlue,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          color: Colors.grey[300],
                        ),
                      ),
                    ],
                  ),
                ),
                SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          color: Colors.transparent,
                          width: double.infinity,
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back, color: Colors.white),
                                onPressed: () => Navigator.pop(context),
                              ),
                              Text(
                                LocaleData.settings.getString(context),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const Expanded(child: SizedBox.shrink()),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  fullName.isEmpty
                                      ? '${LocaleData.greeting.getString(context)} ${LocaleData.user.getString(context)}'
                                      : '${LocaleData.greeting.getString(context)} $fullName',
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                InkWell(
                                  borderRadius: BorderRadius.circular(15),
                                  onTap: _showProfileDialog,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    child: Text(
                                      LocaleData.viewProfile.getString(context),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                  child: Text(
                                    LocaleData.appearance.getString(context),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: SizedBox(
                                    width: 360,
                                    child: Divider(
                                      color: Colors.grey,
                                      thickness: 1,
                                    ),
                                  ),
                                ),
                                DropdownSettingOption(
                                  icon: Icons.language,
                                  title: LocaleData.language.getString(context),
                                  value: selectedLanguageDisplay,
                                  items: languageOptions.values.toList(),
                                  onChanged: (val) async {
                                    if (val != null) {
                                      final newLanguage = languageOptions.entries
                                          .firstWhere((entry) => entry.value == val)
                                          .key;
                                      setState(() {
                                        selectedLanguage = newLanguage;
                                      });
                                      final success = await _saveUserData(
                                        textSize: selectedTextSize,
                                        language: newLanguage,
                                      );
                                      if (success && mounted) {
                                        AppSnackBar.showSuccess(
                                          context,
                                          message: LocaleData.languageUpdated.getString(context),
                                        );
                                      } else if (mounted) {
                                        AppSnackBar.showError(
                                          context,
                                          message: LocaleData.errorSavingData.getString(context),
                                        );
                                      }
                                    }
                                  },
                                ),
  
                                DropdownSettingOption(
                                  icon: Icons.text_fields,
                                  title: LocaleData.textSize.getString(context),
                                  value: selectedTextSizeDisplay,
                                  items: textSizeOptions.values.toList(),
                                  onChanged: (val) async {
                                    if (val != null) {
                                      final newTextSize = textSizeOptions.entries
                                          .firstWhere((entry) => entry.value == val)
                                          .key;
                                      setState(() {
                                        selectedTextSize = newTextSize;
                                      });
                                      final success = await _saveUserData(
                                        textSize: newTextSize,
                                        language: selectedLanguage,
                                      );
                                      if (success && mounted) {
                                        AppSnackBar.showSuccess(
                                          context,
                                          message: LocaleData.textSizeUpdated.getString(context),
                                        );
                                      } else if (mounted) {
                                        AppSnackBar.showError(
                                          context,
                                          message: LocaleData.errorSavingData.getString(context),
                                        );
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  child: Text(
                                    LocaleData.management.getString(context),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: SizedBox(
                                    width: 360,
                                    child: Divider(
                                      color: Colors.grey,
                                      thickness: 1,
                                    ),
                                  ),
                                ),
                                SettingOption(
                                  icon: Icons.security,
                                  title: LocaleData.security.getString(context),
                                  subtitle: LocaleData.setPin.getString(context),
                                  onTap: _showSecuritySettings,
                                ),

                                const SizedBox(height: 10),
                                SettingOption(
                                  icon: Icons.help,
                                  title: LocaleData.helpSupport.getString(context),
                                  subtitle: LocaleData.helpSupport.getString(context),
                                  onTap: _showHelpSupport,
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: InkWell(
                                onTap: _signOut,
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.logout,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          LocaleData.logOut.getString(context),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}