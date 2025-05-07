import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:finney/pages/3-dashboard/transaction/transaction_services.dart';
import 'package:finney/pages/1-auth/models/user_model.dart';

class BudgetReminderPage extends StatefulWidget {
  const BudgetReminderPage({super.key});

  @override
  State<BudgetReminderPage> createState() => _BudgetReminderPageState();
}

class _BudgetReminderPageState extends State<BudgetReminderPage> {
  final FlutterTts _flutterTts = FlutterTts();
  final stt.SpeechToText _speech = stt.SpeechToText();
  final TransactionService _transactionService = TransactionService();

  TimeOfDay? _selectedTime;
  String _repeat = "Never";
  bool _isBengali = true;

  Map<String, double> _weeklySpending = {
    "Mon": 0,
    "Tue": 0,
    "Wed": 0,
    "Thu": 0,
    "Fri": 0,
    "Sat": 0,
    "Sun": 0,
  };

  final Map<String, dynamic> _categoryColors = {
    "Food": {"icon": "🍔", "color": Colors.blue},
    "Transport": {"icon": "🚗", "color": Colors.blue},
    "Housing": {"icon": "🏠", "color": Colors.orange},
    "Shopping": {"icon": "🛍️", "color": Colors.blue},
  };

  final List<String> _dayOrder = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

  @override
  void initState() {
    super.initState();
    _flutterTts.setLanguage("bn-BD");
    _flutterTts.setSpeechRate(0.4);
    _flutterTts.awaitSpeakCompletion(true);
    _loadReminderSettings();
    _loadWeeklyExpenses();
  }

  Future<void> _loadReminderSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final int? hour = prefs.getInt("reminder_hour");
    final int? minute = prefs.getInt("reminder_minute");
    final String? repeat = prefs.getString("reminder_repeat");

    if (hour != null && minute != null) {
      setState(() => _selectedTime = TimeOfDay(hour: hour, minute: minute));
    }
    if (repeat != null) {
      setState(() => _repeat = repeat);
    }
  }

  Future<void> _loadWeeklyExpenses() async {
    final expenses = await _transactionService.getWeeklyExpenses();
    setState(() {
      _weeklySpending = {for (var e in expenses) e.day: e.amount};
    });
  }

  Future<void> _editBudgetLimitFirestore(String categoryName, double currentLimit) async {
    final controller = TextEditingController(text: currentLimit.toInt().toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Set Budget for $categoryName"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: "Enter limit in ৳"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              final newLimit = double.tryParse(controller.text);
              if (newLimit != null) {
                final userId = Hive.box<UserModel>('userBox').get('user')?.uid ?? '';
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .collection('budgets')
                    .doc(categoryName)
                    .update({"limit": newLimit});
                Navigator.pop(context);
              }
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }

  String _bn(int value) {
    const digits = ["০", "১", "২", "৩", "৪", "৫", "৬", "৭", "৮", "৯"];
    return value.toString().split('').map((d) => digits[int.parse(d)]).join();
  }

  void _speakSummary() {
    double totalSpent = 0;
    double totalLimit = 0;
    _weeklySpending.forEach((_, value) => totalSpent += value);
    totalLimit = 5000; // You can pull this from Firestore if needed
    final percent = (totalSpent / totalLimit * 100).toInt();
    _flutterTts.speak("আপনি এই সপ্তাহে ${_bn(percent)} শতাশী খরচ করেছেন\।");
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt("reminder_hour", picked.hour);
      await prefs.setInt("reminder_minute", picked.minute);
      final banglaTime = "${_bn(picked.hour)}:${_bn(picked.minute)}";
      await _flutterTts.speak("আপনার বাজেট রিমাইন্ডার সেট হয়েছে $banglaTime টায়\।");
      setState(() => _selectedTime = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = Hive.box<UserModel>('userBox').get('user')?.uid ?? '';
    return Scaffold(
      appBar: AppBar(
        title: const Text("Budget Reminder"),
        actions: [
          IconButton(
            icon: Icon(_isBengali ? Icons.language : Icons.translate),
            onPressed: () => setState(() => _isBengali = !_isBengali),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text("This Week's Spending", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            SizedBox(
              height: 180,
              child: BarChart(
                BarChartData(
                  barGroups: _dayOrder.asMap().entries.map((entry) {
                    int index = entry.key;
                    String day = entry.value;
                    double amount = _weeklySpending[day] ?? 0;
                    return BarChartGroupData(x: index, barRods: [
                      BarChartRodData(toY: amount, color: Colors.purple, width: 16)
                    ]);
                  }).toList(),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) => Text(_dayOrder[value.toInt()].substring(0, 1)),
                      ),
                    ),
                  ),
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
            const SizedBox(height: 10),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId)
                  .collection('budgets')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                final docs = snapshot.data!.docs;
                return Column(
                  children: docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final name = data['category'] ?? '';
                    final spent = data['spent']?.toDouble() ?? 0.0;
                    final limit = data['limit']?.toDouble() ?? 1.0;
                    final percent = spent / limit;
                    final icon = _categoryColors[name]?['icon'] ?? "❓";
                    final color = _categoryColors[name]?['color'] ?? Colors.grey;
                    final statusIcon = percent >= 1
                        ? Icons.warning_rounded
                        : (percent >= 0.8 ? Icons.info_outline : null);
                    return GestureDetector(
                      onTap: () => _editBudgetLimitFirestore(name, limit),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
                        ),
                        child: Row(
                          children: [
                            Text(icon, style: const TextStyle(fontSize: 28)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                      if (statusIcon != null) ...[
                                        const SizedBox(width: 6),
                                        Icon(statusIcon, size: 18, color: Colors.redAccent),
                                      ]
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  LinearProgressIndicator(
                                    value: percent.clamp(0.0, 1.0),
                                    backgroundColor: Colors.grey[300],
                                    color: color,
                                    minHeight: 8,
                                  ),
                                  const SizedBox(height: 6),
                                  Text("৳${spent.toInt()} / ৳${limit.toInt()}", style: const TextStyle(fontSize: 13)),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.alarm),
              label: const Text("Set Reminder"),
              onPressed: _pickTime,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.volume_up),
              label: const Text("Summary Voice"),
              onPressed: _speakSummary,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            if (_selectedTime != null)
              Text("Reminder Time: ${_selectedTime!.format(context)}",
                  style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 20),
            const Text("Repeat Frequency:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: ["Never", "Daily", "Weekly", "Monthly"].map((freq) {
                final selected = _repeat == freq;
                return ChoiceChip(
                  label: Text(freq),
                  selected: selected,
                  onSelected: (_) async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString("reminder_repeat", freq);
                    setState(() => _repeat = freq);
                  },
                  selectedColor: Colors.purple,
                );
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}

class WeeklyExpense {
  final String day;
  final double amount;
  WeeklyExpense(this.day, this.amount);
}
