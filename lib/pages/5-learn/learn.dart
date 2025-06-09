import 'package:finney/shared/localization/locales.dart';
import 'package:finney/shared/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:finney/pages/5-learn/financial_learn/smart_spending_tips.dart';
import 'package:finney/pages/5-learn/financial_learn/simple_budgeting.dart';
import 'package:finney/pages/5-learn/financial_learn/saving_money_easy.dart';
import 'package:finney/pages/5-learn/financial_learn/learn_progress.dart';
import 'package:finney/pages/5-learn/app_tour/dashboard_edu.dart';
import 'package:finney/pages/5-learn/app_tour/expense_tracking_edu.dart';
import 'package:finney/pages/5-learn/app_tour/saving_goals_edu.dart';
import 'package:finney/pages/5-learn/app_tour/budget_reminder_edu.dart';
import 'package:finney/pages/5-learn/app_tour/chatbot_edu.dart';
import 'package:finney/pages/5-learn/app_tour/report_edu.dart';
import 'package:finney/pages/5-learn/app_tour/learnhub_module_edu.dart';
import 'package:finney/pages/5-learn/app_tour/settings_edu.dart';
import 'package:finney/pages/5-learn/quiz/quiz.dart';
import 'package:finney/pages/5-learn/quiz/quiz_results_page.dart';
import 'package:finney/pages/5-learn/financial_learn/savings_coach.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:finney/shared/widgets/common/snack_bar.dart';
import 'package:finney/shared/widgets/common/settings_notifier.dart';

class Learn extends StatefulWidget {
  const Learn({super.key});

  @override
  State<Learn> createState() => _LearnState();
}

class _LearnState extends State<Learn> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedTab = 'Lessons';

  final Map<String, Map<String, dynamic>> _lessonProgress = {};

  List<Map<String, dynamic>> get _lessons => [
    {
      'title': LocaleData.smartSpendingTips.getString(context),
      'icon': LucideIcons.badgeDollarSign,
      'color': const Color(0xFFB3E5FC),
      'subtitle': LocaleData.smartSpendingTipsSubtitle.getString(context),
      'lessonKey': 'smart_spending_tips',
      'totalVideos': 2,
      'page': const SmartSpendingTips(),
    },
    {
      'title': LocaleData.simpleBudgetingTitle.getString(context),
      'icon': LucideIcons.layoutDashboard,
      'color': const Color(0xFFD1C4E9),
      'subtitle': LocaleData.simpleBudgetingSubtitle.getString(context),
      'lessonKey': 'simple_budgeting',
      'totalVideos': 2,
      'page': const SimpleBudgeting(),
    },
    {
      'title': LocaleData.savingMoneyEasy.getString(context),
      'icon': LucideIcons.piggyBank,
      'color': const Color(0xFFE1D5F0),
      'subtitle': LocaleData.savingMoneyEasySubtitle.getString(context),
      'lessonKey': 'saving_money_easy',
      'totalVideos': 2,
      'page': const SavingMoneyEasy(),
    },
    {
      'title': LocaleData.savingsCoach.getString(context),
      'icon': LucideIcons.coins,
      'color': const Color(0xFFDFF8EB),
      'subtitle': LocaleData.savingsCoachSubtitle.getString(context),
      'lessonKey': 'savings_coach',
      'totalVideos': 0,
      'status': 'activity',
      'page': SavingsCoach(),
    },
  ];

  List<Map<String, dynamic>> get _appTourLessons => [
    {
      'title': LocaleData.dashboard.getString(context),
      'icon': LucideIcons.layoutDashboard,
      'color': const Color(0xFFBBDEFB),
      'subtitle': LocaleData.apptourDashSubtitle.getString(context),
      'lessonKey': 'dashboard_edu',
      'totalVideos': 1,
      'page': const DashboardEduPage(),
    },
    {
      'title': LocaleData.expenseTracking.getString(context),
      'icon': LucideIcons.fileSpreadsheet,
      'color': const Color(0xFFB2EBF2),
      'subtitle': LocaleData.expenseTrackingSubtite.getString(context),
      'lessonKey': 'expense_tracking_edu',
      'totalVideos': 1,
      'page': const ExpenseTrackingEduPage(),
    },
    {
      'title': LocaleData.savingGoals.getString(context),
      'icon': LucideIcons.flag,
      'color': const Color(0xFFC5CAE9),
      'subtitle': LocaleData.savingGoalSubheading.getString(context),
      'lessonKey': 'saving_goals_edu',
      'totalVideos': 1,
      'page': const SavingGoalsEduPage(),
    },
    {
      'title': LocaleData.tourBudgetTitle.getString(context),
      'icon': LucideIcons.bell,
      'color': const Color(0xFFDCEDC8),
      'subtitle': LocaleData.tourBudgetSubTitle.getString(context),
      'lessonKey': 'budget_reminder_edu',
      'totalVideos': 1,
      'page': const BudgetReminderEduPage(),
    },
    {
      'title': LocaleData.tourChatbotTitle.getString(context),
      'icon': LucideIcons.messageSquare,
      'color': const Color(0xFFFFCDD2),
      'subtitle': LocaleData.tourCahtBotSubtite.getString(context),
      'lessonKey': 'chatbot_edu',
      'totalVideos': 1,
      'page': const ChatbotEduPage(),
    },
    {
      'title': LocaleData.tourReportTitle.getString(context),
      'icon': LucideIcons.barChart,
      'color': const Color(0xFFC8E6C9),
      'subtitle': LocaleData.tourReportSubtite.getString(context),
      'lessonKey': 'report_edu',
      'totalVideos': 1,
      'page': const ReportEduPage(),
    },
    {
      'title': LocaleData.learnHub.getString(context),
      'icon': LucideIcons.bookOpenCheck,
      'color': const Color(0xFFB3E5FC),
      'subtitle': LocaleData.learnHubSubtitle.getString(context),
      'lessonKey': 'learnhub_module_edu',
      'totalVideos': 1,
      'page': const LearnhubModuleEduPage(),
    },
    {
      'title': LocaleData.settings.getString(context),
      'icon': LucideIcons.settings,
      'color': const Color(0xFFB39DDB),
      'subtitle': LocaleData.settingSubHeading.getString(context),
      'lessonKey': 'settings_edu',
      'totalVideos': 1,
      'page': const SettingsEduPage(),
    },
  ];

  List<Map<String, dynamic>> get _quizItems => [
    {
      'title': LocaleData.taketheQuiz.getString(context),
      'icon': LucideIcons.bookOpen,
      'color': const Color(0xFFE1BEE7),
      'subtitle': LocaleData.taketheQuizSubtitle.getString(context),
      'lessonKey': 'quiz_section',
      'totalVideos': 0,
      'page': const QuizPage(),
    },
    {
      'title': LocaleData.viewQuizResult.getString(context),
      'icon': LucideIcons.barChart,
      'color': const Color(0xFFE0F7FA),
      'subtitle': LocaleData.quizResultSubtitle.getString(context),
      'lessonKey': 'quiz_results',
      'totalVideos': 0,
      'page': const QuizResultsPage(),
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateLessonStatuses();
    });
  }

  Future<void> _updateLessonStatuses() async {
    for (var lesson in [..._lessons, ..._appTourLessons]) {
      final String key = lesson['lessonKey'];

      _lessonProgress[key] ??= {'progress': 0.0, 'status': 'all'};

      if (lesson['status'] == 'activity' || lesson['totalVideos'] == 0) {
        _lessonProgress[key]!['progress'] = 0.0;
        _lessonProgress[key]!['status'] = lesson['status'] ?? 'all';
        continue;
      }

      final int total = lesson['totalVideos'];
      final completed = await LearnProgress.getCompletedCount(key, total);
      final isDone = await LearnProgress.isLessonCompleted(key, total);

      _lessonProgress[key]!['progress'] = completed / total;
      _lessonProgress[key]!['status'] =
      isDone ? 'completed' : (completed > 0 ? 'ongoing' : 'all');
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _resetAllProgress() async {
    await LearnProgress.resetAll(
      [..._lessons, ..._appTourLessons]
          .where((e) => e['totalVideos'] > 0)
          .map((e) => e['lessonKey'] as String)
          .toList(),
    );

    _lessonProgress.clear();

    await _updateLessonStatuses();

    if (mounted) {
      AppSnackBar.showSuccess(
        context,
        message: LocaleData.learningReset.getString(context),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateLessonStatuses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isQuizTab = _selectedTab == 'Quiz';
    final isAppTourTab = _selectedTab == 'App Tour';
    final isLessonsTab = _selectedTab == 'Lessons';
    final isProgressTab = _selectedTab == 'Progress';

    final allItems = [..._lessons, ..._appTourLessons];

    final allItemsWithProgress = allItems.map((lesson) {
      final key = lesson['lessonKey'];
      final progress = _lessonProgress.containsKey(key)
          ? _lessonProgress[key]!
          : {'progress': 0.0, 'status': 'all'};
      return {
        ...lesson,
        'progress': progress['progress'],
        'status': progress['status'],
      };
    }).toList();

    final ongoingLessons =
    allItemsWithProgress.where((e) => e['status'] == 'ongoing').toList();
    final completedLessons =
    allItemsWithProgress.where((e) => e['status'] == 'completed').toList();

    final searchText = _searchController.text.toLowerCase();

    final filteredList = searchText.isNotEmpty
        ? [...allItemsWithProgress, ..._quizItems]
        .where((item) => item['title'].toLowerCase().contains(searchText))
        .toList()
        : isQuizTab
        ? _quizItems
        : isAppTourTab
        ? allItemsWithProgress
        .where((e) => _appTourLessons.any(
          (a) => a['lessonKey'] == e['lessonKey'],
    ))
        .toList()
        : isLessonsTab
        ? allItemsWithProgress
        .where((e) => _lessons.any((l) => l['lessonKey'] == e['lessonKey']))
        .toList()
        : [];

    return ValueListenableBuilder<String>(
      valueListenable: SettingsNotifier().textSizeNotifier,
      builder: (context, textSize, child) {
        double textScaleFactor;
        switch (textSize) {
          case 'Small':
            textScaleFactor = 0.8;
            break;
          case 'Large':
            textScaleFactor = 1.2;
            break;
          default:
            textScaleFactor = 1.0;
        }
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(textScaleFactor),
          ),
          child: Scaffold(
            backgroundColor: const Color(0xFFF5F7FB),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                LocaleData.learningHub.getString(context),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: AppColors.darkBlue,
                  letterSpacing: 1.2,
                ),
              ),
              actions: [
                if (_selectedTab == 'Lessons' || _selectedTab == 'App Tour')
                  IconButton(
                    icon: const Icon(Icons.refresh, color: AppColors.darkBlue),
                    onPressed: _resetAllProgress,
                    tooltip: 'Reset Progress',
                  ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Column(
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildTab('Lessons'),
                      _buildTab('App Tour'),
                      _buildTab('Progress'),
                      _buildTab('Quiz'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildSearchBar(),
                  const SizedBox(height: 16),
                  Expanded(
                    child: isProgressTab
                        ? ListView(
                      padding: const EdgeInsets.only(bottom: 24),
                      children: [
                        Text(
                          LocaleData.ongoing.getString(context),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...ongoingLessons.map(
                              (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildCardItem(item),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          LocaleData.completed.getString(context),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...completedLessons.map(
                              (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildCardItem(item),
                          ),
                        ),
                      ],
                    )
                        : filteredList.isEmpty
                        ? Center(
                      child: Text(
                        LocaleData.noResultsFound.getString(context),
                      ),
                    )
                        : ListView.separated(
                      itemCount: filteredList.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) => _buildCardItem(filteredList[index]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTab(String label) {
    String localizedLabel;
    if (label == 'Lessons') {
      localizedLabel = LocaleData.lessons.getString(context);
    } else if (label == 'App Tour') {
      localizedLabel = LocaleData.appTour.getString(context);
    } else if (label == 'Progress') {
      localizedLabel = LocaleData.progress.getString(context);
    } else if (label == 'Quiz') {
      localizedLabel = LocaleData.quiz.getString(context);
    } else {
      localizedLabel = label;
    }
    final isActive = _selectedTab == label;
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = label),
        child: Container(
          constraints: const BoxConstraints(minWidth: 60, maxWidth: 120), 
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? Colors.blueAccent : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              localizedLabel,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey,
                fontWeight: FontWeight.w600,
              ),
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
        decoration: InputDecoration(
          icon: Icon(Icons.search),
          hintText: LocaleData.searchTextfiedText.getString(context),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildCardItem(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => item['page']),
        );
        if (mounted) {
          await _updateLessonStatuses();
        }
      },
      child: _buildLessonCard(
        title: item['title'],
        icon: item['icon'],
        backgroundColor: item['color'],
        subtitle: item['subtitle'],
        progress: item['progress'] ?? 0.0,
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
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                if (progress > 0.0)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.white54,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.green,
                      ),
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