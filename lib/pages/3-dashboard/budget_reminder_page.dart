import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:finney/pages/3-dashboard/transaction/transaction_services.dart';
import 'package:finney/pages/3-dashboard/models/transaction_model.dart';



class BudgetReminderPage extends StatefulWidget {
  const BudgetReminderPage({Key? key}) : super(key: key);

  @override
  State<BudgetReminderPage> createState() => _BudgetReminderPageState();
}

class _BudgetReminderPageState extends State<BudgetReminderPage> {
  TimeOfDay? _selectedTime;
  final FlutterTts _flutterTts = FlutterTts();

  String _repeatFrequency = "Never (কখনো না)";

  final List<String> _repeatOptions = [
    "Never (কখনো না)",
    "Daily (প্রতিদিন)",
    "Weekly (সাপ্তাহিক)",
    "Monthly (মাসিক)",
  ];

  @override
  void initState() {
    super.initState();
    _loadReminderTime();
    _flutterTts.setLanguage("bn-BD");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Budget Reminder (বাজেট অনুস্মারক)"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const BudgetGraphSection(),
            const SizedBox(height: 20),
            const CategoryListSection(),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.alarm),
              label: const Text("Set Reminder (রিমাইন্ডার সেট করুন)"),
              onPressed: _pickTime,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: const TextStyle(fontSize: 16),
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            if (_selectedTime != null)
              Text(
                "Reminder Time (রিমাইন্ডার সময়): ${_selectedTime!.format(context)}",
                style: const TextStyle(fontSize: 16),
              ),
            const SizedBox(height: 20),
            Text(
              "Repeat Frequency (পুনরাবৃত্তি):",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _repeatOptions.map((option) {
                bool isSelected = _repeatFrequency == option;
                return GestureDetector(
                  onTap: () async {
                    setState(() {
                      _repeatFrequency = option;
                    });
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString("reminder_repeat", option);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.deepPurple : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? Colors.deepPurple : Colors.grey.shade300,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      option,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt("reminder_hour", picked.hour);
      await prefs.setInt("reminder_minute", picked.minute);

      final hour = picked.hour.toString().padLeft(2, '0');
      final minute = picked.minute.toString().padLeft(2, '0');
      final banglaTime = "$hour:$minute";
      final message = "আপনার রিমাইন্ডার $banglaTime টায় সেট হয়েছে";

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("🔊 Speaking Bengali reminder...")),
      );

      Future.delayed(const Duration(milliseconds: 300), () async {
        await _flutterTts.setLanguage("bn-BD");
        await _flutterTts.speak(message);
      });
    }
  }

  Future<void> _loadReminderTime() async {
    final prefs = await SharedPreferences.getInstance();
    final int? hour = prefs.getInt("reminder_hour");
    final int? minute = prefs.getInt("reminder_minute");
    final String? repeat = prefs.getString("reminder_repeat");

    if (hour != null && minute != null) {
      setState(() {
        _selectedTime = TimeOfDay(hour: hour, minute: minute);
      });
    }

    if (repeat != null) {
      setState(() {
        _repeatFrequency = repeat;
      });
    }
  }
}

class BudgetGraphSection extends StatefulWidget {
  const BudgetGraphSection({super.key});

  @override
  State<BudgetGraphSection> createState() => _BudgetGraphSectionState();
}

class _BudgetGraphSectionState extends State<BudgetGraphSection> {
  final _flutterTts = FlutterTts();
  final _transactionStream = TransactionService().getTransactions();

  final List<String> bengaliDaysFull = [
    "সোমবার",
    "মঙ্গলবার",
    "বুধবার",
    "বৃহস্পতিবার",
    "শুক্রবার",
    "শনিবার",
    "রবিবার",
  ];

  final Map<int, double> _weeklyTotals = {
    1: 0,
    2: 0,
    3: 0,
    4: 0,
    5: 0,
    6: 0,
    7: 0,
  };

  int _tappedIndex = -1;
  String _selectedFilter = "This Week";

  @override
  void initState() {
    super.initState();
    _flutterTts.setLanguage("bn-BD");
  }

  bool isInFilterRange(DateTime date) {
    final now = DateTime.now();
    if (_selectedFilter == "This Week") {
      final start = now.subtract(Duration(days: now.weekday - 1));
      final end = start.add(const Duration(days: 6));
      return date.isAfter(start.subtract(const Duration(days: 1))) &&
          date.isBefore(end.add(const Duration(days: 1)));
    } else if (_selectedFilter == "This Month") {
      return date.month == now.month && date.year == now.year;
    }
    return false;
  }

  void _speakBar(int index, double amount) {
    final day = bengaliDaysFull[index];
    final text = "$day আপনি খরচ করেছেন ${amount.toInt()} টাকা।";
    _flutterTts.speak(text);
    setState(() => _tappedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TransactionModel>>(
      stream: _transactionStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        _weeklyTotals.updateAll((key, value) => 0);

        for (var tx in snapshot.data!) {
          if (!tx.isIncome && isInFilterRange(tx.date)) {
            final weekday = tx.date.weekday;
            _weeklyTotals.update(weekday, (value) => value + tx.amount.abs());
          }
        }

        final List<BarChartGroupData> bars = List.generate(7, (i) {
          final weekday = i + 1;
          final amount = _weeklyTotals[weekday]!;
          final color = amount >= 1000
              ? Colors.red
              : amount >= 800
              ? Colors.orange
              : Colors.green;

          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: amount,
                color: color,
                width: 18,
                borderRadius: BorderRadius.circular(4),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: 1500,
                  color: Colors.grey.shade300,
                ),
              )
            ],
          );
        });

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown aligned to left
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedFilter,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.black87),
                dropdownColor: Colors.white,
                style: const TextStyle(color: Colors.black87, fontSize: 14),
                borderRadius: BorderRadius.circular(10),
                items: const [
                  DropdownMenuItem(value: "This Week", child: Text("This Week")),
                  DropdownMenuItem(value: "This Month", child: Text("This Month")),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedFilter = value);
                  }
                },
              ),
            ),
            const SizedBox(height: 6),

            // Dynamic title based on selection
            Text(
              _selectedFilter == "This Week"
                  ? "This Week’s Spending (এই সপ্তাহের খরচ)"
                  : "This Month’s Spending (এই মাসের খরচ)",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),

            // Bar chart
            Container(
              height: 250,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: BarChart(
                BarChartData(
                  maxY: 1500,
                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(show: false),
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchCallback: (event, response) {
                      if (response != null && response.spot != null) {
                        final index = response.spot!.touchedBarGroupIndex;
                        final amount = _weeklyTotals[index + 1]!;
                        _speakBar(index, amount);
                      }
                    },
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.deepPurple,
                      getTooltipItem: (group, _, rod, __) {
                        return BarTooltipItem(
                          '৳${rod.toY.toInt()}',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, _) {
                          return Text(
                            bengaliDaysFull[value.toInt()].substring(0, 2),
                            style: const TextStyle(fontSize: 13),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 500,
                        getTitlesWidget: (value, _) => Text("৳${value.toInt()}",
                            style: const TextStyle(fontSize: 10)),
                      ),
                    ),
                  ),
                  barGroups: bars,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "✅ On Track (ঠিকঠাক চলছে)",
              style: TextStyle(color: Colors.green),
            ),
          ],
        );
      },
    );
  }
}




class CategoryListSection extends StatefulWidget {
  const CategoryListSection({super.key});

  @override
  State<CategoryListSection> createState() => _CategoryListSectionState();
}

class _CategoryListSectionState extends State<CategoryListSection> {
  final Map<String, double> _spentAmounts = {
    "Food": 690,
    "Transport": 300,
    "Housing": 1200,
    "Shopping": 200,
  };

  final Map<String, String> _labelsBn = {
    "Food": "খাবার ও পানীয়",
    "Transport": "যাতায়াত",
    "Housing": "বাসাভাড়া",
    "Shopping": "কেনাকাটা",
  };

  final Map<String, double> _budgetGoals = {
    "Food": 1000,
    "Transport": 500,
    "Housing": 2000,
    "Shopping": 600,
  };

  @override
  void initState() {
    super.initState();
    _loadGoals();
  }

  Future<void> _loadGoals() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _budgetGoals.updateAll((key, value) =>
      prefs.getDouble("goal_$key") ?? _budgetGoals[key]!);
    });
  }

  Future<void> _editGoal(String category) async {
    final prefs = await SharedPreferences.getInstance();
    final controller = TextEditingController(
        text: _budgetGoals[category]!.toInt().toString());

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Set Budget for $category (${_labelsBn[category]})"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Enter amount (৳)"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final newGoal = double.tryParse(controller.text);
              if (newGoal != null && newGoal > 0) {
                setState(() {
                  _budgetGoals[category] = newGoal;
                });
                prefs.setDouble("goal_$category", newGoal);
              }
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, String> icons = {
      "Food": "🍽️",
      "Transport": "🚗",
      "Housing": "🏠",
      "Shopping": "🛍️",
    };

    return Column(
      children: _spentAmounts.keys.map((category) {
        final spent = _spentAmounts[category]!;
        final goal = _budgetGoals[category]!;
        final percent = spent / goal;
        final Color barColor = percent >= 1
            ? Colors.red
            : (percent >= 0.8 ? Colors.orange : Colors.blue);

        String? warningText;
        if (percent >= 1) {
          warningText = "⚠️ Limit exceeded! (⚠️ বাজেট অতিক্রম করা হয়েছে)";
        } else if (percent >= 0.8) {
          warningText = "⚠️ Near limit! (⚠️ আপনি বাজেটের ৮০% ব্যবহার করেছেন)";
        }

        return GestureDetector(
          onTap: () => _editGoal(category),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(icons[category]!, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$category (${_labelsBn[category]})",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 6),
                      LinearProgressIndicator(
                        value: percent,
                        backgroundColor: Colors.grey.shade300,
                        color: barColor,
                        minHeight: 8,
                      ),
                      const SizedBox(height: 4),
                      Text("৳${spent.toInt()} / ৳${goal.toInt()}"),
                      if (warningText != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            warningText,
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
