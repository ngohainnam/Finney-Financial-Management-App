import 'dart:io';
import 'package:finney/shared/localization/locales.dart';
import 'package:finney/core/storage/cloud/service/setting_service.dart';
import 'package:finney/pages/9-setting/language_selection.dart';
import 'package:finney/pages/9-setting/widgets/dropdown_setting.dart';
import 'package:finney/pages/9-setting/widgets/language_setting.dart';
import 'package:flutter/material.dart';
import 'package:finney/shared/theme/app_color.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:finney/shared/widgets/common/snack_bar.dart';
import 'widgets/profile_dialog.dart';
import 'widgets/security_dialog.dart';
import 'widgets/setting_option.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  late final UserSettingsService _settingsService;

  // User data
  String fullName = '';
  String phoneNumber = '';
  String address = '';
  String email = '';
  String userId = '';
  String selectedLanguage = 'Bengali';
  String selectedTextSize = 'Medium';

  @override
  void initState() {
    super.initState();
    _settingsService = UserSettingsService();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await _settingsService.loadUserData();
    if (mounted) {
      setState(() {
        fullName = userData['name'] ?? '';
        phoneNumber = userData['phone'] ?? '';
        address = userData['address'] ?? '';
        email = userData['email'] ?? '';
        userId = _settingsService.currentUser?.uid ?? '';
        selectedTextSize = userData['textSize'] ?? 'Medium';
        selectedLanguage = userData['language'] ?? 'Bengali';
      });
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null && mounted) {
      setState(() {
        _imageFile = image;
      });
    }
  }

  void _showProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => ProfileDialog(
        initialName: fullName,
        initialPhone: phoneNumber,
        initialAddress: address,
        email: email,
        userId: userId,
        onSave: (name, phone, address) async {
          final success = await _settingsService.saveUserData(
            name: name,
            phone: phone,
            address: address,
            textSize: selectedTextSize,
            language: selectedLanguage,
          );
          
          if (success && mounted) {
            setState(() {
              fullName = name;
              phoneNumber = phone;
              this.address = address;
            });
            
            AppSnackBar.showSuccess(
              context, 
              message: LocaleData.save.getString(context),
            );
          } else if (mounted) {
            AppSnackBar.showError(
              context,
              message: LocaleData.errorSavingData.getString(context),
            );
          }
        },
      ),
    );
  }

  void _showSecuritySettings() {
    showDialog(
      context: context,
      builder: (context) => SecurityDialog(
        onSavePin: (pin) async {
          final success = await _settingsService.saveSecurityPin(pin);
          
          if (success && mounted) {
            AppSnackBar.showSuccess(
              context,
              message: LocaleData.pinSaved.getString(context),
            );
          } else if (mounted) {
            AppSnackBar.showError(
              context,
              message: LocaleData.errorSavingData.getString(context),
            );
          }
        },
      ),
    );
  }

  void _showHelpSupport() {
    AppSnackBar.showInfo(
      context,
      message: LocaleData.helpSupportComingSoon.getString(context),
    );
  }

  Future<void> _signOut() async {
    await _settingsService.signOut();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LanguageSelectionPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double textScaleFactor;
    switch (selectedTextSize) {
      case 'Small':
        textScaleFactor = 0.8;
        break;
      case 'Large':
        textScaleFactor = 1.2;
        break;
      default:
        textScaleFactor = 1.0;
    }

    return Builder(
      builder: (context) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(textScaleFactor),
        ),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    title: Text(
                      LocaleData.settings.getString(context),
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: _imageFile == null
                          ? const AssetImage('assets/images/placeholder.png')
                          : FileImage(File(_imageFile!.path)) as ImageProvider,
                      child: _imageFile == null
                          ? const Icon(Icons.camera_alt, color: Colors.white)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    fullName.isEmpty
                        ? LocaleData.user.getString(context)
                        : fullName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email.isEmpty ? LocaleData.notAvailable.getString(context) : email,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 15),
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
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleData.appearance.getString(context),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        LanguageSettingOption(
                          icon: Icons.language,
                          title: LocaleData.language.getString(context),
                          value: selectedLanguage,
                        ),
                        const SizedBox(height: 10),
                        DropdownSettingOption(
                          icon: Icons.text_fields,
                          title: LocaleData.textSize.getString(context),
                          value: selectedTextSize,
                          items: const ['Small', 'Medium', 'Large'],
                          onChanged: (val) async {
                            if (val != null) {
                              setState(() {
                                selectedTextSize = val;
                              });
                              
                              await _settingsService.saveUserData(
                                name: fullName,
                                phone: phoneNumber,
                                address: address,
                                textSize: selectedTextSize,
                                language: selectedLanguage,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleData.management.getString(context),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 10),
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
                        SettingOption(
                          icon: Icons.logout,
                          title: LocaleData.logOut.getString(context),
                          subtitle: null,
                          iconColor: Colors.white,
                          textColor: Colors.white,
                          isLogOut: true,
                          onTap: _signOut,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}