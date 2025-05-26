import 'package:flutter/material.dart';
import 'package:finney/assets/theme/app_color.dart';
import 'package:finney/localization/locales.dart';
import 'package:flutter_localization/flutter_localization.dart';

class ChartQuery extends StatefulWidget {
  final Map<String, dynamic> chartData;
  final String chartType;
  final String viewType;

  const ChartQuery({
    super.key,
    required this.chartData,
    required this.chartType,
    required this.viewType,
  });

  @override
  State<ChartQuery> createState() => _ChartQueryState();
}

class _ChartQueryState extends State<ChartQuery> {
  final TextEditingController _questionController = TextEditingController();
  String _answer = '';
  bool _isLoading = false;
  bool _showQueryField = false;

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  void _askQuestion() {
    if (_questionController.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate processing delay
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _answer = 'I am analyzing your chart data. Please wait for the response.';
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _showQueryField = !_showQueryField;
                if (!_showQueryField) {
                  _answer = '';
                  _questionController.clear();
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _showQueryField ? AppColors.primary : Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _showQueryField ? Icons.close : Icons.help_outline,
                    color: _showQueryField ? Colors.white : Colors.black87,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _showQueryField 
                      ? LocaleData.hideAssistant.getString(context)
                      : LocaleData.askAboutChart.getString(context),
                    style: TextStyle(
                      color: _showQueryField ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          if (_showQueryField) ...[
            const SizedBox(height: 16),
            TextField(
              controller: _questionController,
              decoration: InputDecoration(
                hintText: LocaleData.askAboutChartHint.getString(context),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none, 
                ),
                filled: true,
                fillColor: AppColors.blurGray.withValues(alpha: 0.2), 
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send_rounded, color: AppColors.darkBlue),
                  onPressed: _askQuestion,
                ),
              ),
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _askQuestion(),
            ),
            
            if (_isLoading || _answer.isNotEmpty)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey[200]!),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: _isLoading
                    ? const Center(
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.lightbulb_outline, 
                                color: AppColors.primary, 
                                size: 16),
                              const SizedBox(width: 8),
                              Text(
                                LocaleData.assistant.getString(context),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(_answer),
                        ],
                      ),
              ),
          ],
        ],
      ),
    );
  }
}