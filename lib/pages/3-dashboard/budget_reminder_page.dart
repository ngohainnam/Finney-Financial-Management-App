import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:finney/assets/theme/app_color.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:finney/utils/notification_service.dart';

class BudgetReminderPage extends StatefulWidget {
  const BudgetReminderPage({super.key});

  @override
  State<BudgetReminderPage> createState() => _BudgetReminderPageState();
}

class _BudgetReminderPageState extends State<BudgetReminderPage> {
  final FlutterTts _flutterTts = FlutterTts();
  final uid = FirebaseAuth.instance.currentUser?.uid;

  bool _isSpeaking = false;

  Map<String, Map<String, dynamic>> _categoryData = {};
  List<String> categoryOrder = [
    'Shopping',
    'Food',
    'Entertainment',
    'Transport',
    'Health',
    'Utilities',
    'Others',
  ];

  final Map<String, IconData> _categoryIcons = {
    'Shopping': Icons.shopping_bag,
    'Food': Icons.restaurant,
    'Entertainment': Icons.movie,
    'Transport': Icons.directions_car,
    'Health': Icons.health_and_safety,
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
    final budgetRef = FirebaseFirestore.instance.collection('users').doc(uid).collection('budgets');
    final transactionRef = FirebaseFirestore.instance.collection('users').doc(uid).collection('transactions');

    Map<String, double> categorySpent = {};
    final txnSnapshot = await transactionRef.get();
    for (var doc in txnSnapshot.docs) {
      final data = doc.data();
      String cat = data['category'] ?? 'Others';
      double amount = (data['amount'] ?? 0).toDouble();
      if (!categorySpent.containsKey(cat)) categorySpent[cat] = 0;
      categorySpent[cat] = categorySpent[cat]! + amount.abs();
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
      builder: (_) => AlertDialog(
        title: Text("Edit Limit for $category"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(hintText: "Enter new limit"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              double? newLimit = double.tryParse(controller.text);
              if (newLimit != null) {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .collection('budgets')
                    .doc(category)
                    .set({'limit': newLimit, 'category': category}, SetOptions(merge: true));
                _loadBudgetData();
                Navigator.pop(context);
              }
            },
            child: Text("Save"),
          )
        ],
      ),
    );
  }

  Future<void> _speakSummary() async {
    if (_isSpeaking) {
      await _flutterTts.stop();
      setState(() => _isSpeaking = false);
      return;
    }

    setState(() => _isSpeaking = true);

    for (var entry in _categoryData.entries) {
      if (!_isSpeaking) break;

      final String name = entry.key;
      final int spent = entry.value['spent'].toInt();
      final int limit = entry.value['limit'].toInt();

      String message = "আপনি $name ক্যাটেগরিতে ${_bn(spent)} টাকা খরচ করেছেন, বরাদ্দ ছিল ${_bn(limit)} টাকা।";
      await _flutterTts.speak(message);
      await Future.delayed(Duration(seconds: 8));
    }

    setState(() => _isSpeaking = false);
  }

  String _bn(int value) {
    const digits = ["০", "১", "২", "৩", "৪", "৫", "৬", "৭", "৮", "৯"];
    return value.toString().split('').map((d) => digits[int.parse(d)]).join();
  }

  void _pickReminderTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 20, minute: 0),
    );

    if (picked != null) {
      final now = tz.TZDateTime.now(tz.local);
      final scheduledTime = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        picked.hour,
        picked.minute,
      );

      final scheduleFor = scheduledTime.isBefore(now)
          ? scheduledTime.add(Duration(days: 1))
          : scheduledTime;

      await NotificationService.scheduleDailyReminder(
        id: 1,
        title: '📊 বাজেট রিমাইন্ডার',
        body: 'আপনি আজকের খরচ দেখেছেন কি?',
        time: scheduleFor,
      );

      // Determine Bengali time period
      String timePeriodBn;
      int hour = picked.hour;

      if (hour >= 4 && hour < 12) {
        timePeriodBn = "সকাল";
      } else if (hour >= 12 && hour < 16) {
        timePeriodBn = "দুপুর";
      } else if (hour >= 16 && hour < 19) {
        timePeriodBn = "বিকেল";
      } else if (hour >= 19 && hour < 21) {
        timePeriodBn = "সন্ধ্যা";
      } else {
        timePeriodBn = "রাত";
      }

      final int hour12 = (hour % 12 == 0) ? 12 : hour % 12;
      final String minuteBn = _bn(picked.minute);
      final String hourBn = _bn(hour12);

      final String speakText =
          "আপনার বাজেট রিমাইন্ডার সেট করা হয়েছে $timePeriodBn $hourBn টা $minuteBn মিনিটে।";

      await _flutterTts.speak(speakText);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reminder set for ${picked.format(context)}')),
      );
    }
  }



  void _showTestNotification() {
    NotificationService.showTestNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Budget Reminder")),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text("This Week's Spending", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          ...categoryOrder.map((category) {
            final data = _categoryData[category] ?? {'spent': 0.0, 'limit': 1.0};
            double spent = data['spent'];
            double limit = data['limit'];
            double percent = (spent / (limit == 0 ? 1 : limit)).clamp(0.0, 1.0);
            return GestureDetector(
              onTap: () => _editLimit(category),
              child: Container(
                margin: EdgeInsets.only(bottom: 14),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.softGray,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(_categoryIcons[category], color: _categoryColors[category], size: 28),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(category, style: TextStyle(fontWeight: FontWeight.bold)),
                              if (percent >= 1)
                                Icon(Icons.warning, size: 18, color: Colors.redAccent),
                            ],
                          ),
                          SizedBox(height: 6),
                          LinearProgressIndicator(
                            value: percent,
                            minHeight: 6,
                            color: _categoryColors[category],
                            backgroundColor: Colors.grey[300],
                          ),
                          SizedBox(height: 6),
                          Text("৳${spent.toInt()} / ৳${limit.toInt()}", style: TextStyle(fontSize: 13)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }).toList(),
          SizedBox(height: 30),
          ElevatedButton.icon(
            icon: Icon(_isSpeaking ? Icons.stop : Icons.volume_up),
            label: Text(_isSpeaking ? "Stop Summary" : "Summary Voice"),
            onPressed: _speakSummary,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
          ),
          SizedBox(height: 12),
          ElevatedButton.icon(
            icon: Icon(Icons.notifications),
            label: Text("Test Notification"),
            onPressed: _showTestNotification,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
          ),
          SizedBox(height: 12),
          ElevatedButton.icon(
            icon: Icon(Icons.alarm),
            label: Text("Set Daily Reminder"),
            onPressed: _pickReminderTime,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
