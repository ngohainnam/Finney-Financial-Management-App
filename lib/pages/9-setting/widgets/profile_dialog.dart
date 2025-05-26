import 'package:finney/shared/localization/locales.dart';
import 'package:finney/shared/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

class ProfileDialog extends StatefulWidget {
  final String initialName;
  final String initialPhone;
  final String initialAddress;
  final String email;
  final String userId;
  final Function(String, String, String) onSave;

  const ProfileDialog({
    super.key,
    required this.initialName,
    required this.initialPhone,
    required this.initialAddress,
    required this.email,
    required this.userId,
    required this.onSave,
  });

  @override
  State<ProfileDialog> createState() => _ProfileDialogState();
}

class _ProfileDialogState extends State<ProfileDialog> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.initialName);
    phoneController = TextEditingController(text: widget.initialPhone);
    addressController = TextEditingController(text: widget.initialAddress);
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                widget.email,
              ),
              _buildDisplayField(
                LocaleData.userId.getString(context),
                widget.userId,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () async {
                      if (isEditing) {
                        // Save changes
                        widget.onSave(
                          nameController.text,
                          phoneController.text,
                          addressController.text,
                        );
                        setState(() => isEditing = false);
                      } else {
                        setState(() => isEditing = true);
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
                      setState(() => isEditing = false);
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
}