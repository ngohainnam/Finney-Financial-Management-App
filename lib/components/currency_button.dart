import 'package:flutter/material.dart';
import 'package:finney/assets/theme/app_color.dart';
import 'package:finney/localization/locales.dart';
import 'package:finney/utils/currency_formatter.dart';
import 'package:flutter_localization/flutter_localization.dart';

class CurrencyButton extends StatefulWidget {
  final double size;
  final bool showText;
  final String? initialCurrency;
  final Function(String)? onCurrencyChanged;

  const CurrencyButton({
    super.key,
    this.size = 40,
    this.showText = false,
    this.initialCurrency,
    this.onCurrencyChanged,
  });

  @override
  State<CurrencyButton> createState() => _CurrencyButtonState();
}

class _CurrencyButtonState extends State<CurrencyButton> {
  late String _currentCurrency;
  
  final Map<String, String> _currencySymbols = {
    'BDT': '৳',
    'AUD': '\$',
  };
  
  @override
  void initState() {
    super.initState();
    _currentCurrency = widget.initialCurrency ?? 'BDT';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showCurrencySelector(context),
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
              _currencySymbols[_currentCurrency] ?? '৳',
              style: TextStyle(fontSize: widget.size * 0.5),
            ),
            if (widget.showText) ...[
              const SizedBox(width: 8),
              Text(
                _currentCurrency,
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

  void _showCurrencySelector(BuildContext context) {
    final availableCurrencies = [
      {
        'code': 'BDT', 
        'symbol': '৳',
        'name': LocaleData.currencyBDT.getString(context),
      },
      {
        'code': 'AUD', 
        'symbol': '\$',
        'name': LocaleData.currencyAUD.getString(context),
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
                LocaleData.currency.getString(context),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            const Divider(),
            // Currency list
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: availableCurrencies.length,
              itemBuilder: (context, index) {
                final currency = availableCurrencies[index];
                final isSelected = currency['code'] == _currentCurrency;
                
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
                        currency['symbol']!,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  title: Text(
                    currency['name']!,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(Icons.check_circle, color: AppColors.primary)
                      : null,
                  onTap: () {
                    // Update the current currency in the widget state
                    setState(() {
                      _currentCurrency = currency['code']!;
                    });
                    
                    // Update the currency formatter
                    CurrencyFormatter.updateCurrency(_currentCurrency);
                    
                    // Call the callback if provided
                    if (widget.onCurrencyChanged != null) {
                      widget.onCurrencyChanged!(_currentCurrency);
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