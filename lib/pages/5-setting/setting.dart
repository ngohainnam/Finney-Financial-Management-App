import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finney/assets/theme/app_color.dart';
import 'package:image_picker/image_picker.dart';

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

  String selectedLanguage = 'English';
  String selectedCurrency = 'BDT';
  String selectedTextSize = 'Medium';

  String fullName = '';
  String phoneNumber = '';
  String address = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
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
      });
    }
  }

  Future<void> _saveUserData() async {
    await FirebaseFirestore.instance.collection('users').doc(user?.uid).set({
      'name': nameController.text,
      'phone': phoneController.text,
      'address': addressController.text,
      'email': user?.email ?? '',
      'textSize': selectedTextSize,
    }, SetOptions(merge: true));
    setState(() {
      fullName = nameController.text;
      phoneNumber = phoneController.text;
      address = addressController.text;
    });
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
                  borderRadius: BorderRadius.circular(16)),
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
                          "Profile Information",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildEditableField("Full Name", nameController, isEditing),
                      _buildEditableField(
                          "Phone Number", phoneController, isEditing),
                      _buildEditableField("Address", addressController, isEditing),
                      _buildDisplayField("Email", user?.email ?? "Not available"),
                      _buildDisplayField("User ID", user?.uid ?? "Not available"),
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
                            child: Text(isEditing ? "Save" : "Edit"),
                          ),
                          TextButton(
                            onPressed: () {
                              setDialogState(() => isEditing = false);
                              Navigator.pop(context);
                            },
                            child: const Text("Close"),
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
          title: const Text("Set PIN"),
          content: TextField(
            controller: pinController,
            keyboardType: TextInputType.number,
            maxLength: 4,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: "Enter 4-digit PIN",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
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
                    const SnackBar(content: Text("PIN saved!")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter a 4-digit PIN")),
                  );
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _showHelpSupport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Help & Support page coming soon!")),
    );
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
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
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(textScaleFactor)),
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
                      'Settings',
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
                          ? const NetworkImage('https://placehold.co/150x150')
                          : FileImage(File(_imageFile!.path)) as ImageProvider,
                      onBackgroundImageError: _imageFile == null
                            ? (exception, stackTrace) {
                              debugPrint('Error loading image: $exception');
                            }
                          : null,
                      child: _imageFile == null
                          ? const Icon(Icons.camera_alt, color: Colors.white)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    fullName.isEmpty ? 'User' : fullName,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? 'Email not available',
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 15),
                  InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: _showProfileDialog,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        "View Profile",
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
                          'Appearance',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildDropdownOption(
                          icon: Icons.language,
                          title: "Language",
                          value: selectedLanguage,
                          items: ['English', 'Bengali'],
                          onChanged: (val) => setState(() => selectedLanguage = val!),
                        ),
                        const SizedBox(height: 10),
                        _buildDropdownOption(
                          icon: Icons.currency_exchange,
                          title: "Currency",
                          value: selectedCurrency,
                          items: ['BDT', 'AUD'],
                          onChanged: (val) => setState(() => selectedCurrency = val!),
                        ),
                        const SizedBox(height: 10),
                        _buildDropdownOption(
                          icon: Icons.text_fields,
                          title: "Text Size",
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
                          'Management',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildOption(
                          icon: Icons.security,
                          title: "Security",
                          subtitle: "Set PIN",
                          onTap: _showSecuritySettings,
                        ),
                        const SizedBox(height: 10),
                        _buildOption(
                          icon: Icons.help,
                          title: "Help & Support",
                          subtitle: "FAQs and Contact",
                          onTap: _showHelpSupport,
                        ),
                        const SizedBox(height: 10),
                        _buildOption(
                          icon: Icons.logout,
                          title: "Log Out",
                          subtitle: null,
                          iconColor: Colors.white,
                          textColor: Colors.white,
                          onTap: _signOut,
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
      String label, TextEditingController controller, bool editable) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.primary, // Changed to AppColors.primary
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
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
              color: AppColors.primary, // Changed to AppColors.primary
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
    final isLogOut = title == "Log Out";
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isLogOut ? Colors.red : Colors.white,
          border: Border.all(color: isLogOut ? Colors.red : AppColors.primary),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: isLogOut ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor ?? AppColors.primary),
            if (!isLogOut) const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: isLogOut ? CrossAxisAlignment.center : CrossAxisAlignment.start,
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

  Widget _buildDropdownOption({
    required IconData icon,
    required String title,
    required String value,
    required List<String> items,
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
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          DropdownButton<String>(
            value: value,
            items: items
                .map((item) => DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    ))
                .toList(),
            onChanged: onChanged,
            underline: const SizedBox(),
          ),
        ],
      ),
    );
  }
}