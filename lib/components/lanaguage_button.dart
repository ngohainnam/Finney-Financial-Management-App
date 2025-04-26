import 'package:flutter/material.dart';
import 'package:finney/assets/theme/app_color.dart';

class LanguageButton extends StatefulWidget {
  // Size options for the button
  final double size;
  final bool showText;

  const LanguageButton({
    super.key,
    this.size = 40,
    this.showText = false,
  });

  @override
  State<LanguageButton> createState() => _LanguageButtonState();
}

class _LanguageButtonState extends State<LanguageButton> {
  String _currentLanguage = 'English';
  
  //map of languages with flags
  final Map<String, String> _languageFlags = {
    'English': '🇺🇸',
    'Bengali': '🇧🇩',
  };

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showLanguageSelector(context),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: widget.size,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.5)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _languageFlags[_currentLanguage] ?? '🇺🇸',
              style: TextStyle(fontSize: widget.size * 0.5),
            ),
            if (widget.showText) ...[
              const SizedBox(width: 8),
              Text(
                _currentLanguage,
                style: TextStyle(
                  fontSize: widget.size * 0.35,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showLanguageSelector(BuildContext context) {
    final availableLanguages = [
      {'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
      {'code': 'bn', 'name': 'Bengali', 'flag': '🇧🇩'},
    ];
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 8),
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Select Language',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            const Divider(),
            // Language list
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: availableLanguages.length,
              itemBuilder: (context, index) {
                final language = availableLanguages[index];
                final isSelected = language['name'] == _currentLanguage;
                
                return ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : Colors.grey.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        language['flag']!,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  title: Text(
                    language['name']!,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(Icons.check_circle, color: AppColors.primary)
                      : null,
                  onTap: () {
                    // Update the current language in the widget state
                    setState(() {
                      _currentLanguage = language['name']!;
                    });
                    
                    // Close the bottom sheet
                    Navigator.pop(context);
                    
                    // Show a message that full functionality will be implemented later
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Language selection functionality will be implemented later'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            // Padding to account for bottom insets on notched devices
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}