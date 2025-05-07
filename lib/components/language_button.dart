import 'package:flutter/material.dart';
import 'package:finney/assets/theme/app_color.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:finney/localization/locales.dart';

class LanguageButton extends StatefulWidget {
  final double size;
  final bool showText;
  final String? initialLanguage;
  final Function(String)? onLanguageChanged;
  final bool showFlag;

  const LanguageButton({
    super.key,
    this.size = 40,
    this.showText = false,
    this.initialLanguage,
    this.onLanguageChanged,
    this.showFlag = true,
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
            if (widget.showFlag)
              Text(
                _languageFlags[_currentLanguage] ?? '🇺🇸',
                style: TextStyle(fontSize: widget.size * 0.5),
              ),
            if (widget.showFlag && widget.showText)
              const SizedBox(width: 8),
            if (widget.showText)
              Text(
                _currentLanguage,
                style: TextStyle(
                  fontSize: widget.size * 0.35,
                  fontWeight: FontWeight.w500,
                ),
              ),
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
      },
      {
        'code': 'bn',
        'name': 'Bengali',
        'localName': LocaleData.languageBengali.getString(context),
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
            Container(
              margin: const EdgeInsets.only(top: 8),
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
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
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: availableLanguages.length,
              itemBuilder: (context, index) {
                final language = availableLanguages[index];
                final isSelected = language['name'] == _currentLanguage;
                
                return ListTile(
                  leading: isSelected
                      ? Icon(Icons.check_circle, color: AppColors.primary, size: 24)
                      : const SizedBox(width: 24),
                  title: Text(
                    language['localName']!,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  trailing: null,
                  onTap: () {
                    setState(() {
                      _currentLanguage = language['name']!;
                    });
                    
                    // Remove translate call to avoid navigation reset
                    if (widget.onLanguageChanged != null) {
                      widget.onLanguageChanged!(_currentLanguage);
                    }
                    
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