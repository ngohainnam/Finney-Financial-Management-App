import 'package:flutter/material.dart';
import 'package:finney/assets/theme/app_color.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:finney/localization/locales.dart';

class LanguageButton extends StatefulWidget {
  final double size;
  final bool showText;
  final String? initialLanguage;
  final Function(String)? onLanguageChanged;

  const LanguageButton({
    super.key,
    this.size = 40,
    this.showText = false,
    this.initialLanguage,
    this.onLanguageChanged,
  });

  @override
  State<LanguageButton> createState() => _LanguageButtonState();
}

class _LanguageButtonState extends State<LanguageButton> {
  String _currentLanguage = 'English';
  
  final Map<String, String> _languageFlags = {
    'English': '🇺🇸',
    'Bengali': '🇧🇩',
  };
  
  @override
  void initState() {
    super.initState();
    if (widget.initialLanguage != null) {
      _currentLanguage = widget.initialLanguage!;
    } else {
      // If no initial language provided, detect from the current locale
      _currentLanguage = FlutterLocalization.instance.currentLocale!.languageCode == 'en'
          ? 'English'
          : 'Bengali';
    }
  }

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
      {
        'code': 'en', 
        'name': 'English', 
        'localName': LocaleData.languageEnglish.getString(context),
        'flag': '🇺🇸'
      },
      {
        'code': 'bn', 
        'name': 'Bengali', 
        'localName': LocaleData.languageBengali.getString(context),
        'flag': '🇧🇩'
      },
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
                LocaleData.language.getString(context),
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
                    language['localName']!,
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
                    
                    // Update the app's locale
                    FlutterLocalization.instance.translate(
                      language['code']!,
                    );
                    
                    // Call the callback if provided
                    if (widget.onLanguageChanged != null) {
                      widget.onLanguageChanged!(_currentLanguage);
                    }
                    
                    // Close the bottom sheet
                    Navigator.pop(context);
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}