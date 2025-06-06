import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:finney/shared/theme/app_color.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:finney/shared/utils/notification_service.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:finney/shared/localization/locales.dart';

class BudgetReminderPage extends StatefulWidget {
  const BudgetReminderPage({super.key});

  @override
  State<BudgetReminderPage> createState() => _BudgetReminderPageState();
}

class _BudgetReminderPageState extends State<BudgetReminderPage> {
  final FlutterTts _flutterTts = FlutterTts();
  final uid = FirebaseAuth.instance.currentUser?.uid;
  bool _isSpeaking = false;
  String? _speakingCategory;


  final Map<String, Map<String, dynamic>> _categoryData = {};
  List<String> categoryOrder = [
    'Shopping',
    'Food',
    'Entertainment',
    'Transport',
    'Health',
    'Utilities',
    'Others'
  ];

  final Map<String, IconData> _categoryIcons = {
    'Shopping': Icons.shopping_bag,
    'Food': Icons.restaurant,
    'Entertainment': Icons.movie,
    'Transport': Icons.directions_car,
    'Health': Icons.medical_services,
    'Utilities': Icons.call,
    'Others': Icons.category,
  };

  final Map<String, Color> _categoryColors = {
    'Shopping': AppColors.categoryShopping,
    'Food': AppColors.categoryFood,
    'Entertainment': AppColors.categoryEntertainment,
    'Transport': AppColors.categoryTransport,
    'Health': AppColors.categoryHealth,
    'Utilities': AppColors.categoryUtilities,
    'Others': AppColors.categoryDefault,
  };

  @override
  void initState() {
    super.initState();
    _flutterTts.setLanguage("bn-BD");
    _flutterTts.setSpeechRate(0.4);
    _loadBudgetData();
  }

  Future<void> _loadBudgetData() async {
    final budgetRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('budgets');
    final transactionRef = FirebaseFirestore.instance.collection('users').doc(
        uid).collection('transactions');

    Map<String, double> categorySpent = {};
    final txnSnapshot = await transactionRef.get();

    for (var doc in txnSnapshot.docs) {
      final data = doc.data();
      String id = doc.id;
      double amount = (data['amount'] ?? 0).toDouble();
      String cat = data['category'] ?? 'Others';

      debugPrint("TXN [$id]: $cat | $amount");

      if (amount < 0) { // Only include expenses
        categorySpent[cat] = (categorySpent[cat] ?? 0) + amount.abs();
      }
    }


    final budgetSnapshot = await budgetRef.get();
    for (var doc in budgetSnapshot.docs) {
      final data = doc.data();
      String cat = doc.id;
      double limit = (data['limit'] ?? 0).toDouble();
      double spent = categorySpent[cat] ?? 0;
      if (categoryOrder.contains(cat)) {
        _categoryData[cat] = {'limit': limit, 'spent': spent};
      }
    }

    setState(() {});
  }


  Future<void> _editLimit(String category) async {
    final controller = TextEditingController(
      text: _categoryData[category]?['limit']?.toStringAsFixed(0) ?? '0',
    );

    await showDialog(
      context: context,
      builder: (_) =>
          AlertDialog(
            title: Text(
                Localizations
                    .localeOf(context)
                    .languageCode == 'bn'
                    ? "${getLocalizedCategoryName(
                    category, context)}-এর সীমা পরিবর্তন করুন"
                    : "Edit limit for ${getLocalizedCategoryName(
                    category, context)}"
            ),
            content: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: Localizations
                      .localeOf(context)
                      .languageCode == 'bn'
                      ? "নতুন সীমা লিখুন"
                      : "Enter new limit"
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                    Localizations
                        .localeOf(context)
                        .languageCode == 'bn'
                        ? "বাতিল করুন"
                        : "Cancel"
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  double? newLimit = double.tryParse(controller.text);
                  if (newLimit != null) {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(uid)
                        .collection('budgets')
                        .doc(category)
                        .set({'limit': newLimit, 'category': category},
                        SetOptions(merge: true));
                    _loadBudgetData();
                    Navigator.pop(context);
                  }
                },
                child: Text(
                    Localizations
                        .localeOf(context)
                        .languageCode == 'bn'
                        ? "সংরক্ষণ করুন"
                        : "Save"
                ),
              )
            ],
          ),
    );
  }

  String numberToWords(int number) {
    final Map<int, String> units = {
      0: 'zero', 1: 'one', 2: 'two', 3: 'three', 4: 'four',
      5: 'five', 6: 'six', 7: 'seven', 8: 'eight', 9: 'nine',
      10: 'ten', 11: 'eleven', 12: 'twelve', 13: 'thirteen',
      14: 'fourteen', 15: 'fifteen', 16: 'sixteen', 17: 'seventeen',
      18: 'eighteen', 19: 'nineteen'
    };

    final Map<int, String> tens = {
      20: 'twenty', 30: 'thirty', 40: 'forty', 50: 'fifty',
      60: 'sixty', 70: 'seventy', 80: 'eighty', 90: 'ninety'
    };

    if (number < 20) return units[number]!;
    if (number < 100) {
      return tens[number - number % 10]! +
          (number % 10 != 0 ? ' ${units[number % 10]}' : '');
    }
    if (number < 1000) {
      return '${units[number ~/ 100]} hundred${number % 100 != 0
          ? ' ${numberToWords(number % 100)}'
          : ''}';
    }
    if (number < 1000000) {
      return '${numberToWords(number ~/ 1000)} thousand${number % 1000 != 0
          ? ' ${numberToWords(number % 1000)}'
          : ''}';
    }
    return number.toString(); // fallback
  }


  Future<void> _speakSummary() async {
    if (_isSpeaking) {
      await _flutterTts.stop();
      setState(() {
        _isSpeaking = false;
        _speakingCategory = null;
      });
      return;
    }

    setState(() => _isSpeaking = true);

    final isBengali = Localizations
        .localeOf(context)
        .languageCode == 'bn';

    for (var category in categoryOrder) {
      if (!_isSpeaking) break;

      final data = _categoryData[category];
      if (data == null) continue;

      setState(() => _speakingCategory = category);

      final categoryName = isBengali ? getLocalizedCategoryName(
          category, context) : category;
      final int spent = data['spent'].toInt();
      final int limit = data['limit'].toInt();

      final spentText = isBengali ? _bn(spent) : numberToWords(spent);
      final limitText = isBengali ? _bn(limit) : numberToWords(limit);

      final message = isBengali
          ? "আপনি $categoryName বিভাগে $spentText টাকা খরচ করেছেন, বরাদ্দ ছিল $limitText টাকা।"
          : "In $categoryName category, you spent $spentText Taka out of $limitText.";

      await _flutterTts.speak(message);
      await Future.delayed(Duration(seconds: 8));
    }

    setState(() {
      _isSpeaking = false;
      _speakingCategory = null;
    });
  }


  String _bn(int value) {
    const digits = ["০", "১", "২", "৩", "৪", "৫", "৬", "৭", "৮", "৯"];
    return value.toString().split('').map((d) => digits[int.parse(d)]).join();
  }

  Future<void> _pickReminderTime() async {
    final isBengali = Localizations
        .localeOf(context)
        .languageCode == 'bn';

    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 20, minute: 0),
      builder: (context, child) {
        // Force English locale just inside the time picker
        return Localizations.override(
          context: context,
          locale: const Locale('en'),
          child: Theme(
            data: Theme.of(context).copyWith(
              timePickerTheme: TimePickerThemeData(
                dialTextStyle: TextStyle(
                  fontFamily: isBengali ? 'NotoSansBengali' : null,
                  fontSize: isBengali ? 14 : null,
                ),
                hourMinuteTextStyle: TextStyle(
                  fontFamily: isBengali ? 'NotoSansBengali' : null,
                  fontSize: isBengali ? 18 : null,
                ),
              ),
            ),
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                  alwaysUse24HourFormat: false),
              child: child!,
            ),
          ),
        );
      },
    );


    if (picked == null) return;

    final now = tz.TZDateTime.now(tz.local);
    final scheduledTime = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, picked.hour, picked.minute);
    final scheduleFor = scheduledTime.isBefore(now) ? scheduledTime.add(
        Duration(days: 1)) : scheduledTime;

    try {
      await NotificationService.scheduleDailyReminder(
        scheduledTime: scheduleFor,
        title: '🔔 Reminder: 💰 বাজেট লিমিট পার হচ্ছে না তো?',
        body: 'এখনই চেক করুন।',
        id: 1,
      );

      if (Platform.isAndroid) {
        final intent = AndroidIntent(
          action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
          flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
        );
        await intent.launch();
      }

      final hour12 = (picked.hour % 12 == 0) ? 12 : picked.hour % 12;
      final timePeriod = (picked.hour < 12) ? "সকাল" : (picked.hour < 16)
          ? "দুপুর"
          : (picked.hour < 19) ? "বিকেল" : (picked.hour < 21)
          ? "সন্ধ্যা"
          : "রাত";
      final speakText = "আপনার বাজেট রিমাইন্ডার সেট করা হয়েছে $timePeriod ${_bn(
          hour12)} টা ${_bn(picked.minute)} মিনিটে।";
      await _flutterTts.speak(speakText);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Reminder set for ${picked.format(context)}')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Reminder setup failed: ${e.toString()}')),
        );
      }
    }
  }


  String getLocalizedCategoryName(String category, BuildContext context) {
    switch (category) {
      case 'Shopping':
        return LocaleData.shopping.getString(context);
      case 'Food':
        return LocaleData.food.getString(context);
      case 'Entertainment':
        return LocaleData.entertainment.getString(context);
      case 'Transport':
        return LocaleData.transport.getString(context);
      case 'Health':
        return LocaleData.health.getString(context);
      case 'Utilities':
        return LocaleData.utilities.getString(context);
      case 'Others':
      default:
        return LocaleData.others.getString(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        titleSpacing: 0,
        title: Text(
          LocaleData.budgetReminderTitle.getString(context),
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(
            LocaleData.thisWeeksSpending.getString(context),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 12),

          Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleData.totalSpent.getString(context),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                      () {
                    double totalSpent = _categoryData.values
                        .map((e) => (e['spent'] ?? 0.0) as double)
                        .fold(0.0, (a, b) => a + b);
                    double totalLimit = _categoryData.values
                        .map((e) => (e['limit'] ?? 0.0) as double)
                        .fold(0.0, (a, b) => a + b);
                    return "৳${totalSpent.toInt()} / ৳${totalLimit.toInt()}";
                  }(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 12),

          ...categoryOrder.map((category) {
            final data = _categoryData[category] ?? {'spent': 0.0, 'limit': 1.0};
            double spent = data['spent'];
            double limit = data['limit'];
            double percent = (spent / (limit == 0 ? 1 : limit)).clamp(0.0, 1.0);

            Color statusColor = percent < 0.7
                ? Colors.green
                : (percent < 1 ? Colors.orange : Colors.redAccent);

            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _editLimit(category),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  margin: EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: Colors.white, // Always white, no blue/orange background
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      )
                    ],
                  ),

                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 90,
                        decoration: BoxDecoration(
                          color: _categoryColors[category],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TweenAnimationBuilder<double>(
                                tween: Tween<double>(
                                  begin: 1.0,
                                  end: _speakingCategory == category ? 1.3 : 1.0,
                                ),
                                duration: Duration(milliseconds: 500),
                                curve: Curves.elasticOut,
                                builder: (context, scale, child) {
                                  return Transform.scale(
                                    scale: scale,
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 500),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _categoryColors[category]!.withValues(alpha: 0.1),
                                        boxShadow: _speakingCategory == category
                                            ? [
                                          BoxShadow(
                                            color: _categoryColors[category]!.withValues(alpha: 0.5),
                                            blurRadius: 12,
                                            spreadRadius: 2,
                                          )
                                        ]
                                            : [],
                                      ),
                                      child: child,
                                    ),
                                  );
                                },
                                child: Icon(
                                  _categoryIcons[category],
                                  color: _categoryColors[category],
                                  size: 24,
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            getLocalizedCategoryName(category, context),
                                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ),
                                        if (percent >= 1)
                                          Icon(Icons.warning, size: 18, color: Colors.redAccent),
                                      ],
                                    ),
                                    SizedBox(height: 6),
                                    TweenAnimationBuilder(
                                      duration: Duration(milliseconds: 600),
                                      tween: Tween<double>(begin: 0, end: percent),
                                      builder: (context, double value, _) => LinearProgressIndicator(
                                        value: value,
                                        minHeight: 6,
                                        color: percent >= 1 ? Colors.redAccent : AppColors.primary,
                                        backgroundColor: Colors.grey[300],
                                      ),
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      "৳${spent.toInt()} / ৳${limit.toInt()}",
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: statusColor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
          SizedBox(height: 30),
          ElevatedButton.icon(
            icon: Icon(
              _isSpeaking ? Icons.stop : Icons.volume_up,
              color: Colors.white,
            ),
            label: Text(
              _isSpeaking
                  ? LocaleData.stopSummary.getString(context)
                  : LocaleData.playSummary.getString(context),
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            onPressed: _speakSummary,
            style: ElevatedButton.styleFrom(
              elevation: 3,
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: EdgeInsets.symmetric(vertical: 14),
            ),
          ),
          SizedBox(height: 12),
          ElevatedButton.icon(
            icon: Icon(Icons.alarm, color: Colors.white),
            label: Text(
              LocaleData.setDailyReminder.getString(context),
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            onPressed: _pickReminderTime,
            style: ElevatedButton.styleFrom(
              elevation: 3,
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: EdgeInsets.symmetric(vertical: 14),
            ),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}
