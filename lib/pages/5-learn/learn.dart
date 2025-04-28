import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:finney/pages/5-learn/how_to_use_app.dart';
import 'package:finney/pages/5-learn/smart_spending_tips.dart';
import 'package:finney/pages/5-learn/simple_budgeting.dart';
import 'package:finney/pages/5-learn/saving_money_easy.dart';
import 'package:finney/pages/5-learn/learn_progress.dart';
import 'package:finney/pages/5-learn/quiz/quiz.dart';
import 'package:finney/pages/5-learn/quiz/quiz_results_page.dart';
import 'package:finney/pages/5-learn/savings_coach.dart';

class Learn extends StatefulWidget {
  const Learn({Key? key}) : super(key: key);

  @override
  State<Learn> createState() => _LearnState();
}

class _LearnState extends State<Learn> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedTab = 'All';

  final List<Map<String, dynamic>> _lessons = [
    {
      'title': 'How to Use the App',
      'icon': LucideIcons.smartphone,
      'color': const Color(0xFFE3F2FD),
      'subtitle': 'Start here',
      'lessonKey': 'how_to_use_app',
      'totalVideos': 3,
      'page': const HowToUseApp(),
    },
    {
      'title': 'Smart Spending Tips',
      'icon': LucideIcons.badgeDollarSign,
      'color': const Color(0xFFB3E5FC),
      'subtitle': 'Spend smarter, live better',
      'lessonKey': 'smart_spending_tips',
      'totalVideos': 2,
      'page': const SmartSpendingTips(),
    },
    {
      'title': 'Simple Budgeting',
      'icon': LucideIcons.layoutDashboard,
      'color': const Color(0xFFD1C4E9),
      'subtitle': 'Plan with ease',
      'lessonKey': 'simple_budgeting',
      'totalVideos': 2,
      'page': const SimpleBudgeting(),
    },
    {
      'title': 'Saving Money Easy',
      'icon': LucideIcons.piggyBank,
      'color': const Color(0xFFE1D5F0),
      'subtitle': 'Build your future',
      'lessonKey': 'saving_money_easy',
      'totalVideos': 2,
      'page': const SavingMoneyEasy(),
    },
    {
      'title': 'Savings Coach',
      'icon': LucideIcons.coins,
      'color': const Color(0xFFFFF7E6),
      'subtitle': 'Cut costs, not dreams',
      'lessonKey': 'savings_coach',
      'totalVideos': 0,
      'status': 'activity',
      'page': SavingsCoach(),
    },
  ];

  final List<Map<String, dynamic>> _quizItems = [
    {
      'title': 'Take the Quiz',
      'icon': LucideIcons.bookOpen,
      'color': const Color(0xFFFFF3E0),
      'subtitle': 'Test your knowledge',
      'lessonKey': 'quiz_section',
      'totalVideos': 0,
      'page': const QuizPage(),
    },
    {
      'title': 'View Quiz Results',
      'icon': LucideIcons.barChart,
      'color': const Color(0xFFE0F7FA),
      'subtitle': 'See your scores',
      'lessonKey': 'quiz_results',
      'totalVideos': 0,
      'page': const QuizResultsPage(),
    },
  ];

  @override
  void initState() {
    super.initState();
    _updateLessonStatuses();
  }

  void _updateLessonStatuses() {
    for (var lesson in _lessons) {
      if (lesson['status'] == 'activity') {
        lesson['progress'] = 0.0;
        continue;
      }
      final int total = lesson['totalVideos'];
      if (total == 0) {
        lesson['progress'] = 0.0;
        lesson['status'] = 'all';
        continue;
      }
      final completed = LearnProgress.getCompletedCount(lesson['lessonKey'], total);
      final isDone = LearnProgress.isLessonCompleted(lesson['lessonKey'], total);
      lesson['progress'] = completed / total;
      lesson['status'] = isDone ? 'completed' : (completed > 0 ? 'ongoing' : 'all');
    }
  }

  void _resetAllProgress() {
    LearnProgress.resetAll(
      _lessons.where((e) => e['totalVideos'] > 0).map((e) => e['lessonKey'] as String).toList(),
    );
    setState(_updateLessonStatuses);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Learning progress reset.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isQuizTab = _selectedTab == 'Quiz';
    final filteredList = isQuizTab
        ? _quizItems
        : _lessons.where((item) {
            final searchText = _searchController.text.toLowerCase();
            final matchesSearch = item['title'].toLowerCase().contains(searchText);
            final matchesTab = _selectedTab == 'All'
                ? true
                : _selectedTab.toLowerCase() == item['status'];
            return matchesSearch && matchesTab;
          }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'LearningHub',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.blueAccent,
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          if (_selectedTab == 'All')
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.blueAccent),
              onPressed: _resetAllProgress,
              tooltip: 'Reset Progress',
            )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Column(
          children: [
            Row(
              children: [
                _buildTab('All'),
                _buildTab('Ongoing'),
                _buildTab('Completed'),
                _buildTab('Quiz'),
              ],
            ),
            const SizedBox(height: 16),
            _buildSearchBar(),
            const SizedBox(height: 16),
            Expanded(
              child: filteredList.isEmpty
                  ? const Center(child: Text('No results found.'))
                  : ListView.separated(
                      itemCount: filteredList.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final item = filteredList[index];
                        return GestureDetector(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => item['page']),
                            );
                            setState(_updateLessonStatuses);
                          },
                          child: _buildLessonCard(
                            title: item['title'],
                            icon: item['icon'],
                            backgroundColor: item['color'],
                            subtitle: item['subtitle'],
                            progress: item['progress'] ?? 0.0,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String label) {
    final isActive = _selectedTab == label;
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = label),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? Colors.blueAccent : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (_) => setState(() {}),
        decoration: const InputDecoration(
          icon: Icon(Icons.search),
          hintText: 'Search for topics...',
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildLessonCard({
    required String title,
    required IconData icon,
    required Color backgroundColor,
    required String subtitle,
    required double progress,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, size: 36, color: Colors.black87),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                if (subtitle.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      subtitle,
                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ),
                if (progress > 0.0)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.white54,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                  ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
        ],
      ),
    );
  }
}
