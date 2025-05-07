import 'dart:io';
import 'package:finney/components/currency_button.dart';
import 'package:finney/components/language_button.dart';
import 'package:finney/localization/locales.dart';
import 'package:finney/utils/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finney/assets/theme/app_color.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:finney/utils/auth_utils.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = image;
      });
    }
  }

  final user = FirebaseAuth.instance.currentUser;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  String selectedLanguage = 'Bengali';
  String selectedCurrency = 'BDT';
  String selectedTextSize = 'Medium';

  String fullName = '';
  String phoneNumber = '';
  String address = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    // Set initial language based on Hive
    var box = Hive.box('appSettings');
    selectedLanguage = box.get('language', defaultValue: 'en') == 'en' ? 'English' : 'Bengali';
  }

  Future<void> _loadUserData() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .get();
      if (doc.exists) {
        setState(() {
          fullName = doc['name'] ?? '';
          phoneNumber = doc['phone'] ?? '';
          address = doc['address'] ?? '';
          nameController.text = fullName;
          phoneController.text = phoneNumber;
          addressController.text = address;
          selectedTextSize = doc['textSize'] ?? 'Medium';
          selectedCurrency = doc['currency'] ?? 'BDT';
          selectedLanguage = doc['language'] ?? selectedLanguage;
        });
      } else {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .set({
          'name': '',
          'phone': '',
          'address': '',
          'email': user?.email ?? '',
          'textSize': 'Medium',
          'currency': 'BDT',
          'language': selectedLanguage,
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              LocaleData.errorLoadingData.getString(context),
            ),
          ),
        );
      }
    }
  }

  Future<void> _saveUserData() async {
    try {
      // Update Hive language preference
      var box = await Hive.openBox('appSettings');
      String languageCode = selectedLanguage == 'English' ? 'en' : 'bn';
      await box.put('language', languageCode);

      // Update Firestore
      await FirebaseFirestore.instance.collection('users').doc(user?.uid).set({
        'name': nameController.text,
        'phone': phoneController.text,
        'address': addressController.text,
        'email': user?.email ?? '',
        'textSize': selectedTextSize,
        'currency': selectedCurrency,
        'language': selectedLanguage,
      }, SetOptions(merge: true));

      // Update app locale
      if (mounted) {
        FlutterLocalization.instance.translate(languageCode);
      }

      CurrencyFormatter.updateCurrency(selectedCurrency);

      setState(() {
        fullName = nameController.text;
        phoneNumber = phoneController.text;
        address = addressController.text;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              LocaleData.errorSavingData.getString(context),
            ),
          ),
        );
      }
    }
  }

  void _showProfileDialog() {
    bool isEditing = false;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: Colors.grey[200],
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          LocaleData.profileInformation.getString(context),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildEditableField(
                        LocaleData.fullName.getString(context),
                        nameController,
                        isEditing,
                      ),
                      _buildEditableField(
                        LocaleData.phoneNumber.getString(context),
                        phoneController,
                        isEditing,
                      ),
                      _buildEditableField(
                        LocaleData.address.getString(context),
                        addressController,
                        isEditing,
                      ),
                      _buildDisplayField(
                        LocaleData.email.getString(context),
                        user?.email ?? LocaleData.notAvailable.getString(context),
                      ),
                      _buildDisplayField(
                        LocaleData.userId.getString(context),
                        user?.uid ?? LocaleData.notAvailable.getString(context),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () async {
                              if (isEditing) {
                                await _saveUserData();
                                setDialogState(() => isEditing = false);
                              } else {
                                setDialogState(() => isEditing = true);
                              }
                            },
                            child: Text(
                              isEditing
                                  ? LocaleData.save.getString(context)
                                  : LocaleData.edit.getString(context),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setDialogState(() => isEditing = false);
                              Navigator.pop(context);
                            },
                            child: Text(
                              LocaleData.close.getString(context),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showSecuritySettings() {
    final pinController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(LocaleData.setPin.getString(context)),
          content: TextField(
            controller: pinController,
            keyboardType: TextInputType.number,
            maxLength: 4,
            obscureText: true,
            decoration: InputDecoration(
              labelText: LocaleData.enterPin.getString(context),
              border: const OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(LocaleData.cancel.getString(context)),
            ),
            TextButton(
              onPressed: () {
                if (pinController.text.length == 4) {
                  FirebaseFirestore.instance.collection('users').doc(user?.uid).set(
                    {'pin': pinController.text},
                    SetOptions(merge: true),
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        LocaleData.pinSaved.getString(context),
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        LocaleData.invalidPin.getString(context),
                      ),
                    ),
                  );
                }
              },
              child: Text(LocaleData.save.getString(context)),
            ),
          ],
        );
      },
    );
  }

  void _showHelpSupport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          LocaleData.helpSupportComingSoon.getString(context),
        ),
      ),
    );
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
                    user?.email ?? LocaleData.notAvailable.getString(context),
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
                        _buildLanguageOption(
                          icon: Icons.language,
                          title: LocaleData.language.getString(context),
                          value: selectedLanguage,
                        ),
                        const SizedBox(height: 10),
                        _buildCurrencyOption(
                          icon: Icons.currency_exchange,
                          title: LocaleData.currency.getString(context),
                          value: selectedCurrency,
                        ),
                        const SizedBox(height: 10),
                        _buildDropdownOption(
                          icon: Icons.text_fields,
                          title: LocaleData.textSize.getString(context),
                          value: selectedTextSize,
                          items: ['Small', 'Medium', 'Large'],
                          onChanged: (val) {
                            setState(() {
                              selectedTextSize = val!;
                              _saveUserData();
                            });
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
                        _buildOption(
                          icon: Icons.security,
                          title: LocaleData.security.getString(context),
                          subtitle: LocaleData.setPin.getString(context),
                          onTap: _showSecuritySettings,
                        ),
                        const SizedBox(height: 10),
                        _buildOption(
                          icon: Icons.help,
                          title: LocaleData.helpSupport.getString(context),
                          subtitle: LocaleData.helpSupport.getString(context),
                          onTap: _showHelpSupport,
                        ),
                        const SizedBox(height: 10),
                        _buildOption(
                          icon: Icons.logout,
                          title: LocaleData.logOut.getString(context),
                          subtitle: null,
                          iconColor: Colors.white,
                          textColor: Colors.white,
                          onTap: () => signOut(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditableField(
    String label,
    TextEditingController controller,
    bool editable,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            enabled: editable,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildDisplayField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.primary),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(value, style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? iconColor,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    final isLogOut = title == LocaleData.logOut.getString(context);
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isLogOut ? Colors.red : Colors.white,
          border: Border.all(
            color: isLogOut ? Colors.red : AppColors.primary,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment:
              isLogOut ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor ?? AppColors.primary),
            if (!isLogOut) const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    isLogOut ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: textColor ?? Colors.black,
                    ),
                  ),
                  if (subtitle != null && !isLogOut)
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: textColor ?? Colors.grey,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.primary),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          LanguageButton(
            size: 36,
            showText: true,
            showFlag: false,
            initialLanguage: selectedLanguage,
            onLanguageChanged: (language) {
              setState(() {
                selectedLanguage = language;
                _saveUserData();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownOption({
    required IconData icon,
    required String title,
    required String value,
    required dynamic items,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.primary),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          DropdownButton<String>(
            value: value,
            items: items is List<DropdownMenuItem<String>>
                ? items
                : items
                    .map<DropdownMenuItem<String>>(
                      (String item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      ),
                    )
                    .toList(),
            onChanged: onChanged,
            underline: const SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyOption({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.primary),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          CurrencyButton(
            size: 36,
            showText: true,
            initialCurrency: selectedCurrency,
            onCurrencyChanged: (currency) {
              setState(() {
                selectedCurrency = currency;
                _saveUserData();
              });
            },
          ),
        ],
      ),
    );
  }
}