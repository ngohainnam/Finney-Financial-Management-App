import 'package:flutter_localization/flutter_localization.dart';

mixin LocaleData {
  static const String appTitle = 'appTitle';
  static const String settings = 'settings';
  static const String viewProfile = 'viewProfile';
  static const String profileInformation = 'profileInformation';
  static const String fullName = 'fullName';
  static const String phoneNumber = 'phoneNumber';
  static const String address = 'address';
  static const String email = 'email';
  static const String userId = 'userId';
  static const String edit = 'edit';
  static const String save = 'save';
  static const String close = 'close';
  static const String appearance = 'appearance';
  static const String language = 'language';
  static const String languageEnglish = 'languageEnglish';
  static const String languageBengali = 'languageBengali';
  static const String currency = 'currency';
  static const String currencyBDT = 'currencyBDT';
  static const String currencyAUD = 'currencyAUD';
  static const String textSize = 'textSize';
  static const String management = 'management';
  static const String security = 'security';
  static const String setPin = 'setPin';
  static const String enterPin = 'enterPin';
  static const String confirmPin = 'confirmPin';
  static const String pinSaved = 'pinSaved';
  static const String invalidPin = 'invalidPin';
  static const String pinsDoNotMatch = 'pinsDoNotMatch';
  static const String cancel = 'cancel';
  static const String helpSupport = 'helpSupport';
  static const String helpSupportComingSoon = 'helpSupportComingSoon';
  static const String logOut = 'logOut';
  static const String signedOut = 'signedOut';
  static const String errorLoadingData = 'errorLoadingData';
  static const String errorSavingData = 'errorSavingData';
  static const String user = 'user';
  static const String notAvailable = 'notAvailable';
  // Previous Learn page keys
  static const String financialBasics = 'financialBasics';
  static const String askFinneyAI = 'askFinneyAI';
  static const String moneyManagement = 'moneyManagement';
  static const String moneyManagementSubtitle = 'moneyManagementSubtitle';
  static const String savingBudgeting = 'savingBudgeting';
  static const String savingBudgetingSubtitle = 'savingBudgetingSubtitle';
  static const String investingFundamentals = 'investingFundamentals';
  static const String investingFundamentalsSubtitle =
      'investingFundamentalsSubtitle';
  static const String financialSafety = 'financialSafety';
  static const String financialSafetySubtitle = 'financialSafetySubtitle';
  static const String keyPoints = 'keyPoints';
  static const String learnMore = 'learnMore';
  static const String backToTopics = 'backToTopics';
  static const String aiAssistant = 'aiAssistant';
  static const String moneyManagementPoint1 = 'moneyManagementPoint1';
  static const String moneyManagementPoint2 = 'moneyManagementPoint2';
  static const String moneyManagementPoint3 = 'moneyManagementPoint3';
  static const String moneyManagementPoint4 = 'moneyManagementPoint4';
  static const String savingBudgetingPoint1 = 'savingBudgetingPoint1';
  static const String savingBudgetingPoint2 = 'savingBudgetingPoint2';
  static const String savingBudgetingPoint3 = 'savingBudgetingPoint3';
  static const String savingBudgetingPoint4 = 'savingBudgetingPoint4';
  static const String investingFundamentalsPoint1 =
      'investingFundamentalsPoint1';
  static const String investingFundamentalsPoint2 =
      'investingFundamentalsPoint2';
  static const String investingFundamentalsPoint3 =
      'investingFundamentalsPoint3';
  static const String investingFundamentalsPoint4 =
      'investingFundamentalsPoint4';
  static const String financialSafetyPoint1 = 'financialSafetyPoint1';
  static const String financialSafetyPoint2 = 'financialSafetyPoint2';
  static const String financialSafetyPoint3 = 'financialSafetyPoint3';
  static const String financialSafetyPoint4 = 'financialSafetyPoint4';
  static const String resourceMoneyManagementVideo =
      'resourceMoneyManagementVideo';
  static const String resourceMoneyManagementArticle1 =
      'resourceMoneyManagementArticle1';
  static const String resourceMoneyManagementArticle2 =
      'resourceMoneyManagementArticle2';
  static const String resourceSavingVideo = 'resourceSavingVideo';
  static const String resourceSavingArticle = 'resourceSavingArticle';
  static const String resourceInvestingVideo = 'resourceInvestingVideo';
  static const String resourceInvestingArticle = 'resourceInvestingArticle';
  static const String resourceSafetyVideo1 = 'resourceSafetyVideo1';
  static const String resourceSafetyVideo2 = 'resourceSafetyVideo2';
  static const String resourceSafetyArticle1 = 'resourceSafetyArticle1';
  static const String resourceSafetyArticle2 = 'resourceSafetyArticle2';
  // Chatbot page keys
  static const String chatbotTitle = 'chatbotTitle';
  static const String chatbotHelp = 'chatbotHelp';
  static const String chatbotClearChat = 'chatbotClearChat';
  static const String welcomeMessage = 'welcomeMessage';
  static const String suggestedQuestion1 = 'suggestedQuestion1';
  static const String suggestedQuestion2 = 'suggestedQuestion2';
  static const String suggestedQuestion3 = 'suggestedQuestion3';
  static const String chatbotsuggestedQuestion1 = 'chatbotsuggestedQuestion1';
  static const String chatbotsuggestedQuestion2 = 'chatbotsuggestedQuestion2';
  static const String chatbotsuggestedQuestion3 = 'chatbotsuggestedQuestion3';
  // New Learn page keys
  static const String learnReset = 'learnReset';
  static const String learnNoResults = 'learnNoResults';

  static const String financialLearning = 'financialLearning';
  static const String beginner = 'beginner';
  static const String beginnerSubtitle = 'beginnerSubtitle';
  static const String intermediate = 'intermediate';
  static const String intermediateSubtitle = 'intermediateSubtitle';
  static const String advanced = 'advanced';
  static const String advancedSubtitle = 'advancedSubtitle';
  static const String testYourKnowledge = 'testYourKnowledge';
  static const String testYourKnowledgeSubtitle = 'testYourKnowledgeSubtitle';
  static const String saveHabitTitle = 'saveHabitTitle';
  static const String saveHabitDesc = 'saveHabitDesc';
  static const String saveWhyTitle = 'saveWhyTitle';
  static const String saveWhyDesc = 'saveWhyDesc';
  static const String budgetSmartTitle = 'budgetSmartTitle';
  static const String budgetSmartDesc = 'budgetSmartDesc';
  static const String budgetSelfTitle = 'budgetSelfTitle';
  static const String budgetSelfDesc = 'budgetSelfDesc';

  static const String spendManageTitle = 'spendManageTitle';
  static const String spendManageDesc = 'spendManageDesc';
  static const String spendLandTitle = 'spendLandTitle';
  static const String spendLandDesc = 'spendLandDesc';
  static const String smartSpendingTips = 'smartSpendingTips';

  static const String coachQ1 = 'coachQ1';
  static const String coachQ2 = 'coachQ2';
  static const String coachQ3 = 'coachQ3';
  static const String coachQ4 = 'coachQ4';
  static const String coachQ5 = 'coachQ5';
  static const String coachQ6 = 'coachQ6';
  static const String coachQ7 = 'coachQ7';
  static const String coachQ8 = 'coachQ8';
  static const String coachQ9 = 'coachQ9';
  static const String coachQ10 = 'coachQ10';
  static const String coachQ11 = 'coachQ11';

  static const String coachOptBoth = 'coachOptBoth';
  static const String coachOptSaveBig = 'coachOptSaveBig';
  static const String coachOptTreats = 'coachOptTreats';

  static const String coachPraiseHabit = 'coachPraiseHabit';
  static const String coachRestart = 'coachRestart';

  static const String coachSavingSmall = 'coachSavingSmall';
  static const String coachOnYourWay = 'coachOnYourWay';
  static const String coachPraiseGreat = 'coachPraiseGreat';
  static const String never = 'never';
  static const String sometimes = 'sometimes';
  static const String no = 'no';
  static const String maybe = 'maybe';
  static const String coachAdviceTitle = 'coachAdviceTitle';

  static const String tourBudgetTitle = 'tourBudgetTitle';
  static const String tourBudgetDesc = 'tourBudgetDesc';

  static const String tourChatbotTitle = 'tourChatbotTitle';
  static const String tourChatbotDesc = 'tourChatbotDesc';

  static const String tourDashboardTitle = 'tourDashboardTitle';
  static const String tourDashboardDesc = 'tourDashboardDesc';

  static const String tourExpenseTitle = 'tourExpenseTitle';
  static const String tourExpenseDesc = 'tourExpenseDesc';

  static const String tourLearnHubDesc = 'tourLearnHubDesc';
  static const String tourLearnhubTitle = 'tourLearnhubTitle';
  static const String tourLearnhubDesc = 'tourLearnhubDesc';

  static const String tourReportDesc = 'tourReportDesc';
  static const String tourReportTitle = 'tourReportTitle';

  static const String tourSavingsTitle = 'tourSavingsTitle';
  static const String tourSavingsDesc = 'tourSavingsDesc';

  static const String tourSettingsTitle = 'tourSettingsTitle';
  static const String tourSettingsDesc = 'tourSettingsDesc';

  static const String tourMarkDone = 'tourMarkDone';

  static const String quizTitle = 'quizTitle';
  static const String generalQuizTitle = 'generalQuizTitle';
  static const String quizScore = 'quizScore';
  static const String quizResultScore = 'quizResultScore';
  static const String quizBack = 'quizBack';
  static const String quizReview = 'quizReview';
  static const String quizClearConfirm = 'quizClearConfirm';
  static const String quizNoResults = 'quizNoResults';
  static const String quizResults = 'quizResults';
  static const String quizReset = 'quizReset';
  static const String quizResetConfirm = 'quizResetConfirm';
  static const String reset = 'reset';
  static const String quizQ1 = 'quizQ1';
  static const String quizQ1A1 = 'quizQ1A1';
  static const String quizQ1A2 = 'quizQ1A2';
  static const String quizQ1A3 = 'quizQ1A3';
  static const String quizQ1A4 = 'quizQ1A4';

  static const String quizQ2 = 'quizQ2';
  static const String quizQ2A1 = 'quizQ2A1';
  static const String quizQ2A2 = 'quizQ2A2';
  static const String quizQ2A3 = 'quizQ2A3';
  static const String quizQ2A4 = 'quizQ2A4';

  static const String quizQ3 = 'quizQ3';
  static const String quizQ3A1 = 'quizQ3A1';
  static const String quizQ3A2 = 'quizQ3A2';
  static const String quizQ3A3 = 'quizQ3A3';
  static const String quizQ3A4 = 'quizQ3A4';

  static const String quizQ4 = 'quizQ4';
  static const String quizQ4A1 = 'quizQ4A1';
  static const String quizQ4A2 = 'quizQ4A2';
  static const String quizQ4A3 = 'quizQ4A3';
  static const String quizQ4A4 = 'quizQ4A4';

  static const String quizQ5 = 'quizQ5';
  static const String quizQ5A1 = 'quizQ5A1';
  static const String quizQ5A2 = 'quizQ5A2';
  static const String quizQ5A3 = 'quizQ5A3';
  static const String quizQ5A4 = 'quizQ5A4';

  static const String quizQ6 = 'quizQ6';
  static const String quizQ6A1 = 'quizQ6A1';
  static const String quizQ6A2 = 'quizQ6A2';
  static const String quizQ6A3 = 'quizQ6A3';
  static const String quizQ6A4 = 'quizQ6A4';

  static const String quizQ7 = 'quizQ7';
  static const String quizQ7A1 = 'quizQ7A1';
  static const String quizQ7A2 = 'quizQ7A2';
  static const String quizQ7A3 = 'quizQ7A3';
  static const String quizQ7A4 = 'quizQ7A4';

  static const String quizQ8 = 'quizQ8';
  static const String quizQ8A1 = 'quizQ8A1';
  static const String quizQ8A2 = 'quizQ8A2';
  static const String quizQ8A3 = 'quizQ8A3';
  static const String quizQ8A4 = 'quizQ8A4';

  static const String quizQ9 = 'quizQ9';
  static const String quizQ9A1 = 'quizQ9A1';
  static const String quizQ9A2 = 'quizQ9A2';
  static const String quizQ9A3 = 'quizQ9A3';
  static const String quizQ9A4 = 'quizQ9A4';

  static const String quizQ10 = 'quizQ10';
  static const String quizQ10A1 = 'quizQ10A1';
  static const String quizQ10A2 = 'quizQ10A2';
  static const String quizQ10A3 = 'quizQ10A3';
  static const String quizQ10A4 = 'quizQ10A4';

  static const String quizQ11 = 'quizQ11';
  static const String quizQ11A1 = 'quizQ11A1';
  static const String quizQ11A2 = 'quizQ11A2';
  static const String quizQ11A3 = 'quizQ11A3';
  static const String quizQ11A4 = 'quizQ11A4';

  static const String quizQ12 = 'quizQ12';
  static const String quizQ12A1 = 'quizQ12A1';
  static const String quizQ12A2 = 'quizQ12A2';
  static const String quizQ12A3 = 'quizQ12A3';
  static const String quizQ12A4 = 'quizQ12A4';

  static const String quizQ13 = 'quizQ13';
  static const String quizQ13A1 = 'quizQ13A1';
  static const String quizQ13A2 = 'quizQ13A2';
  static const String quizQ13A3 = 'quizQ13A3';
  static const String quizQ13A4 = 'quizQ13A4';

  static const String quizQ14 = 'quizQ14';
  static const String quizQ14A1 = 'quizQ14A1';
  static const String quizQ14A2 = 'quizQ14A2';
  static const String quizQ14A3 = 'quizQ14A3';
  static const String quizQ14A4 = 'quizQ14A4';

  static const String quizQ15 = 'quizQ15';
  static const String quizQ15A1 = 'quizQ15A1';
  static const String quizQ15A2 = 'quizQ15A2';
  static const String quizQ15A3 = 'quizQ15A3';
  static const String quizQ15A4 = 'quizQ15A4';

  static const String quizQ16 = 'quizQ16';
  static const String quizQ16A1 = 'quizQ16A1';
  static const String quizQ16A2 = 'quizQ16A2';
  static const String quizQ16A3 = 'quizQ16A3';
  static const String quizQ16A4 = 'quizQ16A4';

  static const String quizQ17 = 'quizQ17';
  static const String quizQ17A1 = 'quizQ17A1';
  static const String quizQ17A2 = 'quizQ17A2';
  static const String quizQ17A3 = 'quizQ17A3';
  static const String quizQ17A4 = 'quizQ17A4';

  static const String quizQ18 = 'quizQ18';
  static const String quizQ18A1 = 'quizQ18A1';
  static const String quizQ18A2 = 'quizQ18A2';
  static const String quizQ18A3 = 'quizQ18A3';
  static const String quizQ18A4 = 'quizQ18A4';

  static const String quizQ19 = 'quizQ19';
  static const String quizQ19A1 = 'quizQ19A1';
  static const String quizQ19A2 = 'quizQ19A2';
  static const String quizQ19A3 = 'quizQ19A3';
  static const String quizQ19A4 = 'quizQ19A4';

  static const String quizQ20 = 'quizQ20';
  static const String quizQ20A1 = 'quizQ20A1';
  static const String quizQ20A2 = 'quizQ20A2';
  static const String quizQ20A3 = 'quizQ20A3';
  static const String quizQ20A4 = 'quizQ20A4';

  static const String quizQ21 = 'quizQ21';
  static const String quizQ21A1 = 'quizQ21A1';
  static const String quizQ21A2 = 'quizQ21A2';
  static const String quizQ21A3 = 'quizQ21A3';
  static const String quizQ21A4 = 'quizQ21A4';

  static const String quizQ22 = 'quizQ22';
  static const String quizQ22A1 = 'quizQ22A1';
  static const String quizQ22A2 = 'quizQ22A2';
  static const String quizQ22A3 = 'quizQ22A3';
  static const String quizQ22A4 = 'quizQ22A4';

  static const String quizQ23 = 'quizQ23';
  static const String quizQ23A1 = 'quizQ23A1';
  static const String quizQ23A2 = 'quizQ23A2';
  static const String quizQ23A3 = 'quizQ23A3';
  static const String quizQ23A4 = 'quizQ23A4';

  static const String quizQ24 = 'quizQ24';
  static const String quizQ24A1 = 'quizQ24A1';
  static const String quizQ24A2 = 'quizQ24A2';
  static const String quizQ24A3 = 'quizQ24A3';
  static const String quizQ24A4 = 'quizQ24A4';

  static const String quizQ25 = 'quizQ25';
  static const String quizQ25A1 = 'quizQ25A1';
  static const String quizQ25A2 = 'quizQ25A2';
  static const String quizQ25A3 = 'quizQ25A3';
  static const String quizQ25A4 = 'quizQ25A4';

  static const String quizQ26 = 'quizQ26';
  static const String quizQ26A1 = 'quizQ26A1';
  static const String quizQ26A2 = 'quizQ26A2';
  static const String quizQ26A3 = 'quizQ26A3';
  static const String quizQ26A4 = 'quizQ26A4';

  static const String quizQ27 = 'quizQ27';
  static const String quizQ27A1 = 'quizQ27A1';
  static const String quizQ27A2 = 'quizQ27A2';
  static const String quizQ27A3 = 'quizQ27A3';
  static const String quizQ27A4 = 'quizQ27A4';

  static const String quizQ28 = 'quizQ28';
  static const String quizQ28A1 = 'quizQ28A1';
  static const String quizQ28A2 = 'quizQ28A2';
  static const String quizQ28A3 = 'quizQ28A3';
  static const String quizQ28A4 = 'quizQ28A4';

  static const String quizQ29 = 'quizQ29';
  static const String quizQ29A1 = 'quizQ29A1';
  static const String quizQ29A2 = 'quizQ29A2';
  static const String quizQ29A3 = 'quizQ29A3';
  static const String quizQ29A4 = 'quizQ29A4';

  static const String quizQ30 = 'quizQ30';
  static const String quizQ30A1 = 'quizQ30A1';
  static const String quizQ30A2 = 'quizQ30A2';
  static const String quizQ30A3 = 'quizQ30A3';
  static const String quizQ30A4 = 'quizQ30A4';

  static const String quizLoadError = 'quizLoadError';
  static const String quizResetSuccess = 'quizResetSuccess';
  static const String error = 'error';
  static const String refresh = 'refresh';
  static const String clearAllResults = 'clearAllResults';


  // Dashboard page keys
  static const String failedToLoadDashboardData = 'failedToLoadDashboardData';
  static const String dashboard = 'dashboard';
  // Placeholder keys for child widgets
  static const String balanceCardTitle = 'balanceCardTitle';
  static const String timeRangeSelectorLabel = 'timeRangeSelectorLabel';
  static const String recentTransactionsTitle = 'recentTransactionsTitle';
  static const String addTransactionTitle = 'addTransactionTitle';
  // Navigation tiles
  static const String aiPoweredFeatures = 'aiPoweredFeatures';
  static const String moneyTools = 'moneyTools';
  static const String insights = 'insights';
  static const String goals = 'goals';
  static const String learnFinanceDescription = 'learnFinanceDescription';
  static const String financeAcademy = 'financeAcademy';

  // Robot animation
  static const String thinking = 'thinking';
  // Balance card
  static const String balance = 'balance';
  static const String income = 'income';
  static const String expenses = 'expenses';
  static const String thisMonth = 'thisMonth';
  static const String thisWeek = 'thisWeek';
  static const String thisYear = 'thisYear';
  static const String customRange = 'customRange';
  // time_selector
  static const String selectTimePeriod = 'selectTimePeriod';
  static const String allTime = 'allTime';
  // Chart Service
  static const String mon = 'mon';
  static const String tue = 'tue';
  static const String wed = 'wed';
  static const String thu = 'thu';
  static const String fri = 'fri';
  static const String sat = 'sat';
  static const String sun = 'sun';
  static const String jan = 'jan';
  static const String feb = 'feb';
  static const String mar = 'mar';
  static const String apr = 'apr';
  static const String may = 'may';
  static const String jun = 'jun';
  static const String jul = 'jul';
  static const String aug = 'aug';
  static const String sep = 'sep';
  static const String oct = 'oct';
  static const String nov = 'nov';
  static const String dec = 'dec';
  // insight
  static const String spendingAnalysis = 'spendingAnalysis';
  static const String categoryBreakdown = 'categoryBreakdown';
  static const String expenseAnalysis = 'expenseAnalysis';
  static const String incomeAnalysis = 'incomeAnalysis';
  // recent transaction
  static const String transactions = 'transactions';
  static const String selectItemsToDelete = 'selectItemsToDelete';
  static const String noTransactionsInThisPeriod = 'noTransactionsInThisPeriod';
  static const String seeAll = 'seeAll';
  static const String deleteTransactions = 'deleteTransactions';
  static const String confirmDeleteTransactions = 'confirmDeleteTransactions';
  static const String delete = 'delete';
  // all transactions
  static const String confirmDeleteAction = 'confirmDeleteAction';
  static const String errorLoadingTransactions = 'errorLoadingTransactions';
  // delete transaction
  static const String deleteTransaction = 'deleteTransaction';
  static const String confirmDeleteSingleTransaction =
      'confirmDeleteSingleTransaction';
  // goal card
  static const String savedAmount = 'savedAmount';
  static const String targetAmount = 'targetAmount';
  static const String percentCompleted = 'percentCompleted';
  static const String targetDate = 'targetDate';
  static const String daysLeft = 'daysLeft';
  static const String daysOverdue = 'daysOverdue';
  static const String addSavings = 'addSavings';
  static const String addToSavings = 'addToSavings';
  static const String amount = 'amount';
  static const String pleaseEnterAmount = 'pleaseEnterAmount';
  static const String pleaseEnterValidNumber = 'pleaseEnterValidNumber';
  static const String amountMustBePositive = 'amountMustBePositive';
  static const String amountExceedsTarget = 'amountExceedsTarget';
  static const String add = 'add';
  static const String deleteGoal = 'deleteGoal';
  static const String confirmDeleteGoal = 'confirmDeleteGoal';
  // add edit goal
  static const String addSavingGoal = 'addSavingGoal';
  static const String editSavingGoal = 'editSavingGoal';
  static const String savingGoalPurpose = 'savingGoalPurpose';
  static const String savingGoalHint = 'savingGoalHint';
  static const String description = 'description';
  static const String descriptionHint = 'descriptionHint';
  static const String amountHint = 'amountHint';
  static const String pleaseEnterPositiveAmount = 'pleaseEnterPositiveAmount';
  static const String pleaseEnterSavingGoalName = 'pleaseEnterSavingGoalName';
  static const String saveGoal = 'saveGoal';
  static const String goalCreated = 'goalCreated';
  static const String goalUpdated = 'goalUpdated';
  static const String errorSavingGoal = 'errorSavingGoal';
  // saving goal page
  static const String mySavingGoals = 'mySavingGoals';
  static const String newGoal = 'newGoal';
  static const String loadingGoals = 'loadingGoals';
  static const String noSavingGoals = 'noSavingGoals';
  static const String createFirstGoal = 'createFirstGoal';
  static const String totalSavingsProgress = 'totalSavingsProgress';
  static const String percentComplete = 'percentComplete';
  static const String savingsOfTarget = 'savingsOfTarget';
  static const String deleteGoalQuestion = 'deleteGoalQuestion';
  static const String confirmDeleteGoalPermanent = 'confirmDeleteGoalPermanent';
  static const String addedToSavings = 'addedToSavings';
  static const String goalDeleted = 'goalDeleted';
  static const String goalWasDeleted = 'goalWasDeleted';
  static const String amountGreaterThanZero = 'amountGreaterThanZero';
  static const String couldNotAddSavings = 'couldNotAddSavings';
  static const String couldNotDeleteGoal = 'couldNotDeleteGoal';
  static const String goalsRefreshed = 'goalsRefreshed';
  static const String aboutSavingGoals = 'aboutSavingGoals';
  static const String trackProgress = 'trackProgress';
  static const String trackProgressDescription = 'trackProgressDescription';
  static const String addMoneyAnytime = 'addMoneyAnytime';
  static const String addMoneyAnytimeDescription = 'addMoneyAnytimeDescription';
  static const String setTargetDates = 'setTargetDates';
  static const String setTargetDatesDescription = 'setTargetDatesDescription';
  static const String gotIt = 'gotIt';
  static const String savingsAddedSuccessfully = 'savingsAddedSuccessfully';
  static const String insufficientBalance = 'insufficientBalance';
  static const String errorAddingSavings = 'errorAddingSavings';
  // add income
  static const String addExpense = 'addExpense';
  static const String editExpense = 'editExpense';
  static const String addIncome = 'addIncome';
  static const String editIncome = 'editIncome';
  // base adding
  static const String category = 'category';
  static const String date = 'date';
  static const String pleaseEnterValidAmount = 'pleaseEnterValidAmount';
  static const String pleaseSelectCategory = 'pleaseSelectCategory';
  static const String transactionSaved = 'transactionSaved';
  static const String transactionUpdated = 'transactionUpdated';
  static const String failedToSaveTransaction = 'failedToSaveTransaction';
  // expense or income
  static const String addNew = 'addNew';
  static const String expense = 'expense';
  static const String saving = 'saving';
  static const String savings = 'savings';
  // transaction item
  static const String noTransactionsYet = 'noTransactionsYet';
  static const String today = 'today';
  static const String yesterday = 'yesterday';
  // Category keys
  static const String food = 'food';
  static const String transport = 'transport';
  static const String utilities = 'utilities';
  static const String entertainment = 'entertainment';
  static const String shopping = 'shopping';
  static const String health = 'health';
  static const String others = 'others';
  static const String salary = 'salary';
  static const String investment = 'investment';
  static const String business = 'business';
  static const String gift = 'gift';
  static const String simpleBudgeting = 'simpleBudgeting';
  // Dashboard help
  static const String dashboardHelpTitle = 'dashboardHelpTitle';
  static const String dashboardHelpSubtitle = 'dashboardHelpSubtitle';
  static const String dashboardHelpBalance = 'dashboardHelpBalance';
  static const String dashboardHelpAddTransaction =
      'dashboardHelpAddTransaction';
  static const String dashboardHelpDeleteTransaction =
      'dashboardHelpDeleteTransaction';
  static const String dashboardHelpSpendingPatterns =
      'dashboardHelpSpendingPatterns';
  static const String dashboardHelpRefresh = 'dashboardHelpRefresh';
  //pie chart
  static const String total = 'total';
  static const String noExpenseData = 'noExpenseData';
  static const String noIncomeData = 'noIncomeData';
  //bar chart
  static const String pagination = 'pagination';
  // chart query
  static const String hideAssistant = 'hideAssistant';
  static const String askAboutChart = 'askAboutChart';
  static const String askAboutChartHint = 'askAboutChartHint';
  static const String assistant = 'assistant';
  static const String queryError = 'queryError';
  static const String queryErrorWithMessage = 'queryErrorWithMessage';
  static const String chartContext = 'chartContext';
  static const String queryPrompt = 'queryPrompt';
  // advanced quiz
  static const String quizCompleted = 'quiz_completed';
  static const String quizFinish = 'quiz_finish';
  static const String quizTryAgain = 'quiz_try_again';
  static const String quizQuestion1 = 'quiz_question_1';
  static const String quizQuestion1Answer1 = 'quiz_question_1_answer_1';
  static const String quizQuestion1Answer2 = 'quiz_question_1_answer_2';
  static const String quizQuestion1Answer3 = 'quiz_question_1_answer_3';
  static const String quizQuestion2 = 'quiz_question_2';
  static const String quizQuestion2Answer1 = 'quiz_question_2_answer_1';
  static const String quizQuestion2Answer2 = 'quiz_question_2_answer_2';
  static const String quizQuestion2Answer3 = 'quiz_question_2_answer_3';
  static const String quizQuestion3 = 'quiz_question_3';
  static const String quizQuestion3Answer1 = 'quiz_question_3_answer_1';
  static const String quizQuestion3Answer2 = 'quiz_question_3_answer_2';
  static const String quizQuestion3Answer3 = 'quiz_question_3_answer_3';
  static const String quizQuestion4 = 'quiz_question_4';
  static const String quizQuestion4Answer1 = 'quiz_question_4_answer_1';
  static const String quizQuestion4Answer2 = 'quiz_question_4_answer_2';
  static const String quizQuestion4Answer3 = 'quiz_question_4_answer_3';
  static const String quizQuestion5 = 'quiz_question_5';
  static const String quizQuestion5Answer1 = 'quiz_question_5_answer_1';
  static const String quizQuestion5Answer2 = 'quiz_question_5_answer_2';
  static const String quizQuestion5Answer3 = 'quiz_question_5_answer_3';
  //advance quiz screen
  static const String advancedScreenTitle = 'advanced_screen_title';
  static const String investmentBasicsTitle = 'investment_basics_title';
  static const String investmentBasicsPoint1 = 'investment_basics_point_1';
  static const String investmentBasicsPoint2 = 'investment_basics_point_2';
  static const String investmentBasicsPoint3 = 'investment_basics_point_3';
  static const String retirementPlanningTitle = 'retirement_planning_title';
  static const String retirementPlanningPoint1 = 'retirement_planning_point_1';
  static const String retirementPlanningPoint2 = 'retirement_planning_point_2';
  static const String retirementPlanningPoint3 = 'retirement_planning_point_3';
  static const String insuranceProtectionTitle = 'insurance_protection_title';
  static const String insuranceProtectionPoint1 =
      'insurance_protection_point_1';
  static const String insuranceProtectionPoint2 =
      'insurance_protection_point_2';
  static const String insuranceProtectionPoint3 =
      'insurance_protection_point_3';
  static const String takeAdvancedQuiz = 'take_advanced_quiz';
  //beginer quiz
  static const String beginnerQuizTitle = 'beginner_quiz_title';
  static const String beginnerQuizQuestion1 = 'beginner_quiz_question_1';
  static const String beginnerQuizQuestion1Answer1 =
      'beginner_quiz_question_1_answer_1';
  static const String beginnerQuizQuestion1Answer2 =
      'beginner_quiz_question_1_answer_2';
  static const String beginnerQuizQuestion1Answer3 =
      'beginner_quiz_question_1_answer_3';
  static const String beginnerQuizQuestion2 = 'beginner_quiz_question_2';
  static const String beginnerQuizQuestion2Answer1 =
      'beginner_quiz_question_2_answer_1';
  static const String beginnerQuizQuestion2Answer2 =
      'beginner_quiz_question_2_answer_2';
  static const String beginnerQuizQuestion2Answer3 =
      'beginner_quiz_question_2_answer_3';
  static const String beginnerQuizQuestion3 = 'beginner_quiz_question_3';
  static const String beginnerQuizQuestion3Answer1 =
      'beginner_quiz_question_3_answer_1';
  static const String beginnerQuizQuestion3Answer2 =
      'beginner_quiz_question_3_answer_2';
  static const String beginnerQuizQuestion3Answer3 =
      'beginner_quiz_question_3_answer_3';
  //beginer screen
  static const String beginnerScreenTitle = 'beginner_screen_title';
  static const String understandingMoneyTitle = 'understanding_money_title';
  static const String understandingMoneyPoint1 = 'understanding_money_point_1';
  static const String understandingMoneyPoint2 = 'understanding_money_point_2';
  static const String understandingMoneyPoint3 = 'understanding_money_point_3';
  static const String simpleBudgetingTitle = 'simple_budgeting_title';
  static const String simpleBudgetingPoint1 = 'simple_budgeting_point_1';
  static const String simpleBudgetingPoint2 = 'simple_budgeting_point_2';
  static const String simpleBudgetingPoint3 = 'simple_budgeting_point_3';
  static const String bankAccountsTitle = 'bank_accounts_title';
  static const String bankAccountsPoint1 = 'bank_accounts_point_1';
  static const String bankAccountsPoint2 = 'bank_accounts_point_2';
  static const String bankAccountsPoint3 = 'bank_accounts_point_3';
  static const String takeBeginnerQuiz = 'take_beginner_quiz';
  static const String resourceError = 'resource_error';
  //Intermedia quiz
  static const String intermediateQuizTitle = 'intermediate_quiz_title';
  static const String advancedQuizTitle = 'advancedQuizTitle';
  static const String intermediateQuizQuestion1 =
      'intermediate_quiz_question_1';
  static const String intermediateQuizQuestion1Answer1 =
      'intermediate_quiz_question_1_answer_1';
  static const String intermediateQuizQuestion1Answer2 =
      'intermediate_quiz_question_1_answer_2';
  static const String intermediateQuizQuestion1Answer3 =
      'intermediate_quiz_question_1_answer_3';
  static const String intermediateQuizQuestion2 =
      'intermediate_quiz_question_2';
  static const String intermediateQuizQuestion2Answer1 =
      'intermediate_quiz_question_2_answer_1';
  static const String intermediateQuizQuestion2Answer2 =
      'intermediate_quiz_question_2_answer_2';
  static const String intermediateQuizQuestion2Answer3 =
      'intermediate_quiz_question_2_answer_3';
  static const String intermediateQuizQuestion3 =
      'intermediate_quiz_question_3';
  static const String intermediateQuizQuestion3Answer1 =
      'intermediate_quiz_question_3_answer_1';
  static const String intermediateQuizQuestion3Answer2 =
      'intermediate_quiz_question_3_answer_2';
  static const String intermediateQuizQuestion3Answer3 =
      'intermediate_quiz_question_3_answer_3';
  static const String intermediateQuizQuestion4 =
      'intermediate_quiz_question_4';
  static const String intermediateQuizQuestion4Answer1 =
      'intermediate_quiz_question_4_answer_1';
  static const String intermediateQuizQuestion4Answer2 =
      'intermediate_quiz_question_4_answer_2';
  static const String intermediateQuizQuestion4Answer3 =
      'intermediate_quiz_question_4_answer_3';
  //intermeadia screen
  static const String intermediateScreenTitle = 'intermediate_screen_title';
  static const String advancedBudgetingTitle = 'advanced_budgeting_title';
  static const String advancedBudgetingPoint1 = 'advanced_budgeting_point_1';
  static const String advancedBudgetingPoint2 = 'advanced_budgeting_point_2';
  static const String advancedBudgetingPoint3 = 'advanced_budgeting_point_3';
  static const String creditBasicsTitle = 'credit_basics_title';
  static const String creditBasicsPoint1 = 'credit_basics_point_1';
  static const String creditBasicsPoint2 = 'credit_basics_point_2';
  static const String creditBasicsPoint3 = 'credit_basics_point_3';
  static const String savingStrategiesTitle = 'saving_strategies_title';
  static const String savingStrategiesPoint1 = 'saving_strategies_point_1';
  static const String savingStrategiesPoint2 = 'saving_strategies_point_2';
  static const String savingStrategiesPoint3 = 'saving_strategies_point_3';
  static const String takeIntermediateQuiz = 'take_intermediate_quiz';
  static const String quizHomeTitle = 'quiz_home_title';
  static const String beginnerLevelQuiz = 'beginner_level_quiz';
  static const String intermediateLevelQuiz = 'intermediate_level_quiz';
  static const String advancedLevelQuiz = 'advanced_level_quiz';
  // New Chatbot keys
  static const String transactionAddedSuccess = 'transaction_added_success';
  static const String transactionCanceled = 'transaction_canceled';
  static const String transactionAddError = 'transaction_add_error';
  static const String transactionConfirmPrompt = 'transaction_confirm_prompt';
  static const String transactionNoPending = 'transaction_no_pending';
  // New ChatbotHelp keys
  static const String chatbotHelpTitle = 'chatbot_help_title';
  static const String chatbotHelpSubtitle = 'chatbot_help_subtitle';
  static const String chatbotHelpInstruction1 = 'chatbot_help_instruction_1';
  static const String chatbotHelpInstruction2 = 'chatbot_help_instruction_2';
  static const String chatbotHelpInstruction3 = 'chatbot_help_instruction_3';
  static const String chatbotHelpInstruction4 = 'chatbot_help_instruction_4';
  // New WelcomeScreen keys
  static const String welcomeTryAsking = 'welcome_try_asking';
  static const String welcomeWriteQuestion = 'welcome_write_question';
  // New VoiceChatInterface keys
  static const String voiceListening = 'voice_listening';
  static const String voiceProcessing = 'voice_processing';
  static const String voiceTapMic = 'voice_tap_mic';
  static const String voiceSttNotAvailable = 'voice_stt_not_available';
  // New TransactionPreviewPopup keys
  static const String transactionPreviewTitle = 'transaction_preview_title';
  static const String transactionPreviewCancel = 'transaction_preview_cancel';
  static const String transactionPreviewConfirm = 'transaction_preview_confirm';
  // New ChatInterface keys
  static const String chatInputHint = 'chat_input_hint';
  // New ChatConstants non-financial response keys
  static const String nonFinancialQuestion = 'non_financial_question';
  static const String nonFinancialImage = 'non_financial_image';
  static const String expenseTracking = 'expenseTracking';
  static const String categorySpentAmount = 'categorySpentAmount';
  static const String categoryEarnedAmount = 'categoryEarnedAmount';
  static const String backToQuiz = 'backToQuiz';
  static const String reviewAnswers = 'reviewAnswers';
  // ForgotPasswordPage keys
  static const String forgotPasswordTitle = 'forgot_password_title';
  static const String emailHint = 'email_hint';
  static const String sendResetLink = 'send_reset_link';
  static const String backToLogin = 'back_to_login';
  static const String passwordResetSuccess = 'password_reset_success';
  static const String passwordResetError = 'password_reset_error';
  static const String dialogOk = 'dialog_ok';
  // LoginPage keys
  static const String loginTitle = 'login_title';
  static const String passwordHint = 'password_hint';
  static const String forgotPassword = 'forgot_password';
  static const String signInButton = 'sign_in_button';
  static const String continueWith = 'continue_with';
  static const String notMember = 'not_member';
  static const String registerNow = 'register_now';
  static const String loginError = 'login_error';
  static const String userNotFoundError = 'user_not_found_error';
  // RegisterPage keys
  static const String registerTitle = 'register_title';
  static const String confirmPasswordHint = 'confirm_password_hint';
  static const String signUpButton = 'sign_up_button';
  static const String alreadyMember = 'already_member';
  static const String loginNow = 'login_now';
  static const String passwordStrong = 'password_strong';
  static const String passwordWeak = 'password_weak';
  static const String invalidGmailError = 'invalid_gmail_error';
  static const String passwordsNotMatchError = 'passwords_not_match_error';
  static const String weakPasswordError = 'weak_password_error';
  static const String hiveStorageError = 'hive_storage_error';
  static const String selectLanguage = 'select_language';
  static const String report = 'report';
  static const String savingGoals = 'savingGoals';
  static const String quiz = 'quiz';
  static const String quizAttempts = 'quizAttempts';
  static const String quizAverage = 'quizAverage';
  static const String quizLastAttempt = 'quizLastAttempt';
  static const String learningReset = 'learningReset';
  static const String learningHub = 'learningHub';
  static const String ongoing = 'ongoing';
  static const String completed = 'completed';
  static const String noResultsFound = 'noResultsFound';
  static const String savingMoneyEasy = 'savingMoneyEasy';
  //Learn AppTour
  static const String searchTextfiedText = "Search for topics..";
  static const String apptourDashSubtitle = "Explore the main overview";
  static const String expenseTrackingSubtite = "Track your daily spending";
  static const String savingGoalheading = "Setting Up Saving Goals";
  static const String savingGoalSubheading = "Set and smash goals";
  static const String savingGoalSubtitled =
      "Learn how to set, track, and achieve your personal savings goals using the app’s built-in features.";

  static const String learnHub = "LearnHub";
  static const String learnHubSubtitle = "Central learning area";
  static const String tourBudgetSubTitle = "Stay within budget";
  static const String tourCahtBotSubtite = "Your friendly guide";
  static const String tourReportSubtite = "See the full picture";
  static const String settingSubHeading = "Adjust preferences";

  static const String lessons = 'Lessons';
  static const String appTour = 'App Tour';
  static const String progress = 'Progress';
  static const String smartSpendingTipsSubtitle = 'Spend smarter, live better';
  static const String simpleBudgetingSubtitle = 'Plan with ease';
  static const String savingMoneyEasySubtitle = 'Build your future';
  static const String savingsCoach = 'Savings Coach';
  static const String savingsCoachSubtitle = 'Cut costs, not dreams';
  static const String taketheQuiz = 'Take the Quiz';
  static const String taketheQuizSubtitle = 'Test your knowledge';
  static const String viewQuizResult = 'View Quiz Result';
  static const String quizResultSubtitle = 'See your scores';
  //Smart spending tips videos screen
  static const String spendingVideo1Title =
      'Manage, Grow, Invest & Protect Money';
  static const String spendingVideo1Subtitle =
      'No matter how much you earn, if you manage it well, grow it, invest it, and protect it, your future will be secure.';
  static const String spendingVideo2Title = 'Smart Investment: Buy Land';
  static const String spendingVideo2Subtitle =
      "Land is a safe and profitable investment. Check papers and location before you buy. It’s more flexible than flats or crypto.";

  static const String simpleBudgetingvideo1Title =
      'Smart Monthly Income Allocation';
  static const String simpleBudgetingvideo1Subtitle =
      'Spend 55% on needs, 10% on long-term investments, 10% for future goals, 10% to improve your skills, and 15% for fun or charity.';
  static const String simpleBudgetingvideo2Title =
      "Investing in Yourself Pays Off Most";
  static const String simpleBudgetingvideo2Subtitle =
      'Instead of starting a business with 10,000 Taka, improve your skills. Read books, take online courses, and find ways to earn using your knowledge.';
  static const String savingMoneyVideo1Title = 'Making Saving a Habit';
  static const String savingMoneyVideo1Subtitle =
      "It’s smart to save money regularly and turn it into a habit. The best way is to plan your savings before you spend.";
  static const String savingMoneyVideo2Title = 'Why Saving Is Important';
  static const String savingMoneyVideo2Subtitle =
      "Saving money for emergencies is super important. If you keep some money aside as soon as you get paid, your future will feel more secure.";

  //Saving Coach

  static const String coachOptMoneyBoss = 'coachOptMoneyBoss';
  static const String coachOptDoingOkay = 'coachOptDoingOkay';
  static const String coachOptNeedsWork = 'coachOptNeedsWork';
  static const String coachOpt0_200 = 'coachOpt0_200';
  static const String coachOpt200_500 = 'coachOpt200_500';
  static const String coachOpt500plus = 'coachOpt500plus';
  static const String coachOpt0_1000 = 'coachOpt0_1000';
  static const String coachOpt1000_2000 = 'coachOpt1000_2000';
  static const String coachOpt2000plus = 'coachOpt2000plus';
  static const String coachOpt100 = 'coachOpt100';
  static const String coachOpt500 = 'coachOpt500';
  static const String coachOpt1000plus = 'coachOpt1000plus';
  static const String coachOptAlways = 'coachOptAlways';
  static const String coachOptSometimes = 'coachOptSometimes';
  static const String coachOptNotReally = 'coachOptNotReally';
  static const String coachOptFood = 'coachOptFood';
  static const String coachOptShopping = 'coachOptShopping';
  static const String coachOptEntertainment = 'coachOptEntertainment';
  static const String coachOptNever = 'coachOptNever';
  static const String coachOptYes = 'coachOptYes';
  static const String coachOptMaybe = 'coachOptMaybe';
  static const String coachOptNo = 'coachOptNo';
  static const String coachOptRarely = 'coachOptRarely';
  static const String coachOptSaveIt = 'coachOptSaveIt';
  static const String coachOptSpendIt = 'coachOptSpendIt';

  static const String coachOptNotSure = 'coachOptNotSure';
  static const String coachOtherHint = 'coachOtherHint';
  static const String coachSeeResult = 'coachSeeResult';
  static const String coachNext = 'coachNext';
  static const String coachSavingPlan = 'coachSavingPlan';
  static const String restartQuiz = "Restart Quiz";
  static const String feedbackMessageExcellent =
      "🎉 Excellent! You’re a money master!";
  static const String feedbackMessageGood =
      "👍 Good job! You’re on the right path!";
  static const String feedbackMessageNotBad =
      "🧠 Not bad! A little more learning will go a long way.";
  static const String feedbackMessageKeepGoing =
      "📘 Keep going! Review the Learn section and try again.";

  static const String score = "score";
  static const String accuracy = "Accuracy";
  static const String highScore = "🏅 Highest Score";

  static const String coachSpendingHigh = "coachSpendingHigh";
  static const String coachSpendingMedium = "coachSpendingMedium";
  static const String coachSpendingHealthy = "coachSpendingHealthy";
  static const String coachTrackStart = "coachTrackStart";
  static const String coachTrackMore = "coachTrackMore";
  static const String coachAdjustNo = "coachAdjustNo";
  static const String coachAdjustMaybe = "coachAdjustMaybe";
  static const String coachAdjustYes = "coachAdjustYes";
  static const String greatJob = "🏆 Great Job!";
  static const String goodEffort = "👍 Good Effort";
  static const String tryAgain = "🔄 Try Again";
  //**************************************************************************** */
  static const Map<String, String> en = {
    greatJob: "🏆 Great Job!",
    goodEffort: "👍 Good Effort",
    tryAgain: "🔄 Try Again",
    coachSpendingHigh:
    "But your spending is high. Try cutting at least \$150 from your %s.\n",
    coachSpendingMedium: "There is still room to trim about \$100 from %s.\n",
    coachSpendingHealthy: "Spending looks healthy. Keep it up!\n",
    coachTrackStart:
    "Start tracking where your money goes. It will surprise you!\n",
    coachTrackMore:
    "Tracking a little more seriously could reveal hidden leaks.\n",
    coachAdjustNo:
    "Even tiny changes like skipping one takeaway meal a week can save \$100+ a month.\n",
    coachAdjustMaybe:
    "Try testing small adjustments. You might love the results!\n",
    coachAdjustYes:
    "You are ready to smash your savings goals. Time to go all in!\n",
    score: "score",
    accuracy: "Accuracy",
    highScore: "🏅 Highest Score",
    feedbackMessageNotBad:
    "🧠 Not bad! A little more learning will go a long way.",
    feedbackMessageKeepGoing:
    "📘 Keep going! Review the Learn section and try again.",
    feedbackMessageGood: "👍 Good job! You’re on the right path!",
    feedbackMessageExcellent: "🎉 Excellent! You’re a money master!",

    restartQuiz: "Restart Quiz",
    savingMoneyVideo1Title: 'Making Saving a Habit',
    savingMoneyVideo1Subtitle:
    "It’s smart to save money regularly and turn it into a habit. The best way is to plan your savings before you spend.",
    savingMoneyVideo2Title: 'Why Saving Is Important',
    savingMoneyVideo2Subtitle:
    "Saving money for emergencies is super important. If you keep some money aside as soon as you get paid, your future will feel more secure.",
    simpleBudgetingvideo1Title: 'Smart Monthly Income Allocation',
    simpleBudgetingvideo1Subtitle:
    'Spend 55% on needs, 10% on long-term investments, 10% for future goals, 10% to improve your skills, and 15% for fun or charity.',
    simpleBudgetingvideo2Title: "Investing in Yourself Pays Off Most",
    simpleBudgetingvideo2Subtitle:
    'Instead of starting a business with 10,000 Taka, improve your skills. Read books, take online courses, and find ways to earn using your knowledge.',
    spendingVideo2Title: "Smart Investment: Buy Land",
    spendingVideo2Subtitle:
    "Land is a safe and profitable investment. Check papers and location before you buy. It’s more flexible than flats or crypto.",
    spendingVideo1Subtitle:
    "No matter how much you earn, if you manage it well, grow it, invest it, and protect it, your future will be secure.",
    spendingVideo1Title: "Manage, Grow, Invest & Protect Money",
    apptourDashSubtitle: "Explore the main overview",
    searchTextfiedText: "Search for topics..",
    expenseTrackingSubtite: "Track your daily spending",
    savingGoalheading: "Setting Up Saving Goals",
    savingGoalSubheading: "Set and smash goals",
    savingGoalSubtitled:
    "Learn how to set, track, and achieve your personal savings goals using the app’s built-in features.",
    learnHub: "LearnHub",
    learnHubSubtitle: "Central learning area",
    tourBudgetSubTitle: "Stay within budget",
    tourCahtBotSubtite: "Your friendly guide",
    tourReportSubtite: "See the full picture",
    settingSubHeading: "Adjust preferences",
    smartSpendingTips: 'Smart Spending Tips',
    appTitle: 'Finney',
    settings: 'Settings',
    viewProfile: 'View Profile',
    profileInformation: 'Profile Information',
    fullName: 'Full Name',
    phoneNumber: 'Phone Number',
    address: 'Address',
    email: 'Email',
    userId: 'User ID',
    edit: 'Edit',
    save: 'Save',
    close: 'Close',
    appearance: 'Appearance',
    language: 'Language',
    languageEnglish: 'English',
    languageBengali: 'Bengali',
    currency: 'Currency',
    currencyBDT: 'Bangladeshi Taka (৳)',
    currencyAUD: 'Australian Dollar (AUD)',
    textSize: 'Text Size',
    management: 'Management',
    security: 'Security',
    setPin: 'Set PIN',
    enterPin: 'Enter 4-digit PIN',
    confirmPin: 'Confirm 4-digit PIN',
    pinSaved: 'PIN saved!',
    invalidPin: 'Please enter a 4-digit PIN',
    pinsDoNotMatch: 'Pins do not match',
    cancel: 'Cancel',
    helpSupport: 'Help & Support',
    helpSupportComingSoon: 'Help & Support page coming soon!',
    logOut: 'Log Out',
    signedOut: 'Successfully signed out',
    errorLoadingData: 'Failed to load user data',
    errorSavingData: 'Failed to save user data',
    user: 'User',
    notAvailable: 'Not available',
    financialBasics: 'Financial Basics',
    askFinneyAI: 'Ask Finney AI for any help',
    moneyManagement: 'Money Management',
    moneyManagementSubtitle: 'Track, plan, and control your money',
    savingBudgeting: 'Saving & Budgeting',
    savingBudgetingSubtitle: 'Learn how to save and budget smartly',
    investingFundamentals: 'Investing Fundamentals',
    investingFundamentalsSubtitle: 'Understand how to grow your money',
    financialSafety: 'Financial Safety',
    financialSafetySubtitle: 'Stay secure and avoid scams',
    keyPoints: 'Key Points',
    learnMore: 'Learn More',
    backToTopics: 'Back to Topics',
    aiAssistant: 'AI Assistant',
    moneyManagementPoint1: 'Track income and expenses regularly',
    moneyManagementPoint2: 'Differentiate between needs and wants',
    moneyManagementPoint3: 'Understand basic banking services',
    moneyManagementPoint4: 'Maintain a simple financial record',
    savingBudgetingPoint1: 'Follow the 50-30-20 rule (Needs-Wants-Savings)',
    savingBudgetingPoint2: 'Build an emergency fund (3-6 months expenses)',
    savingBudgetingPoint3: 'Automate your savings',
    savingBudgetingPoint4: 'Review and adjust budget monthly',
    investingFundamentalsPoint1: 'Understand risk and return',
    investingFundamentalsPoint2: 'Diversify your investments',
    investingFundamentalsPoint3: 'Learn about stocks, bonds, and mutual funds',
    investingFundamentalsPoint4:
    'Start with small investments and grow gradually',
    financialSafetyPoint1: 'Recognize and avoid financial scams',
    financialSafetyPoint2: 'Understand the importance of insurance',
    financialSafetyPoint3: 'Secure your online financial accounts',
    financialSafetyPoint4: 'Learn about identity theft protection',
    resourceMoneyManagementVideo: 'Basic Money Management',
    resourceMoneyManagementArticle1: 'Investopedia: Personal Finance Basics',
    resourceMoneyManagementArticle2:
    'Investopedia: Ultimate Guide to Financial Literacy',
    resourceSavingVideo: 'Budgeting for Beginners; Learn 50-30-20 Rule',
    resourceSavingArticle: 'NerdWallet: How to Budget Money',
    resourceInvestingVideo: 'Investing basics by Professor Dave',
    resourceInvestingArticle: 'Investopedia: Investing Basics',
    resourceSafetyVideo1: 'Financial Safety Tips for Mobile Banking',
    resourceSafetyVideo2: 'Guide to Financial Security',
    resourceSafetyArticle1: 'Investopedia: Financial Security Tips',
    resourceSafetyArticle2: 'MoneySmart: Protect Yourself from Scams',
    chatbotTitle: 'Finney AI',
    chatbotHelp: 'Help',
    chatbotClearChat: 'Clear Chat',
    welcomeMessage: 'Welcome to Finney AI! How can I assist you today?',
    suggestedQuestion1: 'What is budgeting?',
    suggestedQuestion2: 'How can I save money effectively?',
    suggestedQuestion3: 'What are the basics of investing?',
    chatbotsuggestedQuestion1: "Summatize my spending for this month",
    chatbotsuggestedQuestion2: 'What is my highest spending category?',
    chatbotsuggestedQuestion3: 'Tips for reducing my daily expenses',
    financialLearning: 'Financial Learning',
    beginner: 'Beginner',
    beginnerSubtitle: 'Learn basic money skills',
    intermediate: 'Intermediate',
    intermediateSubtitle: 'Build better financial habits',
    advanced: 'Advanced',
    advancedSubtitle: 'Grow your wealth',
    testYourKnowledge: 'Test Your Knowledge',
    testYourKnowledgeSubtitle: 'Take a quiz to check your understanding',
    failedToLoadDashboardData: 'Failed to load dashboard data',
    balanceCardTitle: 'Balance Overview',
    timeRangeSelectorLabel: 'Select Time Range',
    recentTransactionsTitle: 'Recent Transactions',
    addTransactionTitle: 'Add Transaction',
    aiPoweredFeatures: 'AI-Powered Features',
    moneyTools: 'Money Tools',
    insights: 'Insights',
    goals: 'Goals',
    thinking: 'Thinking...',
    balance: 'Balance',
    'financeAcademy': 'Finance Academy',
    income: 'Income',
    expenses: 'Expenses',
    expense: 'Expense',
    thisMonth: 'This Month',
    thisWeek: 'This Week',
    thisYear: 'This Year',
    customRange: 'Custom Range',
    selectTimePeriod: 'Select Time Period',
    allTime: 'All Time',
    mon: 'Mon',
    tue: 'Tue',
    wed: 'Wed',
    thu: 'Thu',
    fri: 'Fri',
    sat: 'Sat',
    sun: 'Sun',
    jan: 'Jan',
    feb: 'Feb',
    mar: 'Mar',
    apr: 'Apr',
    may: 'May',
    jun: 'Jun',
    jul: 'Jul',
    aug: 'Aug',
    sep: 'Sep',
    oct: 'Oct',
    nov: 'Nov',
    dec: 'Dec',
    spendingAnalysis: 'Spending Analysis',
    categoryBreakdown: 'Category Breakdown',
    expenseAnalysis: 'Expense Analysis',
    incomeAnalysis: 'Income Analysis',
    transactions: 'Transactions',
    selectItemsToDelete: 'Select Items to Delete',
    noTransactionsInThisPeriod: 'No transactions in this period',
    seeAll: 'See All',
    deleteTransactions: 'Delete Transactions',
    confirmDeleteTransactions:
    'Are you sure you want to delete %d transaction(s)?',
    delete: 'Delete',
    errorLoadingTransactions: 'Error loading transactions',
    confirmDeleteAction:
    'This action cannot be undone. Are you sure you want to delete %d transaction(s)?',
    deleteTransaction: 'Delete Transaction',
    confirmDeleteSingleTransaction:
    'This action cannot be undone. Are you sure you want to delete this transaction?',
    savedAmount: 'Saved: %s',
    targetAmount: 'Target: %s',
    percentCompleted: '%s% completed',
    targetDate: 'Target date: %s',
    daysLeft: '%d days left',
    daysOverdue: '%d days overdue',
    addSavings: 'Add Savings',
    addToSavings: 'Add to Savings',
    amount: 'Amount',
    savings: 'Saving',
    pleaseEnterAmount: 'Please enter an amount',
    pleaseEnterValidNumber: 'Please enter a valid number',
    amountMustBePositive: 'Amount must be positive',
    amountExceedsTarget:
    'Amount exceeds remaining target of %s. Please enter a smaller amount.',
    add: 'Add',
    deleteGoal: 'Delete Goal',
    confirmDeleteGoal: 'Are you sure you want to delete "%s"?',
    addSavingGoal: 'Add Saving Goal',
    editSavingGoal: 'Edit Saving Goal',
    savingGoalPurpose: 'Saving Goal Purpose',
    savingGoalHint: 'e.g. Saving for new Car...',
    description: 'Description',
    descriptionHint: 'Enter description (optional)',
    amountHint: '0.00',
    pleaseEnterPositiveAmount: 'Please enter a positive amount',
    pleaseEnterSavingGoalName: 'Please enter a saving goal name',
    saveGoal: 'Save Goal',
    goalCreated: 'Goal "%s" created!',
    goalUpdated: 'Goal "%s" updated!',
    errorSavingGoal: 'Error saving goal. Please try again.',
    mySavingGoals: 'My Saving Goals',
    newGoal: 'New Goal',
    loadingGoals: 'Loading your goals...',
    noSavingGoals: 'No saving goals yet',
    createFirstGoal: 'Create Your First Goal',
    totalSavingsProgress: 'Total Savings Progress',
    percentComplete: '%s% Complete',
    savingsOfTarget: '%s of %s',
    deleteGoalQuestion: 'Delete Goal?',
    confirmDeleteGoalPermanent: 'This will permanently delete "%s"',
    addedToSavings: 'Added %s to "%s"',
    goalDeleted: '"%s" was deleted',
    goalWasDeleted: 'Goal was deleted',
    amountGreaterThanZero: 'Please enter an amount greater than zero',
    couldNotAddSavings: 'Could not add to savings. Please try again.',
    couldNotDeleteGoal: 'Could not delete goal. Please try again.',
    goalsRefreshed: 'Your goals have been refreshed',
    aboutSavingGoals: 'About Saving Goals',
    trackProgress: 'Track your progress',
    trackProgressDescription: 'See how close you are to reaching each goal',
    addMoneyAnytime: 'Add money anytime',
    addMoneyAnytimeDescription:
    'Contribute to your goals whenever you save money',
    setTargetDates: 'Set target dates',
    setTargetDatesDescription: 'Stay motivated with clear deadlines',
    gotIt: 'Got It',
    addExpense: 'Add Expense',
    editExpense: 'Edit Expense',
    addIncome: 'Add Income',
    editIncome: 'Edit Income',
    category: 'Category',
    date: 'Date',
    pleaseEnterValidAmount: 'Please enter a valid amount',
    pleaseSelectCategory: 'Please select a category',
    transactionSaved: 'Transaction saved successfully',
    transactionUpdated: 'Transaction updated successfully',
    failedToSaveTransaction: 'Failed to save transaction. Please try again.',
    food: 'Food',
    transport: 'Transport',
    utilities: 'Utilities',
    entertainment: 'Entertainment',
    shopping: 'Shopping',
    health: 'Health',
    others: 'Others',
    salary: 'Salary',
    investment: 'Investment',
    business: 'Business',
    gift: 'Gift',
    noTransactionsYet: 'No transactions yet',
    today: 'Today',
    yesterday: 'Yesterday',
    dashboardHelpTitle: 'How to use the Dashboard',
    dashboardHelpSubtitle: 'Track your finances easily',
    dashboardHelpBalance:
    'View your current balance, income, and expenses at a glance',
    dashboardHelpAddTransaction: 'Add new transactions using the + button',
    dashboardHelpDeleteTransaction: 'Swipe left on transactions to delete them',
    dashboardHelpSpendingPatterns:
    'Monitor weekly spending patterns and category breakdown',
    dashboardHelpRefresh: 'Pull down to refresh your financial data',
    total: 'Total',
    noExpenseData: 'No expense data for this period',
    noIncomeData: 'No income data for this period',
    pagination: 'Page %d of %d',
    hideAssistant: 'Hide Assistant',
    askAboutChart: 'Ask about this chart',
    askAboutChartHint: 'Ask about this chart...',
    assistant: 'Assistant',
    queryError: 'Sorry, I couldn\'t process that question.',
    queryErrorWithMessage: 'Sorry, an error occurred: %s',
    chartContext:
    'I\'m looking at a %s chart showing my %s data. The chart data is: %s.',
    queryPrompt:
    'You are a helpful financial assistant. Answer the following question about the chart data. Keep your answer brief (under 100 words) and focused on the chart data. If you can\'t answer from the data provided, state that clearly. Chart context: %s Question: %s',
    advancedQuizTitle: 'Advanced Quiz',
    quizCompleted: 'Quiz Completed!',
    quizResultScore: 'Your score: %s/%s',
    quizFinish: 'Finish',
    quizTryAgain: 'Try Again',
    quizQuestion1: 'What is the main benefit of compound interest?',
    quizQuestion1Answer1: 'Money grows faster over time',
    quizQuestion1Answer2: 'It reduces your taxes',
    quizQuestion1Answer3: 'It\'s safer than regular interest',
    quizQuestion2: 'What does diversification in investing mean?',
    quizQuestion2Answer1: 'Putting all money in one stock',
    quizQuestion2Answer2: 'Spreading investments across different assets',
    quizQuestion2Answer3: 'Investing only in what you know',
    quizQuestion3: 'What is a key feature of index funds?',
    quizQuestion3Answer1: 'High management fees',
    quizQuestion3Answer2: 'Tracks a specific market index',
    quizQuestion3Answer3: 'Guaranteed returns',
    quizQuestion4: 'What is the 4% retirement rule?',
    quizQuestion4Answer1: 'Withdraw 4% of savings annually in retirement',
    quizQuestion4Answer2: 'Save 4% of income for retirement',
    quizQuestion4Answer3: 'Work 4% longer than planned',
    quizQuestion5:
    'What type of insurance is most important for income protection?',
    quizQuestion5Answer1: 'Travel insurance',
    quizQuestion5Answer2: 'Income protection insurance',
    quizQuestion5Answer3: 'Pet insurance',
    advancedScreenTitle: 'Advanced Financial Skills',
    investmentBasicsTitle: 'Investment Basics',
    investmentBasicsPoint1: 'Understanding stocks and bonds',
    investmentBasicsPoint2: 'Risk vs return principles',
    investmentBasicsPoint3: 'Diversification strategies',
    retirementPlanningTitle: 'Retirement Planning',
    retirementPlanningPoint1: 'Understanding superannuation',
    retirementPlanningPoint2: 'Compound interest power',
    retirementPlanningPoint3: 'Retirement savings goals',
    insuranceProtectionTitle: 'Insurance & Protection',
    insuranceProtectionPoint1: 'Types of insurance needed',
    insuranceProtectionPoint2: 'Calculating coverage needs',
    insuranceProtectionPoint3: 'Balancing cost and protection',
    takeAdvancedQuiz: 'Take Advanced Quiz',
    beginnerQuizTitle: 'Beginner Quiz',
    beginnerQuizQuestion1: 'What is the first step in managing money?',
    beginnerQuizQuestion1Answer1: 'Spend everything you earn',
    beginnerQuizQuestion1Answer2: 'Track your income and expenses',
    beginnerQuizQuestion1Answer3: 'Invest in stocks',
    beginnerQuizQuestion2: 'Which is a "need" rather than a "want"?',
    beginnerQuizQuestion2Answer1: 'New smartphone',
    beginnerQuizQuestion2Answer2: 'Groceries',
    beginnerQuizQuestion2Answer3: 'Vacation',
    beginnerQuizQuestion3: 'How much should you ideally save from your income?',
    beginnerQuizQuestion3Answer1: '5%',
    beginnerQuizQuestion3Answer2: '20%',
    beginnerQuizQuestion3Answer3: '50%',
    beginnerScreenTitle: 'Beginner Financial Skills',
    understandingMoneyTitle: 'Understanding Money',
    understandingMoneyPoint1: 'What is money and how it works',
    understandingMoneyPoint2: 'Different types of money (cash, digital)',
    understandingMoneyPoint3: 'Basic needs vs wants',
    simpleBudgetingTitle: 'Simple Budgeting',
    simpleBudgetingPoint1: 'Tracking daily expenses',
    simpleBudgetingPoint2: 'The 50-30-20 rule simplified',
    simpleBudgetingPoint3: 'Saving small amounts regularly',
    bankAccountsTitle: 'Bank Accounts',
    bankAccountsPoint1: 'Types of bank accounts',
    bankAccountsPoint2: 'How to deposit and withdraw money',
    bankAccountsPoint3: 'Understanding bank statements',
    takeBeginnerQuiz: 'Take Beginner Quiz',
    resourceError: 'Could not open resource: %s',
    intermediateQuizTitle: 'Intermediate Quiz',
    intermediateQuizQuestion1: 'What is the purpose of an emergency fund?',
    intermediateQuizQuestion1Answer1: 'To pay for vacations',
    intermediateQuizQuestion1Answer2: 'To cover unexpected expenses',
    intermediateQuizQuestion1Answer3: 'To invest in stocks',
    intermediateQuizQuestion2:
    'What percentage of your income should go to needs in the 50-30-20 rule?',
    intermediateQuizQuestion2Answer1: '20%',
    intermediateQuizQuestion2Answer2: '30%',
    intermediateQuizQuestion2Answer3: '50%',
    intermediateQuizQuestion3: 'What is a good credit score range?',
    intermediateQuizQuestion3Answer1: '300-500',
    intermediateQuizQuestion3Answer2: '670-850',
    intermediateQuizQuestion3Answer3: '100-300',
    intermediateQuizQuestion4: 'What is the first step to get out of debt?',
    intermediateQuizQuestion4Answer1: 'Ignore it and hope it goes away',
    intermediateQuizQuestion4Answer2: 'Create a debt repayment plan',
    intermediateQuizQuestion4Answer3: 'Take on more debt to pay it off',
    intermediateScreenTitle: 'Intermediate Financial Skills',
    advancedBudgetingTitle: 'Advanced Budgeting',
    advancedBudgetingPoint1: 'Creating a monthly budget plan',
    advancedBudgetingPoint2: 'Setting financial goals',
    advancedBudgetingPoint3: 'Managing irregular income',
    creditBasicsTitle: 'Credit Basics',
    creditBasicsPoint1: 'Understanding credit scores',
    creditBasicsPoint2: 'Responsible credit card use',
    creditBasicsPoint3: 'Avoiding debt traps',
    savingStrategiesTitle: 'Saving Strategies',
    savingStrategiesPoint1: 'Emergency funds (3-6 months)',
    savingStrategiesPoint2: 'Saving for big purchases',
    savingStrategiesPoint3: 'Automating your savings',
    takeIntermediateQuiz: 'Take Intermediate Quiz',
    quizHomeTitle: 'Financial Knowledge Quiz',
    beginnerLevelQuiz: 'Beginner Level Quiz',
    intermediateLevelQuiz: 'Intermediate Level Quiz',
    advancedLevelQuiz: 'Advanced Level Quiz',
    transactionAddedSuccess: 'Transaction added successfully',
    transactionCanceled: 'No problem, I won\'t add that transaction.',
    transactionAddError:
    'Sorry, I couldn\'t add the transaction. Please try again later.',
    transactionConfirmPrompt:
    'I\'m not sure what you want to do with this transaction. Let me show you the options.',
    transactionNoPending:
    'I don\'t have any transaction to confirm at the moment.',
    chatbotHelpTitle: 'How to Use Finney AI',
    chatbotHelpSubtitle: 'Your personal financial assistant',
    chatbotHelpInstruction1: 'Ask finance-related questions for instant advice',
    chatbotHelpInstruction2: 'Upload financial images for analysis',
    chatbotHelpInstruction3:
    'You can use the microphone to talk with the AI assistant',
    chatbotHelpInstruction4: 'Try suggested questions or type your own',
    welcomeTryAsking: 'Try asking',
    welcomeWriteQuestion: 'Write your own question',
    voiceListening: 'Listening... Tap again when you finish',
    voiceProcessing: 'Processing...',
    voiceTapMic: 'Tap microphone to talk with Finney AI',
    voiceSttNotAvailable: 'Speech recognition not available on this device',
    transactionPreviewTitle: 'Transaction Preview',
    transactionPreviewCancel: 'Cancel',
    transactionPreviewConfirm: 'Confirm',
    chatInputHint: 'Ask me a financial question...',
    nonFinancialQuestion:
    'I\'m here to help with your financial questions. What money matters can I assist with?',
    nonFinancialImage:
    'I can only analyze financial documents or receipts. Need help with something financial?',
    addNew: 'Add New',
    categorySpentAmount: 'Spent %s in %s category (%s%%)',
    categoryEarnedAmount: 'Earned %s from %s category (%s%%)',
    'expenseSummary':
    'Total expenses: %s, average: %s. Highest expense: %s on %s, and lowest expense: %s on %s.',
    'incomeSummary':
    'Total income: %s, average: %s. Highest income: %s on %s, and lowest income: %s on %s.',
    'expenseCategorySummary':
    'Highest expense is in %s category, which is %s (%s%%).',
    'incomeCategorySummary':
    'Highest income is from %s category, which is %s (%s%%).',
    forgotPasswordTitle: 'Forgot Password',
    emailHint: 'Enter your email',
    sendResetLink: 'Send Reset Link',
    backToLogin: 'Back to login',
    passwordResetSuccess: 'A password reset link has been sent to your email.',
    passwordResetError:
    'Failed to send reset link. Please check your email and try again.',
    dialogOk: 'OK',
    loginTitle: 'Login to your Account',
    passwordHint: 'Password',
    forgotPassword: 'Forgot Password?',
    signInButton: 'Sign In',
    continueWith: 'Or continue with',
    notMember: 'Not a member?',
    registerNow: 'Register now',
    loginError: 'Incorrect email/password. Please check again.',
    userNotFoundError: 'User details not found in local storage.',
    registerTitle: 'Create your Account',
    confirmPasswordHint: 'Confirm Password',
    signUpButton: 'Sign Up',
    alreadyMember: 'Already a member?',
    loginNow: 'Log in now',
    passwordStrong: '✅ Strong password',
    passwordWeak: '❌ Use 12+ chars w/ upper, lower, number & symbol',
    invalidGmailError: 'Please enter a valid Gmail address.',
    passwordsNotMatchError: 'Passwords do not match.',
    weakPasswordError:
    'Password must be at least 12 characters long and include uppercase, lowercase, number, and symbol.',
    hiveStorageError: 'Failed to store user in local storage.',
    selectLanguage: 'Select Language',
    saveHabitTitle: 'Making Saving a Habit',
    saveHabitDesc:
    'It’s smart to save money regularly and turn it into a habit. The best way is to plan your savings before you spend.',
    saveWhyTitle: 'Why Saving Is Important',
    saveWhyDesc:
    'Saving money for emergencies is super important. If you keep some money aside as soon as you get paid, your future will feel more secure.',
    budgetSmartTitle: 'Smart Monthly Income Allocation',
    budgetSmartDesc:
    'Spend 55% on needs, 10% on long-term investments, 10% for future goals, 10% to improve your skills, and 15% for fun or charity.',
    budgetSelfTitle: 'Investing in Yourself Pays Off Most',
    budgetSelfDesc:
    'Instead of starting a business with 10,000 Taka, improve your skills. Read books, take online courses, and find ways to earn using your knowledge.',
    spendManageTitle: 'Manage, Grow, Invest & Protect Money',
    spendManageDesc:
    'No matter how much you earn, if you manage it well, grow it, invest it, and protect it, your future will be secure.',
    spendLandTitle: 'Smart Investment: Buy Land',
    spendLandDesc:
    'Land is a safe and profitable investment. Check papers and location before you buy. It’s more flexible than flats or crypto.',
    coachQ1:
    'How good are you with managing your money? Boss level or still figuring it out?',
    coachQ2: 'How much money do you usually save each month?',
    coachQ3: 'How much do you usually spend each month?',
    coachQ4: 'In a perfect world, how much would you love to save monthly?',
    coachQ5: 'Can you easily tell needs apart from wants?',
    coachQ6: 'What category eats up most of your money?',
    coachQ7: 'Do you track where your money goes?',
    coachQ8: 'Are you willing to adjust your spending habits?',
    coachQ9: 'Do you often spend money without planning?',
    coachQ10: 'When you get extra cash, do you save it or spend it?',
    coachQ11: 'Would you rather save for a big goal or enjoy small treats now?',
    coachSavingSmall:
    'You are saving a small amount. Try to increase your savings bit by bit! ',
    coachOnYourWay: 'You are on your way! Keep building your savings habit. ',
    coachPraiseGreat: 'Great job! You are saving a lot. ',
    never: 'Never',
    sometimes: 'Sometimes',
    no: 'No',
    maybe: 'Maybe',
    coachAdviceTitle: 'Your Savings Coach Advice',
    coachOptBoth: 'A bit of both',
    coachOptSaveBig: 'Save for big goal',
    coachOptTreats: 'Enjoy small treats',
    coachPraiseHabit: 'Great saving habit!',
    coachRestart: 'Restart Savings Coach',
    learnNoResults: 'No results found.',
    tourBudgetTitle: 'Stay on Budget',
    tourBudgetDesc:
    'Learn how to use reminders to stick to your spending limits and avoid unnecessary purchases.',
    tourChatbotTitle: 'AI Chat Assistant',
    tourChatbotDesc:
    'Understand how the chatbot helps answer your finance questions and guides you through the app.',
    tourDashboardTitle: 'Dashboard Overview',
    tourDashboardDesc:
    'Learn how to navigate the dashboard and understand key metrics of your financial health.',
    tourExpenseTitle: 'Track Spending Habits',
    tourExpenseDesc:
    'See how to record and monitor your everyday expenses to avoid overspending.',
    tourLearnHubDesc:
    'Get an overview of the main LearnHub content and how to navigate through lessons.',
    tourLearnhubTitle: 'LearnHub Module Overview',
    tourLearnhubDesc:
    'A quick intro to LearnHub modules and how to use the lessons.',
    tourReportDesc:
    'Learn how to view and understand your financial reports for better decision-making.',
    tourReportTitle: 'Report Overview',
    tourSavingsTitle: 'Setting Up Saving Goals',
    tourSavingsDesc:
    'Learn how to set, track, and achieve your personal savings goals using the app’s built-in features.',
    tourSettingsTitle: 'Settings Overview',
    tourSettingsDesc:
    'Learn how to update language, notifications, and other app settings to personalize your experience.',
    tourMarkDone: 'Mark as Done',
    generalQuizTitle: 'Test Your Knowledge',
    quizScore: 'Score: %s / %s',
    quizBack: 'Back to Quiz',
    quizReview: 'Review Your Answers',
    quizClearConfirm: 'Are you sure you want to clear all quiz results?',
    quizNoResults: 'No quiz results found.',
    quizResults: 'Quiz Results',
    quizReset: 'Reset Quiz Results',
    quizResetConfirm:
    'Are you sure you want to delete all quiz results? This action cannot be undone.',
    reset: 'Reset',
    quizAttempts: 'Attempts',
    quizAverage: 'Average',
    quizLastAttempt: 'Last Attempt',
    quizQ1: 'What is the purpose of the Finney app?',
    quizQ1A1: 'Gaming',
    quizQ1A2: 'Social networking',
    quizQ1A3: 'Financial literacy',
    quizQ1A4: 'Online shopping',
    quizQ2: 'Which screen helps track expenses?',
    quizQ2A1: 'Dashboard',
    quizQ2A2: 'Chatbot',
    quizQ2A3: 'Learn',
    quizQ2A4: 'Settings',
    quizQ3: 'What is a budget used for?',
    quizQ3A1: 'Tracking spending',
    quizQ3A2: 'Entertainment',
    quizQ3A3: 'Investing in crypto',
    quizQ3A4: 'Buying groceries',
    quizQ4: 'Which category would rent typically go under?',
    quizQ4A1: 'Savings',
    quizQ4A2: 'Needs',
    quizQ4A3: 'Wants',
    quizQ4A4: 'Luxury',
    quizQ5: 'What is one smart spending tip?',
    quizQ5A1: 'Buy unnecessary items',
    quizQ5A2: 'Track every dollar',
    quizQ5A3: 'Avoid discounts',
    quizQ5A4: 'Spend impulsively',
    quizQ6: 'Why should you wait 24 hours before buying something unplanned?',
    quizQ6A1: 'Shops may close',
    quizQ6A2: 'Helps avoid impulse spending',
    quizQ6A3: 'Prices might drop',
    quizQ6A4: 'You might get paid',
    quizQ7: 'What is a “want” in budgeting terms?',
    quizQ7A1: 'Essential food',
    quizQ7A2: 'Rent',
    quizQ7A3: 'Medical expenses',
    quizQ7A4: 'Designer sneakers',
    quizQ8: 'Which of the following helps increase income?',
    quizQ8A1: 'Skipping meals',
    quizQ8A2: 'Skill development',
    quizQ8A3: 'Spending more',
    quizQ8A4: 'Taking loans',
    quizQ9: 'What is the 50-30-20 rule commonly used for?',
    quizQ9A1: 'Meal planning',
    quizQ9A2: 'Work hours',
    quizQ9A3: 'Budgeting',
    quizQ9A4: 'Exercise routine',
    quizQ10: 'What should you do before spending money?',
    quizQ10A1: 'Check trends',
    quizQ10A2: 'Post on social media',
    quizQ10A3: 'Make a budget plan',
    quizQ10A4: 'Borrow from friends',
    quizQ11:
    'Where is it safest to invest first, according to the Finney app videos?',
    quizQ11A1: 'Crypto',
    quizQ11A2: 'Land',
    quizQ11A3: 'Forex',
    quizQ11A4: 'NFTs',
    quizQ12: 'What’s a benefit of cooking at home?',
    quizQ12A1: 'More plastic waste',
    quizQ12A2: 'Higher delivery cost',
    quizQ12A3: 'Saves money and improves health',
    quizQ12A4: 'Takes more time',
    quizQ13: 'Why is saving early in the month smart?',
    quizQ13A1: 'To avoid shopping',
    quizQ13A2: 'So you don’t have to budget',
    quizQ13A3: 'To build financial discipline',
    quizQ13A4: 'To pay fines early',
    quizQ14:
    'How much should ideally go into personal development according to budgeting tips?',
    quizQ14A1: '55%',
    quizQ14A2: '15%',
    quizQ14A3: '30%',
    quizQ14A4: '10%',
    quizQ15: 'What does “protecting your money” usually refer to?',
    quizQ15A1: 'Spending on gadgets',
    quizQ15A2: 'Avoiding all risks',
    quizQ15A3: 'Using insurance and emergency funds',
    quizQ15A4: 'Buying gold',
    quizQ16: 'What is the first step in setting a financial goal?',
    quizQ16A1: 'Spend freely',
    quizQ16A2: 'Set a savings target',
    quizQ16A3: 'Shop online',
    quizQ16A4: 'Borrow money',
    quizQ17: 'Which feature provides instant financial help in the Finney app?',
    quizQ17A1: 'Settings',
    quizQ17A2: 'QnA Chatbot',
    quizQ17A3: 'Expense Tracker',
    quizQ17A4: 'Profile',
    quizQ18: 'An emergency fund is mainly used for?',
    quizQ18A1: 'Vacations',
    quizQ18A2: 'Unexpected expenses',
    quizQ18A3: 'Entertainment',
    quizQ18A4: 'Shopping',
    quizQ19: 'Which is a good saving habit?',
    quizQ19A1: 'Impulse buying',
    quizQ19A2: 'Tracking expenses',
    quizQ19A3: 'Ignoring bills',
    quizQ19A4: 'Overspending',
    quizQ20: 'If you earn 20000 and spend 18000, your savings are?',
    quizQ20A1: '5000',
    quizQ20A2: '3000',
    quizQ20A3: '2000',
    quizQ20A4: '1000',
    quizQ21: 'What usually causes financial stress?',
    quizQ21A1: 'Overspending',
    quizQ21A2: 'Saving regularly',
    quizQ21A3: 'Following a budget',
    quizQ21A4: 'Having insurance',
    quizQ22: 'When should you ideally save money?',
    quizQ22A1: 'End of the month',
    quizQ22A2: 'After income',
    quizQ22A3: 'After expenses',
    quizQ22A4: 'When borrowing',
    quizQ23: 'Budgeting helps in?',
    quizQ23A1: 'Spending more',
    quizQ23A2: 'Managing money better',
    quizQ23A3: 'Losing savings',
    quizQ23A4: 'Gambling',
    quizQ24: 'Which is a “need” expense?',
    quizQ24A1: 'Netflix subscription',
    quizQ24A2: 'Groceries',
    quizQ24A3: 'Luxury car',
    quizQ24A4: 'Designer watch',
    quizQ25: 'Before investing, you should always check?',
    quizQ25A1: 'Popularity',
    quizQ25A2: 'Risk and return',
    quizQ25A3: 'Number of likes',
    quizQ25A4: 'Brand name',
    quizQ26: 'How to reduce impulse buying?',
    quizQ26A1: 'Use credit cards',
    quizQ26A2: 'Use shopping lists',
    quizQ26A3: 'Follow ads',
    quizQ26A4: 'Shop when emotional',
    quizQ27: 'A good financial goal is?',
    quizQ27A1: 'Vague and distant',
    quizQ27A2: 'Specific and measurable',
    quizQ27A3: 'Expensive and fast',
    quizQ27A4: 'Lucky and random',
    quizQ28: 'Saving money mainly helps with?',
    quizQ28A1: 'Showing off',
    quizQ28A2: 'Building security',
    quizQ28A3: 'Buying unnecessary items',
    quizQ28A4: 'Spending faster',
    quizQ29: 'Which section in the Finney app helps improve financial skills?',
    quizQ29A1: 'Settings',
    quizQ29A2: 'Learn Academy',
    quizQ29A3: 'Notifications',
    quizQ29A4: 'Profile',
    quizQ30: 'If expenses are greater than income, what happens?',
    quizQ30A1: 'Debt increases',
    quizQ30A2: 'Savings increase',
    quizQ30A3: 'Net worth grows',
    quizQ30A4: 'Salary doubles',
    reviewAnswers: 'Review Answers',
    backToQuiz: 'Back to Quiz',
    dashboard: 'Dashboard',
    expenseTracking: 'Expense Tracking',
    report: 'Report',
    savingGoals: 'Saving Goals',
    quiz: 'Quiz',
    learningReset: 'Learning progress reset.',
    learningHub: 'Learning Hub',
    ongoing: 'Ongoing',
    completed: 'Completed',
    noResultsFound: 'No results found.',
    savingMoneyEasy: 'Saving Money Easy',
    simpleBudgeting: 'Simple Budgeting',
    lessons: "Lessons",
    appTour: "App Tour",
    progress: "Progress",
    smartSpendingTipsSubtitle: "Spend smarter, live better",
    simpleBudgetingSubtitle: "Plan with ease",
    savingMoneyEasySubtitle: "Build your future",
    savingsCoach: "Savings Coach",
    savingsCoachSubtitle: "Cut costs, not dreams",
    taketheQuiz: "Take the Quiz",
    taketheQuizSubtitle: "Test your knowledge",
    viewQuizResult: "View Quiz Result",
    quizResultSubtitle: "See your scores",

    coachOptMoneyBoss: 'Money boss',
    coachOptDoingOkay: 'Doing okay',
    coachOptNeedsWork: 'Needs work',
    coachOpt0_200: '\$0-\$200',
    coachOpt200_500: '\$200-\$500',
    coachOpt500plus: '\$500+',
    coachOpt0_1000: '\$0-\$1000',
    coachOpt1000_2000: '\$1000-\$2000',
    coachOpt2000plus: '\$2000+',
    coachOpt100: '\$100',
    coachOpt500: '\$500',
    coachOpt1000plus: '\$1000+',
    coachOptAlways: 'Always',
    coachOptSometimes: 'Sometimes',
    coachOptNotReally: 'Not really',
    coachOptFood: 'Food',
    coachOptShopping: 'Shopping',
    coachOptEntertainment: 'Entertainment',
    coachOptNever: 'Never',
    coachOptYes: 'Yes',
    coachOptMaybe: 'Maybe',
    coachOptNo: 'No',
    coachOptRarely: 'Rarely',
    coachOptSaveIt: 'Save it',
    coachOptSpendIt: 'Spend it',

    coachOptNotSure: 'Not sure',
    coachOtherHint: 'Other (please specify)',
    coachSeeResult: 'See Result',
    coachNext: 'Next',
    coachSavingPlan: 'Your Saving Plan',
    'quizLoadError': 'Failed to load quiz results. Please try again.',
    'quizResetSuccess': 'Quiz results have been cleared.',
    'error': 'Error',
    'refresh': 'Refresh',
    'clearAllResults': 'Clear All Results',
    'learnFinanceDescription': 'Learn the basics of finance through videos and quizzes.',

  };

  static const Map<String, String> bn = {
    'quizLoadError': 'কুইজ ফলাফল লোড করতে ব্যর্থ হয়েছে। আবার চেষ্টা করুন।',
    'quizResetSuccess': 'কুইজের ফলাফল সাফ করা হয়েছে।',
    'error': 'ভুল',
    'refresh': 'রিফ্রেশ',
    'clearAllResults': 'সব ফলাফল মুছে ফেলুন',
    'learnFinanceDescription': 'ভিডিও এবং কুইজের মাধ্যমে অর্থের মূল ধারণা শিখুন।',


    greatJob: "🏆 চমৎকার কাজ!",
    goodEffort: "👍 ভালো চেষ্টা",
    tryAgain: "🔄 আবার চেষ্টা করুন",
    coachSpendingHigh:
    "কিন্তু আপনার খরচ বেশি। অন্তত %s থেকে ১৫০ ডলার কমানোর চেষ্টা করুন।\n",
    coachSpendingMedium: "এখনও %s থেকে প্রায় ১০০ ডলার কমানোর সুযোগ আছে।\n",
    coachSpendingHealthy: "আপনার খরচ স্বাস্থ্যকর। এভাবেই চালিয়ে যান!\n",
    coachTrackStart:
    "আপনার টাকা কোথায় যাচ্ছে তা ট্র্যাক করা শুরু করুন। অবাক হবেন!\n",
    coachTrackMore:
    "আরও একটু সিরিয়াসলি ট্র্যাক করলে লুকানো খরচ বেরিয়ে আসবে।\n",
    coachAdjustNo: "একটা খাবার কম খেলেও মাসে ১০০+ ডলার সেভ করা যায়।\n",
    coachAdjustMaybe: "ছোট ছোট পরিবর্তন ট্রাই করুন। ফলাফল ভালো লাগতে পারে!\n",
    coachAdjustYes: "আপনি প্রস্তুত! এবার সেভিংস লক্ষ্য পূরণে ঝাঁপিয়ে পড়ুন!\n",
    score: "স্কোর",
    accuracy: "সঠিকতা",
    highScore: "🏅 সর্বোচ্চ স্কোর",
    feedbackMessageNotBad: "🧠 খারাপ না! আরেকটু শিখলেই অনেক দূর যেতে পারবেন।",
    feedbackMessageKeepGoing:
    "📘 চালিয়ে যান! লার্ন সেকশনটি আবার দেখুন এবং চেষ্টা করুন।",
    feedbackMessageGood: "👍 দারুণ! আপনি সঠিক পথে আছেন!",
    feedbackMessageExcellent: "🎉 অসাধারণ! আপনি অর্থ ব্যবস্থাপনায় মাস্টার!",
    restartQuiz: 'কুইজ পুনরায় চালু করুন',
    savingMoneyVideo2Title: "সেভিং কেন জরুরি",
    savingMoneyVideo2Subtitle:
    "হঠাৎ প্রয়োজনে টাকা সেভ থাকা খুবই জরুরি। ইনকাম পাওয়ার সাথে সাথেই যদি কিছু টাকা আলাদা করে রাখেন, আপনার ভবিষ্যৎ অনেক বেশি সুরক্ষিত থাকবে।",

    savingMoneyVideo1Title: "সেভ করা অভ্যাসে পরিণত করুন",
    savingMoneyVideo1Subtitle:
    "নিয়মিত সেভ করা চালিয়ে গেলে সেটা একটা ভালো অভ্যাসে পরিণত হয়। খরচের আগেই সেভিংস প্ল্যান করাটাই সবচেয়ে বুদ্ধিমানের কাজ।",
    simpleBudgetingvideo1Title: "স্মার্ট মাসিক ইনকাম ভাগ করা",
    simpleBudgetingvideo1Subtitle:
    "৫৫% প্রয়োজনীয় জিনিসে, ১০% লং-টার্ম ইনভেস্টমেন্টে, ১০% ভবিষ্যতের লক্ষ্য পূরণে, ১০% নিজের স্কিল বাড়াতে, আর ১৫% ফান বা দান খয়রাতে খরচ করুন।",
    simpleBudgetingvideo2Title: "নিজের উপর ইনভেস্ট করাই সবচেয়ে কাজের",
    simpleBudgetingvideo2Subtitle:
    "১০,০০০ টাকা দিয়ে বিজনেস শুরু না করে আগে নিজের স্কিল বাড়ান। বই পড়ুন, অনলাইন কোর্স করুন, আর নিজের জ্ঞান দিয়ে ইনকাম করার উপায় খুঁজে বের করুন।",
    spendingVideo2Title: "স্মার্ট ইনভেস্টমেন্ট: জমি কিনুন",
    spendingVideo2Subtitle:
    "জমি একটা সেফ আর লাভজনক ইনভেস্টমেন্ট। কেনার আগে কাগজপত্র আর লোকেশন ভালো করে দেখে নিন। এটা ফ্ল্যাট বা ক্রিপ্টোর চেয়ে অনেক বেশি ফ্লেক্সিবল।",
    spendingVideo1Subtitle:
    "আপনি যতই আয় করুন না কেন — ঠিকভাবে ম্যানেজ, বাড়ানো, ইনভেস্ট আর নিরাপদ রাখলে ভবিষ্যৎ হবে সুরক্ষিত।",
    spendingVideo1Title: "টাকা ম্যানেজ, বাড়ান, ইনভেস্ট আর সুরক্ষা দিন",
    apptourDashSubtitle: "প্রধান ওভারভিউ অন্বেষণ করুন",
    searchTextfiedText: "বিষয়বস্তু অনুসন্ধান করুন..",
    expenseTrackingSubtite: "আপনার দৈনিক খরচ ট্র্যাক করুন",
    savingGoalheading: "সেভিং গোল সেটআপ",
    savingGoalSubheading: "গোল সেট করুন এবং অর্জন করুন",
    savingGoalSubtitled:
    "অ্যাপের অন্তর্নির্মিত বৈশিষ্ট্যগুলি ব্যবহার করে কীভাবে আপনার ব্যক্তিগত সেভিং গোল সেট, ট্র্যাক এবং অর্জন করবেন তা শিখুন।",
    learnHub: "লার্নহাব",
    learnHubSubtitle: "কেন্দ্রীয় শেখার এলাকা",
    tourBudgetSubTitle: "বাজেটের মধ্যে থাকুন",
    tourCahtBotSubtite: "আপনার বন্ধুত্বপূর্ণ গাইড",
    tourReportSubtite: "সম্পূর্ণ চিত্র দেখুন",
    settingSubHeading: "পছন্দসমূহ সামঞ্জস্য করুন",
    smartSpendingTips: 'স্মার্ট খরচের টিপস',
    appTitle: 'ফিনি',
    settings: 'সেটিংস',
    viewProfile: 'প্রোফাইল দেখুন',
    profileInformation: 'প্রোফাইল তথ্য',
    fullName: 'পুরো নাম',
    phoneNumber: 'ফোন নম্বর',
    address: 'ঠিকানা',
    email: 'ইমেল',
    userId: 'ব্যবহারকারীর আইডি',
    edit: 'সম্পাদনা',
    save: 'সংরক্ষণ',
    close: 'বন্ধ',
    appearance: 'চেহারা',
    language: 'ভাষা',
    languageEnglish: 'ইংরেজি',
    languageBengali: 'বাংলা',
    currency: 'মুদ্রা',
    currencyBDT: 'বাংলাদেশী টাকা (৳)',
    currencyAUD: 'অস্ট্রেলিয়ান ডলার (AUD)',
    textSize: 'টেক্সট সাইজ',
    management: 'ব্যবস্থাপনা',
    security: 'নিরাপত্তা',
    setPin: 'পিন সেট করুন',
    enterPin: '৪-সংখ্যার পিন লিখুন',
    confirmPin: '৪-সংখ্যার পিন নিশ্চিত করুন',
    pinSaved: 'পিন সংরক্ষিত!',
    invalidPin: 'অনুগ্রহ করে ৪-সংখ্যার পিন লিখুন',
    pinsDoNotMatch: 'পিন মেলেনি',
    cancel: 'বাতিল',
    helpSupport: 'সহায়তা ও সমর্থন',
    helpSupportComingSoon: 'সহায়তা ও সমর্থন পৃষ্ঠা শীঘ্রই আসছে!',
    logOut: 'লগ আউট',
    signedOut: 'সফলভাবে সাইন আউট হয়েছে',
    errorLoadingData: 'তথ্য লোড করতে ব্যর্থ',
    errorSavingData: 'তথ্য সংরক্ষণের ত্রুটি',
    user: 'ব্যবহারকারী',
    notAvailable: 'পাওয়া যায়নি',
    financialBasics: 'আর্থিক মৌলিক বিষয়',
    askFinneyAI: 'যেকোনো সাহায্যের জন্য ফিনি এআই-কে জিজ্ঞাসা করুন',
    moneyManagement: 'অর্থ ব্যবস্থাপনা',
    moneyManagementSubtitle:
    'আপনার অর্থ ট্র্যাক, পরিকল্পনা এবং নিয়ন্ত্রণ করুন',
    savingBudgeting: 'সঞ্চয় ও বাজেটিং',
    savingBudgetingSubtitle:
    'কীভাবে স্মার্টলি সঞ্চয় এবং বাজেট করতে হয় তা শিখুন',
    investingFundamentals: 'বিনিয়োগের মৌলিক বিষয়',
    investingFundamentalsSubtitle: 'আপনার অর্থ কীভাবে বাড়ানো যায় তা বুঝুন',
    financialSafety: 'আর্থিক নিরাপত্তা',
    financialSafetySubtitle: 'নিরাপদ থাকুন এবং প্রতারণা এড়ান',
    keyPoints: 'মূল বিষয়',
    learnMore: 'আরও জানুন',
    backToTopics: 'বিষয়গুলোতে ফিরে যান',
    aiAssistant: 'এআই সহকারী',
    moneyManagementPoint1: 'নিয়মিত আয় এবং খরচ ট্র্যাক করুন',
    moneyManagementPoint2: 'প্রয়োজন এবং চাওয়ার মধ্যে পার্থক্য করুন',
    moneyManagementPoint3: 'বেসিক ব্যাংকিং পরিষেবা বুঝুন',
    moneyManagementPoint4: 'একটি সাধারণ আর্থিক রেকর্ড বজায় রাখুন',
    savingBudgetingPoint1:
    '50-30-20 নিয়ম অনুসরণ করুন (প্রয়োজন-চাওয়া-সঞ্চয়)',
    savingBudgetingPoint2: 'জরুরি তহবিল তৈরি করুন (3-6 মাসের খরচ)',
    savingBudgetingPoint3: 'আপনার সঞ্চয় স্বয়ংক্রিয় করুন',
    savingBudgetingPoint4: 'মাসিক বাজেট পর্যালোচনা এবং সমন্বয় করুন',
    investingFundamentalsPoint1: 'ঝুঁকি এবং রিটার্ন বুঝুন',
    investingFundamentalsPoint2: 'আপনার বিনিয়োগ বৈচিত্র্যময় করুন',
    investingFundamentalsPoint3:
    'স্টক, বন্ড এবং মিউচুয়াল ফান্ড সম্পর্কে জানুন',
    investingFundamentalsPoint4:
    'ছোট বিনিয়োগ দিয়ে শুরু করুন এবং ধীরে ধীরে বাড়ান',
    financialSafetyPoint1: 'আর্থিক প্রতারণা চিনুন এবং এড়ান',
    financialSafetyPoint2: 'বীমার গুরুত্ব বুঝুন',
    financialSafetyPoint3: 'আপনার অনলাইন আর্থিক অ্যাকাউন্ট সুরক্ষিত করুন',
    financialSafetyPoint4: 'পরিচয় চুরি সুরক্ষা সম্পর্কে জানুন',
    resourceMoneyManagementVideo: 'বেসিক মানি ম্যানেজমেন্ট',
    resourceMoneyManagementArticle1:
    'ইনভেস্টোপিডিয়া: ব্যক্তিগত অর্থের মৌলিক বিষয়',
    resourceMoneyManagementArticle2:
    'ইনভেস্টোপিডিয়া: আর্থিক সাক্ষরতার চূড়ান্ত গাইড',
    resourceSavingVideo: 'বাজেটিং ফর বিগিনার্স; 50-30-20 নিয়ম শিখুন',
    resourceSavingArticle: 'নার্ডওয়ালেট: কীভাবে অর্থ বাজেট করবেন',
    resourceInvestingVideo: 'প্রফেসর ডেভ দ্বারা বিনিয়োগের মৌলিক বিষয়',
    resourceInvestingArticle: 'ইনভেস্টোপিডিয়া: বিনিয়োগের মৌলিক বিষয়',
    resourceSafetyVideo1: 'মোবাইল ব্যাংকিংয়ের জন্য আর্থিক নিরাপত্তা টিপস',
    resourceSafetyVideo2: 'আর্থিক নিরাপত্তার গাইড',
    resourceSafetyArticle1: 'ইনভেস্টোপিডিয়া: আর্থিক নিরাপত্তা টিপস',
    resourceSafetyArticle2: 'মানিস্মার্ট: প্রতারণা থেকে নিজেকে রক্ষা করুন',
    chatbotTitle: 'ফিনি এআই',
    chatbotHelp: 'সহায়তা',
    chatbotClearChat: 'চ্যাট মুছুন',
    welcomeMessage:
    'ফিনি এআই-এ স্বাগতম! আমি আজ আপনাকে কীভাবে সহায়তা করতে পারি?',
    suggestedQuestion1: 'বাজেটিং কী?',
    suggestedQuestion2: 'কীভাবে আমি কার্যকরভাবে অর্থ সঞ্চয় করতে পারি?',
    suggestedQuestion3: 'বিনিয়োগের মৌলিক বিষয়গুলো কী কী?',
    financialLearning: 'আর্থিক শিক্ষা',
    beginner: 'প্রাথমিক',
    beginnerSubtitle: 'বেসিক অর্থের দক্ষতা শিখুন',
    intermediate: 'মধ্যবর্তী',
    intermediateSubtitle: 'উন্নত আর্থিক অভ্যাস গড়ে তুলুন',
    advanced: 'উন্নত',
    advancedSubtitle: 'আপনার সম্পদ বাড়ান',
    testYourKnowledge: 'আপনার জ্ঞান পরীক্ষা করুন',
    testYourKnowledgeSubtitle: 'আপনার বোঝার পরীক্ষা করতে একটি কুইজ দিন',
    failedToLoadDashboardData: 'ড্যাশবোর্ড তথ্য লোড করতে ব্যর্থ',
    balanceCardTitle: 'হিসাব নিকাশ  ওভারভিউ',
    timeRangeSelectorLabel: 'সময়সীমা নির্বাচন করুন',
    recentTransactionsTitle: 'সাম্প্রতিক লেনদেন',
    addTransactionTitle: 'লেনদেন যোগ করুন',
    aiPoweredFeatures: 'এআই চালিত বৈশিষ্ট্য',
    moneyTools: 'অর্থের সরঞ্জাম',
    insights: 'ইনসাইট',
    goals: 'লক্ষ্য',
    thinking: 'চিন্তা করছে...',
    balance: 'হিসাব নিকাশ ',
    income: 'আয়',
    'financeAcademy': 'ফিন্যান্স একাডেমি',

    expenses: 'খরচ',
    expense: 'খরচ',
    saving: 'সঞ্চয়',
    savings: 'সঞ্চয়',
    thisMonth: 'এই মাস',
    thisWeek: 'এই সপ্তাহ',
    thisYear: 'এই বছর',
    customRange: 'কাস্টম পরিসীমা',
    selectTimePeriod: 'সময়কাল নির্বাচন করুন',
    allTime: 'সব সময়',
    mon: 'সোম',
    tue: 'মঙ্গল',
    wed: 'বুধ',
    thu: 'বৃহস্পতি',
    fri: 'শুক্র',
    sat: 'শনি',
    sun: 'রবি',
    jan: 'জানু',
    feb: 'ফেব',
    mar: 'মার্চ',
    apr: 'এপ্রিল',
    may: 'মে',
    jun: 'জুন',
    jul: 'জুলাই',
    aug: 'আগস্ট',
    sep: 'সেপ্ট',
    oct: 'অক্টো',
    nov: 'নভে',
    dec: 'ডিসে',
    spendingAnalysis: 'খরচ বিশ্লেষণ',
    categoryBreakdown: 'শ্রেণী বিন্যাস ',
    expenseAnalysis: 'খরচ বিশ্লেষণ',
    incomeAnalysis: 'আয় বিশ্লেষণ',
    transactions: 'লেনদেন',
    selectItemsToDelete: 'নির্বাচিত আইটেমগুলি মুছুন',
    noTransactionsInThisPeriod: 'এই সময়কালে কোনো লেনদেন নেই',
    seeAll: 'সব দেখুন',
    deleteTransactions: 'লেনদেন মুছুন',
    confirmDeleteTransactions: 'আপনি কি নিশ্চিত যে %dটি লেনদেন মুছতে চান?',
    delete: 'মুছুন',
    errorLoadingTransactions: 'লেনদেন লোড করতে ত্রুটি',
    confirmDeleteAction:
    'এই ক্রিয়াটি পূর্বাবস্থায় ফেরানো যাবে না। আপনি কি লেনদেন (গুলি) মুছে ফেলার বিষয়ে নিশ্চিত?',
    deleteTransaction: 'লেনদেন মুছুন',
    confirmDeleteSingleTransaction:
    'এই ক্রিয়াটি পূর্বাবস্থায় ফেরানো যাবে না। আপনি কি নিশ্চিত যে এই লেনদেনটি মুছতে চান?',
    savedAmount: 'সঞ্চিত: %s',
    targetAmount: 'লক্ষ্য: %s',
    percentCompleted: '%s% সম্পন্ন',
    targetDate: 'লক্ষ্য তারিখ: %s',
    daysLeft: '%d দিন বাকি',
    daysOverdue: '%d দিন অতিবাহিত',
    addSavings: 'সঞ্চয় যোগ করুন',
    addToSavings: 'সঞ্চয়ে যোগ করুন',
    amount: 'পরিমাণ',
    //savings: 'সঞ্চয়',
    pleaseEnterAmount: 'অনুগ্রহ করে একটি পরিমাণ লিখুন',
    pleaseEnterValidNumber: 'অনুগ্রহ করে একটি বৈধ সংখ্যা লিখুন',
    amountMustBePositive: 'পরিমাণ অবশ্যই ধনাত্মক হতে হবে',
    add: 'যোগ করুন',
    deleteGoal: 'লক্ষ্য মুছুন',
    confirmDeleteGoal: 'আপনি কি নিশ্চিত যে "%s" মুছতে চান?',
    addSavingGoal: 'সঞ্চয় লক্ষ্য যোগ করুন',
    editSavingGoal: 'সঞ্চয় লক্ষ্য সম্পাদনা করুন',
    savingGoalPurpose: 'সঞ্চয় লক্ষ্যের উদ্দেশ্য',
    savingGoalHint: 'যেমন নতুন গাড়ির জন্য সঞ্চয়...',
    description: 'বিবরণ',
    descriptionHint: 'বিবরণ লিখুন (ঐচ্ছিক)',
    amountHint: '0.00',
    pleaseEnterPositiveAmount: 'অনুগ্রহ করে একটি ধনাত্মক পরিমাণ লিখুন',
    pleaseEnterSavingGoalName: 'অনুগ্রহ করে একটি সঞ্চয় লক্ষ্যের নাম লিখুন',
    saveGoal: 'লক্ষ্য সংরক্ষণ করুন',
    goalCreated: 'লক্ষ্য "%s" তৈরি হয়েছে!',
    goalUpdated: 'লক্ষ্য "%s" আপডেট হয়েছে!',
    errorSavingGoal: 'লক্ষ্য সংরক্ষণে ত্রুটি। অনুগ্রহ করে আবার চেষ্টা করুন।',
    mySavingGoals: 'আমার সঞ্চয় লক্ষ্য',
    newGoal: 'নতুন লক্ষ্য',
    loadingGoals: 'আপনার লক্ষ্য লোড হচ্ছে...',
    noSavingGoals: 'এখনো কোনো সঞ্চয় লক্ষ্য নেই',
    createFirstGoal: 'আপনার প্রথম লক্ষ্য তৈরি করুন',
    totalSavingsProgress: 'মোট সঞ্চয় অগ্রগতি',
    percentComplete: '%s% সম্পন্ন',
    savingsOfTarget: '%s এর মধ্যে %s',
    deleteGoalQuestion: 'লক্ষ্য মুছবেন?',
    confirmDeleteGoalPermanent: 'এটি "%s" স্থায়ীভাবে মুছে ফেলবে',
    addedToSavings: '"%s" এ %s যোগ করা হয়েছে',
    goalDeleted: '"%s" মুছে ফেলা হয়েছে',
    goalWasDeleted: 'লক্ষ্য মুছে ফেলা হয়েছে',
    amountGreaterThanZero: 'অনুগ্রহ করে শূন্যের চেয়ে বেশি পরিমাণ লিখুন',
    couldNotAddSavings: 'সঞ্চয় যোগ করা যায়নি',
    couldNotDeleteGoal: 'লক্ষ্য মুছে ফেলা যায়নি',
    goalsRefreshed: 'লক্ষ্য পুনরায় নিশ্চিত',
    aboutSavingGoals: 'লক্ষ্য নির্ধারণ সম্পর্কে',
    trackProgress: 'আপনার লক্ষ্যের অগ্রগতি দেখুন',
    trackProgressDescription: 'লক্ষ্য অগ্রগতি বিবরণ',
    addMoneyAnytime: 'যেকোনো সময় অর্থ যোগ করুন',
    addMoneyAnytimeDescription:
    'যখনই আপনি অর্থ সঞ্চয় করেন তখন আপনার লক্ষ্যে অবদান রাখুন',
    setTargetDates: 'লক্ষ্য তারিখ নির্ধারণ করুন',
    setTargetDatesDescription: 'স্পষ্ট সময়সীমা দিয়ে অনুপ্রাণিত থাকুন',
    gotIt: 'বুঝেছি',
    addExpense: 'খরচ যোগ করুন',
    editExpense: 'খরচ সম্পাদনা করুন',
    addIncome: 'আয় যোগ করুন',
    editIncome: 'আয় সম্পাদনা করুন',
    category: 'বিভাগ',
    date: 'তারিখ',
    pleaseEnterValidAmount: 'অনুগ্রহ করে একটি বৈধ পরিমাণ লিখুন',
    pleaseSelectCategory: 'অনুগ্রহ করে একটি বিভাগ নির্বাচন করুন',
    transactionSaved: 'লেনদেন সফলভাবে সংরক্ষিত হয়েছে',
    transactionUpdated: 'লেনদেন সফলভাবে আপডেট হয়েছে',
    failedToSaveTransaction:
    'লেনদেন সংরক্ষণ করতে ব্যর্থ হয়েছে। আবার চেষ্টা করুন।',
    food: 'খাদ্য',
    transport: 'পরিবহন',
    utilities: 'ইউটিলিটিস',
    entertainment: 'বিনোদন',
    shopping: 'কেনাকাটা',
    health: 'স্বাস্থ্য',
    others: 'অন্যান্য',
    salary: 'বেতন',
    investment: 'বিনিয়োগ',
    business: 'ব্যবসা',
    gift: 'উপহার',
    noTransactionsYet: 'এখনো কোনো লেনদেন নেই',
    today: 'আজ',
    yesterday: 'গতকাল',
    dashboardHelpTitle: 'ড্যাশবোর্ড কীভাবে ব্যবহার করবেন',
    dashboardHelpSubtitle: 'আপনার আর্থিক সহজে ট্র্যাক করুন',
    dashboardHelpBalance:
    'আপনার বর্তমান হিসাব নিকাশ , আয় এবং খরচ এক নজরে দেখুন',
    dashboardHelpAddTransaction: '+ ব্যবহার করে নতুন লেনদেন যোগ করুন',
    dashboardHelpDeleteTransaction: 'লেনদেন মুছে ফেলতে বাম দিকে সোয়াইপ করুন',
    dashboardHelpSpendingPatterns:
    'সাপ্তাহিক খরচের ধরণ এবং শ্রেণী বিন্যাস পর্যবেক্ষণ করুন',
    dashboardHelpRefresh: 'আপনার আর্থিক তথ্য রিফ্রেশ করতে নিচে টানুন',
    total: 'মোট',
    noExpenseData: 'এই সময়ের জন্য কোনো খরচ তথ্য নেই',
    noIncomeData: 'এই সময়ের জন্য কোনো আয় তথ্য নেই',
    pagination: 'পৃষ্ঠা %d এর %d',
    hideAssistant: 'সহকারী লুকান',
    askAboutChart: 'এই চার্ট সম্পর্কে জিজ্ঞাসা করুন',
    askAboutChartHint: 'এই চার্ট সম্পর্কে জিজ্ঞাসা করুন...',
    assistant: 'সহকারী',
    queryError: 'দুঃখিত, আমি সেই প্রশ্নটি প্রক্রিয়া করতে পারিনি।',
    queryErrorWithMessage: 'দুঃখিত, একটি ত্রুটি ঘটেছে: %s',
    chartContext:
    'আমি একটি %s চার্ট দেখছি যা আমার %s তথ্য দেখাচ্ছে। চার্ট তথ্য: %s।',
    queryPrompt:
    'আপনি একজন সহায়ক আর্থিক সহকারী। চার্ট তথ্য সম্পর্কে নিম্নলিখিত প্রশ্নের উত্তর দিন। আপনার উত্তর সংক্ষিপ্ত (১০০ শব্দের নিচে) এবং চার্ট তথ্যর উপর কেন্দ্রীভূত রাখুন। যদি প্রদত্ত তথ্য থেকে উত্তর দিতে না পারেন, তা স্পষ্টভাবে বলুন। চার্ট প্রেক্ষাপট: %s প্রশ্ন: %s',
    advancedQuizTitle: 'উন্নত কুইজ',
    quizCompleted: 'কুইজ সম্পন্ন!',
    quizScore: 'আপনার স্কোর: %s/%s',
    quizFinish: 'শেষ',
    quizTryAgain: 'আবার চেষ্টা করুন',
    quizQuestion1: 'চক্রবৃদ্ধি সুদের প্রধান সুবিধা কী?',
    quizQuestion1Answer1: 'টাকা সময়ের সাথে দ্রুত বৃদ্ধি পায়',
    quizQuestion1Answer2: 'এটি আপনার কর হ্রাস করে',
    quizQuestion1Answer3: 'এটি নিয়মিত সুদের চেয়ে নিরাপদ',
    quizQuestion2: 'বিনিয়োগে বৈচিত্র্যকরণ বলতে কী বোঝায়?',
    quizQuestion2Answer1: 'সব টাকা একটি স্টকে রাখা',
    quizQuestion2Answer2: 'বিভিন্ন সম্পদে বিনিয়োগ ছড়িয়ে দেওয়া',
    quizQuestion2Answer3: 'শুধুমাত্র যা জানেন তাতে বিনিয়োগ করা',
    quizQuestion3: 'ইনডেক্স ফান্ডের মূল বৈশিষ্ট্য কী?',
    quizQuestion3Answer1: 'উচ্চ ব্যবস্থাপনা ফি',
    quizQuestion3Answer2: 'একটি নির্দিষ্ট বাজার সূচক ট্র্যাক করে',
    quizQuestion3Answer3: 'গ্যারান্টিযুক্ত রিটার্ন',
    quizQuestion4: '4% অবসর নিয়ম কী?',
    quizQuestion4Answer1: 'অবসরে বছরে 4% সঞ্চয় উত্তোলন করা',
    quizQuestion4Answer2: 'অবসরের জন্য আয়ের 4% সঞ্চয় করা',
    quizQuestion4Answer3: 'পরিকল্পিত সময়ের চেয়ে 4% বেশি কাজ করা',
    quizQuestion5: 'আয় সুরক্ষার জন্য কোন ধরনের বীমা সবচেয়ে গুরুত্বপূর্ণ?',
    quizQuestion5Answer1: 'ভ্রমণ বীমা',
    quizQuestion5Answer2: 'আয় সুরক্ষা বীমা',
    quizQuestion5Answer3: 'পোষা প্রাণীর বীমা',
    advancedScreenTitle: 'উন্নত আর্থিক দক্ষতা',
    investmentBasicsTitle: 'বিনিয়োগের মৌলিক বিষয়',
    investmentBasicsPoint1: 'স্টক এবং বন্ড বোঝা',
    investmentBasicsPoint2: 'ঝুঁকি বনাম রিটার্ন নীতি',
    investmentBasicsPoint3: 'বৈচিত্র্যকরণ কৌশল',
    retirementPlanningTitle: 'অবসর পরিকল্পনা',
    retirementPlanningPoint1: 'সুপারঅ্যানুয়েশন বোঝা',
    retirementPlanningPoint2: 'চক্রবৃদ্ধি সুদের শক্তি',
    retirementPlanningPoint3: 'অবসর সঞ্চয় লক্ষ্য',
    insuranceProtectionTitle: 'বীমা ও সুরক্ষা',
    insuranceProtectionPoint1: 'প্রয়োজনীয় বীমার ধরন',
    insuranceProtectionPoint2: 'কভারেজ প্রয়োজন গণনা',
    insuranceProtectionPoint3: 'খরচ এবং সুরক্ষার ভারসাম্য',
    takeAdvancedQuiz: 'উন্নত কুইজ নিন',
    beginnerQuizTitle: 'প্রাথমিক কুইজ',
    beginnerQuizQuestion1: 'টাকা পরিচালনার প্রথম ধাপ কী?',
    beginnerQuizQuestion1Answer1: 'আপনার উপার্জনের সবকিছু খরচ করুন',
    beginnerQuizQuestion1Answer2: 'আপনার আয় এবং খরচ ট্র্যাক করুন',
    beginnerQuizQuestion1Answer3: 'স্টকে বিনিয়োগ করুন',
    beginnerQuizQuestion2: 'কোনটি "চাহিদা" এবং কোনটি "ইচ্ছা" নয়?',
    beginnerQuizQuestion2Answer1: 'নতুন স্মার্টফোন',
    beginnerQuizQuestion2Answer2: 'মুদি',
    beginnerQuizQuestion2Answer3: 'ছুটি',
    beginnerQuizQuestion3: 'আপনার আয় থেকে আদর্শভাবে কতটা সঞ্চয় করা উচিত?',
    beginnerQuizQuestion3Answer1: '5%',
    beginnerQuizQuestion3Answer2: '20%',
    beginnerQuizQuestion3Answer3: '50%',
    beginnerScreenTitle: 'প্রাথমিক আর্থিক দক্ষতা',
    understandingMoneyTitle: 'টাকা বোঝা',
    understandingMoneyPoint1: 'টাকা কী এবং এটি কীভাবে কাজ করে',
    understandingMoneyPoint2: 'টাকার বিভিন্ন প্রকার (নগদ, ডিজিটাল)',
    understandingMoneyPoint3: 'মৌলিক চাহিদা বনাম ইচ্ছা',
    simpleBudgetingTitle: 'সাধারণ বাজেটিং',
    simpleBudgetingPoint1: 'দৈনিক খরচ ট্র্যাক করা',
    simpleBudgetingPoint2: '50-30-20 নিয়ম সরলীকৃত',
    simpleBudgetingPoint3: 'নিয়মিতভাবে অল্প পরিমাণ সঞ্চয় করা',
    bankAccountsTitle: 'ব্যাংক অ্যাকাউন্ট',
    bankAccountsPoint1: 'ব্যাংক অ্যাকাউন্টের প্রকার',
    bankAccountsPoint2: 'টাকা জমা এবং উত্তোলনের পদ্ধতি',
    bankAccountsPoint3: 'ব্যাংক স্টেটমেন্ট বোঝা',
    takeBeginnerQuiz: 'প্রাথমিক কুইজ নিন',
    resourceError: 'রিসোর্স খুলতে ব্যর্থ: %s',
    intermediateQuizTitle: 'মধ্যবর্তী কুইজ',
    intermediateQuizQuestion1: 'জরুরি তহবিলের উদ্দেশ্য কী?',
    intermediateQuizQuestion1Answer1: 'ছুটির জন্য অর্থ প্রদান করা',
    intermediateQuizQuestion1Answer2: 'অপ্রত্যাশিত খরচ কভার করা',
    intermediateQuizQuestion1Answer3: 'স্টকে বিনিয়োগ করা',
    intermediateQuizQuestion2:
    '50-30-20 নিয়মে আপনার আয়ের কত শতাংশ চাহিদার জন্য খরচ করা উচিত?',
    intermediateQuizQuestion2Answer1: '20%',
    intermediateQuizQuestion2Answer2: '30%',
    intermediateQuizQuestion2Answer3: '50%',
    intermediateQuizQuestion3: 'একটি ভাল ক্রেডিট স্কোরের পরিসীমা কী?',
    intermediateQuizQuestion3Answer1: '300-500',
    intermediateQuizQuestion3Answer2: '670-850',
    intermediateQuizQuestion3Answer3: '100-300',
    intermediateQuizQuestion4: 'ঋণ থেকে মুক্তি পাওয়ার প্রথম ধাপ কী?',
    intermediateQuizQuestion4Answer1:
    'এটি উপেক্ষা করুন এবং আশা করুন এটি চলে যাবে',
    intermediateQuizQuestion4Answer2: 'একটি ঋণ পরিশোধ পরিকল্পনা তৈরি করুন',
    intermediateQuizQuestion4Answer3: 'এটি পরিশোধের জন্য আরও ঋণ নিন',
    intermediateScreenTitle: 'মধ্যবর্তী আর্থিক দক্ষতা',
    advancedBudgetingTitle: 'উন্নত বাজেটিং',
    advancedBudgetingPoint1: 'মাসিক বাজেট পরিকল্পনা তৈরি করা',
    advancedBudgetingPoint2: 'আর্থিক লক্ষ্য নির্ধারণ',
    advancedBudgetingPoint3: 'অনিয়মিত আয় পরিচালনা',
    creditBasicsTitle: 'ক্রেডিট মৌলিক বিষয়',
    creditBasicsPoint1: 'ক্রেডিট স্কোর বোঝা',
    creditBasicsPoint2: 'দায়িত্বশীল ক্রেডিট কার্ড ব্যবহার',
    creditBasicsPoint3: 'ঋণের ফাঁদ এড়ানো',
    savingStrategiesTitle: 'সঞ্চয় কৌশল',
    savingStrategiesPoint1: 'জরুরি তহবিল (3-6 মাস)',
    savingStrategiesPoint2: 'বড় ক্রয়ের জন্য সঞ্চয়',
    savingStrategiesPoint3: 'আপনার সঞ্চয় স্বয়ংক্রিয় করা',
    takeIntermediateQuiz: 'মধ্যবর্তী কুইজ নিন',
    quizHomeTitle: 'আর্থিক জ্ঞান কুইজ',
    beginnerLevelQuiz: 'প্রাথমিক স্তরের কুইজ',
    intermediateLevelQuiz: 'মধ্যবর্তী স্তরের কুইজ',
    advancedLevelQuiz: 'উন্নত স্তরের কুইজ',
    transactionAddedSuccess: 'লেনদেন সফলভাবে যোগ করা হয়েছে',
    transactionCanceled: 'কোন সমস্যা নেই, আমি এই লেনদেন যোগ করব না।',
    transactionAddError:
    'দুঃখিত, আমি লেনদেন যোগ করতে পারিনি। অনুগ্রহ করে পরে আবার চেষ্টা করুন।',
    transactionConfirmPrompt:
    'আমি নিশ্চিত নই আপনি এই লেনদেনের সাথে কী করতে চান। আমাকে বিকল্পগুলি দেখাতে দিন।',
    transactionNoPending:
    'এই মুহূর্তে আমার কাছে নিশ্চিত করার জন্য কোন লেনদেন নেই।',
    chatbotHelpTitle: 'ফিনি এআই কীভাবে ব্যবহার করবেন',
    chatbotHelpSubtitle: 'আপনার ব্যক্তিগত আর্থিক সহকারী',
    chatbotHelpInstruction1:
    'তাত্ক্ষণিক পরামর্শের জন্য আর্থিক সম্পর্কিত প্রশ্ন জিজ্ঞাসা করুন',
    chatbotHelpInstruction2: 'বিশ্লেষণের জন্য আর্থিক ছবি আপলোড করুন',
    chatbotHelpInstruction3:
    'আপনি এআই সহকারীর সাথে কথা বলার জন্য মাইক্রোফোন ব্যবহার করতে পারেন',
    chatbotHelpInstruction4:
    'প্রস্তাবিত প্রশ্নগুলি চেষ্টা করুন বা নিজের প্রশ্ন টাইপ করুন',
    welcomeTryAsking: 'জিজ্ঞাসা করে দেখুন',
    welcomeWriteQuestion: 'নিজের প্রশ্ন লিখুন',
    voiceListening: 'কণ্ঠস্বর শোনা যাচ্ছে... শেষ হলে আবার ট্যাপ করুন',
    voiceProcessing: 'কণ্ঠস্বর প্রক্রিয়াকরণ...',
    voiceTapMic: 'ফিনি এআই-এর সাথে কথা বলতে মাইক্রোফোন ট্যাপ করুন',
    voiceSttNotAvailable: 'এই ডিভাইসে স্পিচ রিকগনিশন উপলব্ধ নয়',
    transactionPreviewTitle: 'লেনদেনের শিরোনাম',
    transactionPreviewCancel: 'বাতিল',
    transactionPreviewConfirm: 'নিশ্চিত করুন',
    chatInputHint: 'আমাকে একটি আর্থিক প্রশ্ন জিজ্ঞাসা করুন...',
    nonFinancialQuestion:
    'আমি আপনার আর্থিক প্রশ্নগুলির সাথে সাহায্য করতে এখানে আছি। কোন অর্থের বিষয়ে আমি সহায়তা করতে পারি?',
    nonFinancialImage:
    'আমি কেবল আর্থিক নথি বা রসিদ বিশ্লেষণ করতে পারি। আর্থিক কিছু নিয়ে সাহায্য প্রয়োজন?',
    addNew: 'Add New',
    categorySpentAmount: '%s টাকা %s শ্রেণী থেকে খরচ হয়েছে (%s%%)',
    categoryEarnedAmount: '%s টাকা %s শ্রেণী থেকে আয় হয়েছে (%s%%)',
    'expenseSummary':
    'মোট খরচ হয়েছে %s, গড়ে %s। সর্বোচ্চ খরচ হয়েছে %s %s তারিখে, এবং সর্বনিম্ন খরচ হয়েছে %s %s তারিখে।',
    'incomeSummary':
    'মোট আয় হয়েছে %s, গড়ে %s। সর্বোচ্চ আয় হয়েছে %s %s তারিখে, এবং সর্বনিম্ন আয় হয়েছে %s %s তারিখে।',
    'expenseCategorySummary':
    'সর্বোচ্চ খরচ হয়েছে %s শ্রেণী থেকে , যা %s (%s%%)।',
    'incomeCategorySummary':
    'সর্বোচ্চ আয় হয়েছে %s শ্রেণী থেকে, যা %s (%s%%)।',
    saveHabitTitle: 'সেভিং এর অভ্যাস গড়ে তোলা',
    saveHabitDesc:
    'নিয়মিত টাকা জমানো স্মার্ট একটি অভ্যাস। খরচ করার আগে সেভিং প্ল্যান করা সবচেয়ে ভালো উপায়।',
    saveWhyTitle: 'সেভিং কেন জরুরি?',
    saveWhyDesc:
    'ইমারজেন্সির জন্য টাকা জমিয়ে রাখা খুব দরকারি। বেতন পাওয়ার পরেই কিছু অংশ আলাদা রাখলে ভবিষ্যৎ নিরাপদ লাগে।',
    budgetSmartTitle: 'বুদ্ধিমান মাসিক আয়ের বন্টন',
    budgetSmartDesc:
    'আয়ের ৫৫% প্রয়োজনের জন্য, ১০% দীর্ঘমেয়াদী বিনিয়োগের জন্য, ১০% ভবিষ্যতের লক্ষ্য পূরণের জন্য, ১০% নিজের দক্ষতা বাড়াতে এবং ১৫% মজা বা দান করার জন্য ব্যয় করুন।',
    budgetSelfTitle: 'নিজের উপর বিনিয়োগ সবচেয়ে বেশি ফল দেয়',
    budgetSelfDesc:
    '১০,০০০ টাকা দিয়ে ব্যবসা শুরু করার বদলে নিজের স্কিল উন্নত করুন। বই পড়ুন, অনলাইন কোর্স করুন এবং আপনার জ্ঞান দিয়ে উপার্জনের উপায় খুঁজুন।',

    spendManageTitle: 'টাকা পরিচালনা, বৃদ্ধি, বিনিয়োগ ও সুরক্ষা দিন',
    spendManageDesc:
    'আপনার আয় যতই হোক না কেন, যদি আপনি তা ভালোভাবে পরিচালনা করেন, বাড়ান, বিনিয়োগ করেন এবং সুরক্ষা দেন — ভবিষ্যৎ নিশ্চিত থাকবে।',
    spendLandTitle: 'স্মার্ট বিনিয়োগ: জমি কিনুন',
    spendLandDesc:
    'জমি একটি নিরাপদ ও লাভজনক বিনিয়োগ। কেনার আগে কাগজপত্র ও লোকেশন যাচাই করুন। এটি ফ্ল্যাট বা ক্রিপ্টোর চেয়ে বেশি ফ্লেক্সিবল।',
    coachQ1: 'টাকা ব্যবস্থাপনায় আপনি কতটা ভালো? বস লেভেল, নাকি এখনও শিখছেন?',
    coachQ2: 'সাধারণত আপনি মাসে কত টাকা সঞ্চয় করেন?',
    coachQ3: 'আপনি মাসে সাধারণত কত খরচ করেন?',
    coachQ4: 'সেরা পরিস্থিতিতে, আপনি মাসে কত সঞ্চয় করতে চাইতেন?',
    coachQ5: 'আপনি কি প্রয়োজন আর ইচ্ছার মধ্যে পার্থক্য সহজে করতে পারেন?',
    coachQ6: 'কোন খাতে আপনার সবচেয়ে বেশি টাকা চলে যায়?',
    coachQ7: 'আপনি কি আপনার খরচ কোথায় যায় সেটা ট্র্যাক করেন?',
    coachQ8: 'আপনি কি আপনার খরচের অভ্যাস বদলাতে ইচ্ছুক?',
    coachQ9: 'আপনি কি প্রায়ই প্ল্যান ছাড়া খরচ করেন?',
    coachQ10: 'এক্সট্রা টাকা পেলে আপনি সঞ্চয় করেন না খরচ?',
    coachQ11:
    'আপনি কি বড় কোনো লক্ষ্য পূরণের জন্য সঞ্চয় করতে চান, নাকি এখনই ছোট আনন্দ উপভোগ করতে চান?',
    coachSavingSmall:
    'আপনি কম সঞ্চয় করছেন। একটু একটু করে সঞ্চয় বাড়ানোর চেষ্টা করুন! ',
    coachOnYourWay: 'আপনি সঠিক পথে আছেন! সঞ্চয়ের অভ্যাস গড়ে তুলুন। ',
    coachPraiseGreat: 'অসাধারণ! আপনি অনেক সঞ্চয় করছেন। ',
    never: 'কখনোই না',
    sometimes: 'মাঝে মাঝে',
    no: 'না',
    maybe: 'হয়তো',
    coachAdviceTitle: 'আপনার সেভিংস কোচের পরামর্শ',
    coachOptBoth: 'দুটোই একটু একটু',
    coachOptSaveBig: 'বড় লক্ষ্য পূরণের জন্য সঞ্চয়',
    coachOptTreats: 'এখনই একটু মজা',
    coachPraiseHabit: 'চমৎকার সঞ্চয়ের অভ্যাস!',
    coachRestart: 'সেভিং কোচ আবার শুরু করুন',
    learnReset: 'লার্নিং অগ্রগতি রিসেট হয়েছে।',
    learnNoResults: 'কোনও ফলাফল পাওয়া যায়নি।',
    learningReset: 'লার্নিং অগ্রগতি রিসেট হয়েছে।',
    learningHub: 'লার্নিং হাব',
    ongoing: 'চলমান',
    completed: 'সম্পন্ন',
    noResultsFound: 'কোনও ফলাফল পাওয়া যায়নি।',
    tourBudgetTitle: 'বাজেটের মধ্যে থাকুন',
    tourBudgetDesc:
    'খরচ সীমার মধ্যে থাকতে এবং অপ্রয়োজনীয় খরচ এড়াতে রিমাইন্ডার কীভাবে ব্যবহার করবেন তা শিখুন।',

    tourChatbotTitle: 'এআই চ্যাট সহকারী',
    tourChatbotDesc:
    'চ্যাটবট কীভাবে আর্থিক প্রশ্নের উত্তর দেয় এবং অ্যাপে সাহায্য করে তা বুঝুন।',

    tourDashboardTitle: 'ড্যাশবোর্ড পরিচিতি',
    tourDashboardDesc:
    'ড্যাশবোর্ড কীভাবে ব্যবহার করবেন এবং আপনার আর্থিক অবস্থা বুঝতে মূল তথ্য কোথায় তা শিখুন।',

    tourExpenseTitle: 'খরচ ট্র্যাক করুন',
    tourExpenseDesc:
    'প্রতিদিনের খরচ কীভাবে রেকর্ড এবং পর্যবেক্ষণ করবেন তা দেখুন যাতে বেশি খরচ না হয়।',

    tourLearnHubDesc:
    'Get an overview of the main LearnHub content and how to navigate through lessons.',
    tourLearnhubTitle: 'লার্নহাব মডিউল পরিচিতি',
    tourLearnhubDesc:
    'LearnHub মডিউলগুলোর সংক্ষিপ্ত পরিচিতি এবং কিভাবে পাঠগুলো ব্যবহার করবেন তা দেখুন।',
    tourReportDesc:
    'আপনার আর্থিক রিপোর্ট কীভাবে পড়বেন এবং বোঝাবেন তা শিখুন যাতে ভালো সিদ্ধান্ত নিতে পারেন।',
    tourReportTitle: 'রিপোর্ট পরিচিতি',

    tourSavingsTitle: 'সঞ্চয়ের লক্ষ্য নির্ধারণ',
    tourSavingsDesc:
    'অ্যাপের ফিচার ব্যবহার করে কীভাবে সঞ্চয়ের লক্ষ্য নির্ধারণ, ট্র্যাক এবং অর্জন করবেন তা শিখুন।',

    tourSettingsTitle: 'সেটিংস পরিচিতি',
    tourSettingsDesc:
    'ভাষা, নোটিফিকেশন এবং অন্যান্য সেটিংস কাস্টমাইজ করতে কীভাবে অ্যাপ সেটিংস আপডেট করবেন তা শিখুন।',

    tourMarkDone: 'সম্পন্ন হিসেবে চিহ্নিত করুন',
    generalQuizTitle: 'আপনার জ্ঞান পরীক্ষা করুন',
    quizResultScore: 'স্কোর: %s / %s',
    quizBack: 'কুইজে ফিরে যান',
    quizReview: 'আপনার উত্তরগুলো পর্যালোচনা করুন',
    quizClearConfirm: 'আপনি কি নিশ্চিত যে সব কুইজ ফলাফল মুছে ফেলতে চান?',
    quizNoResults: 'কোন কুইজ ফলাফল পাওয়া যায়নি।',
    quizResults: 'কুইজ ফলাফল',
    quizReset: 'কুইজ ফলাফল রিসেট করুন',
    quizResetConfirm:
    'আপনি কি সমস্ত কুইজ ফলাফল মুছে ফেলতে চান? এই পদক্ষেপটি পূর্বাবস্থায় ফেরানো যাবে না।',
    reset: 'রিসেট',
    quizAttempts: 'চেষ্টা',
    quizAverage: 'গড়',
    quizLastAttempt: 'সর্বশেষ চেষ্টা',
    quizQ1: 'Finney অ্যাপের মূল কাজ কী?',
    quizQ1A1: 'গেম খেলা',
    quizQ1A2: 'সামাজিক যোগাযোগ',
    quizQ1A3: 'আর্থিক শিক্ষা',
    quizQ1A4: 'অনলাইন শপিং',
    quizQ2: 'খরচ ট্র্যাক করতে কোন স্ক্রিন সাহায্য করে?',
    quizQ2A1: 'ড্যাশবোর্ড',
    quizQ2A2: 'চ্যাটবট',
    quizQ2A3: 'লার্ন',
    quizQ2A4: 'সেটিংস',
    quizQ3: 'বাজেট সাধারণত কী কাজে লাগে?',
    quizQ3A1: 'খরচ ট্র্যাক করা',
    quizQ3A2: 'বিনোদন',
    quizQ3A3: 'ক্রিপ্টোতে বিনিয়োগ',
    quizQ3A4: 'মুদির বাজার',
    quizQ4: 'ভাড়া সাধারণত কোন বিভাগের অন্তর্ভুক্ত?',
    quizQ4A1: 'সঞ্চয়',
    quizQ4A2: 'প্রয়োজন',
    quizQ4A3: 'want',
    quizQ4A4: 'বিলাসিতা',
    quizQ5: 'স্মার্ট খরচের একটি টিপস কী হতে পারে?',
    quizQ5A1: 'অপ্রয়োজনীয় জিনিস কেনা',
    quizQ5A2: 'প্রতিটি টাকা ট্র্যাক করা',
    quizQ5A3: 'ছাড় এড়ানো',
    quizQ5A4: 'ঝোঁকের বশে খরচ করা',
    quizQ6: 'অপ্রত্যাশিত কেনাকাটার আগে ২৪ ঘণ্টা অপেক্ষা করা কেন ভালো?',
    quizQ6A1: 'দোকান বন্ধ হয়ে যেতে পারে',
    quizQ6A2: 'ঝোঁকের খরচ এড়াতে সাহায্য করে',
    quizQ6A3: 'দাম কমতে পারে',
    quizQ6A4: 'আপনি হয়তো টাকা পাবেন',
    quizQ7: 'বাজেটিংয়ে "want" বলতে কী বোঝায়?',
    quizQ7A1: 'প্রয়োজনীয় খাবার',
    quizQ7A2: 'ভাড়া',
    quizQ7A3: 'চিকিৎসা খরচ',
    quizQ7A4: 'ডিজাইনার স্নিকার্স',
    quizQ8: 'আয় বাড়ানোর জন্য কোনটি সহায়ক?',
    quizQ8A1: 'খাবার মিস করা',
    quizQ8A2: 'দক্ষতা উন্নয়ন',
    quizQ8A3: 'বেশি খরচ করা',
    quizQ8A4: 'ঋণ নেওয়া',
    quizQ9: '৫০-৩০-২০ নিয়মটি সাধারণত কোন ক্ষেত্রে ব্যবহার হয়?',
    quizQ9A1: 'খাবার পরিকল্পনা',
    quizQ9A2: 'কাজের সময়',
    quizQ9A3: 'বাজেট তৈরি',
    quizQ9A4: 'ব্যায়ামের রুটিন',
    quizQ10: 'খরচ করার আগে কী করা উচিত?',
    quizQ10A1: 'ট্রেন্ড চেক করা',
    quizQ10A2: 'সোশ্যাল মিডিয়াতে পোস্ট করা',
    quizQ10A3: 'একটি বাজেট প্ল্যান তৈরি করা',
    quizQ10A4: 'বন্ধুর কাছ থেকে ধার নেওয়া',
    quizQ11: 'Finney অ্যাপ অনুযায়ী কোথায় বিনিয়োগ করা সবচেয়ে নিরাপদ?',
    quizQ11A1: 'ক্রিপ্টো',
    quizQ11A2: 'জমি',
    quizQ11A3: 'ফরেক্স',
    quizQ11A4: 'এনএফটি',
    quizQ12: 'বাসায় রান্না করার কী উপকারিতা আছে?',
    quizQ12A1: 'বেশি প্লাস্টিক বর্জ্য',
    quizQ12A2: 'বেশি ডেলিভারি খরচ',
    quizQ12A3: 'টাকা বাঁচায় এবং স্বাস্থ্য ভালো রাখে',
    quizQ12A4: 'বেশি সময় লাগে',
    quizQ13: 'মাসের শুরুতেই সঞ্চয় করাটা কেন গুরুত্বপূর্ণ?',
    quizQ13A1: 'অপ্রয়োজনীয় কেনাকাটা এড়াতে',
    quizQ13A2: 'যাতে বাজেট না করলেও চলে',
    quizQ13A3: 'আর্থিক নিয়মানুবর্তিতা গড়ে তুলতে',
    quizQ13A4: 'জরিমানা আগেই মেটাতে',
    quizQ14: 'পার্সোনাল ডেভেলপমেন্টে কত শতাংশ রাখা উচিত?',
    quizQ14A1: '৫৫%',
    quizQ14A2: '১৫%',
    quizQ14A3: '৩০%',
    quizQ14A4: '১০%',
    quizQ15: '"টাকা প্রোটেক্ট" বলতে কী বোঝায়?',
    quizQ15A1: 'গ্যাজেটে খরচ',
    quizQ15A2: 'সব ঝুঁকি এড়ানো',
    quizQ15A3: 'বীমা ও জরুরি ফান্ড ব্যবহার',
    quizQ15A4: 'সোনা কেনা',
    quizQ16: 'একটি আর্থিক লক্ষ্য স্থির করার প্রথম ধাপ কী?',
    quizQ16A1: 'মন মতো খরচ করা',
    quizQ16A2: 'সঞ্চয়ের লক্ষ্য নির্ধারণ করা',
    quizQ16A3: 'অনলাইন শপিং',
    quizQ16A4: 'ঋণ নেওয়া',
    quizQ17: 'Finney অ্যাপে কোন ফিচারটি তাৎক্ষণিক আর্থিক সহায়তা দেয়?',
    quizQ17A1: 'সেটিংস',
    quizQ17A2: 'চ্যাটবট',
    quizQ17A3: 'খরচ ট্র্যাকার',
    quizQ17A4: 'প্রোফাইল',
    quizQ18: 'জরুরি তহবিল সাধারণত কোন কাজে ব্যবহৃত হয়?',
    quizQ18A1: 'ছুটি',
    quizQ18A2: 'অপ্রত্যাশিত খরচ',
    quizQ18A3: 'বিনোদন',
    quizQ18A4: 'শপিং',
    quizQ19: 'ভালো সঞ্চয় অভ্যাস কাকে বলা হয়?',
    quizQ19A1: 'ঝোঁকের কেনাকাটা',
    quizQ19A2: 'খরচ ট্র্যাক করা',
    quizQ19A3: 'বিল উপেক্ষা করা',
    quizQ19A4: 'অতিরিক্ত খরচ',
    quizQ20:
    'আপনি যদি ২০০০০ টাকা আয় করেন এবং ১৮০০০ টাকা খরচ করেন, আপনার সঞ্চয় কত হবে?',
    quizQ20A1: '৫০০০',
    quizQ20A2: '৩০০০',
    quizQ20A3: '২০০০',
    quizQ20A4: '১০০০',
    quizQ21: 'আর্থিক চাপ সাধারণত কী কারণে হয়?',
    quizQ21A1: 'অতিরিক্ত খরচ',
    quizQ21A2: 'নিয়মিত সঞ্চয়',
    quizQ21A3: 'বাজেট মেনে চলা',
    quizQ21A4: 'বীমা থাকা',
    quizQ22: 'কখন সঞ্চয় শুরু করা সবচেয়ে ভালো?',
    quizQ22A1: 'মাসের শেষ',
    quizQ22A2: 'আয়ের পরে',
    quizQ22A3: 'খরচের পরে',
    quizQ22A4: 'ঋণ নিলে',
    quizQ23: 'বাজেটিং কিভাবে সাহায্য করে?',
    quizQ23A1: 'বেশি খরচ করা',
    quizQ23A2: 'টাকা ভালোভাবে ম্যানেজ করা',
    quizQ23A3: 'সঞ্চয় হারানো',
    quizQ23A4: 'জুয়া খেলা',
    quizQ24: 'নিচের কোনটি একটি "প্রয়োজনীয়" খরচ?',
    quizQ24A1: 'নেটফ্লিক্স সাবস্ক্রিপশন',
    quizQ24A2: 'মুদির বাজার',
    quizQ24A3: 'লাক্সারি গাড়ি',
    quizQ24A4: 'ডিজাইনার ঘড়ি',
    quizQ25: 'বিনিয়োগের আগে কী বিষয় যাচাই করা উচিত?',
    quizQ25A1: 'জনপ্রিয়তা',
    quizQ25A2: 'ঝুঁকি ও রিটার্ন',
    quizQ25A3: 'লাইকের সংখ্যা',
    quizQ25A4: 'ব্র্যান্ড নাম',
    quizQ26: 'ঝোঁকের কেনাকাটা কমানোর উপায় কী?',
    quizQ26A1: 'ক্রেডিট কার্ড ব্যবহার',
    quizQ26A2: 'শপিং লিস্ট ব্যবহার',
    quizQ26A3: 'বিজ্ঞাপন অনুসরণ',
    quizQ26A4: 'মুডের উপর ভিত্তি করে কেনাকাটা',
    quizQ27: 'একটি ভালো আর্থিক লক্ষ্য কেমন হওয়া উচিত?',
    quizQ27A1: 'অস্পষ্ট ও দূরের',
    quizQ27A2: 'নির্দিষ্ট ও পরিমাপযোগ্য',
    quizQ27A3: 'দামী ও দ্রুত',
    quizQ27A4: 'ভাগ্যনির্ভর ও এলোমেলো',
    quizQ28: 'সঞ্চয় করা কী কাজে আসে?',
    quizQ28A1: 'দেখানোর জন্য',
    quizQ28A2: 'নিরাপত্তা তৈরি',
    quizQ28A3: 'অপ্রয়োজনীয় জিনিসপত্র কেনা',
    quizQ28A4: 'দ্রুত খরচ',
    quizQ29: 'Finney অ্যাপের কোন অংশ অর্থনৈতিক দক্ষতা বাড়াতে সাহায্য করে?',
    quizQ29A1: 'সেটিংস',
    quizQ29A2: 'লার্ন একাডেমি',
    quizQ29A3: 'নোটিফিকেশন',
    quizQ29A4: 'প্রোফাইল',
    quizQ30: 'যদি আপনার খরচ আপনার আয়ের চেয়ে বেশি হয়, তাহলে কী ঘটতে পারে?',
    quizQ30A1: 'ঋণ বাড়ে',
    quizQ30A2: 'সঞ্চয় বাড়ে',
    quizQ30A3: 'সম্পদ বাড়ে',
    quizQ30A4: 'বেতন দ্বিগুণ হয়',
    reviewAnswers: 'উত্তরগুলো পর্যালোচনা করুন',
    backToQuiz: 'কুইজে ফিরে যান',
    dashboard: 'ড্যাশবোর্ড',
    expenseTracking: 'খরচ ট্র্যাকিং',
    report: 'রিপোর্ট',
    savingGoals: 'সঞ্চয় লক্ষ্য',
    quiz: 'কুইজ',
    savingMoneyEasy: 'সহজে টাকা সঞ্চয়',
    simpleBudgeting: 'সহজ বাজেটিং',
    lessons: "পাঠসমূহ",
    appTour: "অ্যাপ ট্যুর",
    progress: "অগ্রগতি",
    smartSpendingTipsSubtitle: "বুদ্ধিমানের মতো খরচ করুন, ভালো থাকুন",
    simpleBudgetingSubtitle: "সহজেই পরিকল্পনা করুন",
    savingMoneyEasySubtitle: "আপনার ভবিষ্যৎ গড়ুন",
    savingsCoach: "সেভিংস কোচ",
    savingsCoachSubtitle: "খরচ কমান, স্বপ্ন নয়",
    taketheQuiz: "কুইজ দিন",
    taketheQuizSubtitle: "আপনার জ্ঞান পরীক্ষা করুন",
    viewQuizResult: "কুইজ ফলাফল দেখুন",
    quizResultSubtitle: "আপনার স্কোর দেখুন",

    coachOptMoneyBoss: 'অর্থের বস',
    coachOptDoingOkay: 'ভালো আছি',
    coachOptNeedsWork: 'উন্নতি দরকার',
    coachOpt0_200: '৳০-৳২০০',
    coachOpt200_500: '৳২০০-৳৫০০',
    coachOpt500plus: '৳৫০০+',
    coachOpt0_1000: '৳০-৳১০০০',
    coachOpt1000_2000: '৳১০০০-৳২০০০',
    coachOpt2000plus: '৳২০০০+',
    coachOpt100: '৳১০০',
    coachOpt500: '৳৫০০',
    coachOpt1000plus: '৳১০০০+',
    coachOptAlways: 'সবসময়',
    coachOptSometimes: 'মাঝে মাঝে',
    coachOptNotReally: 'একদম না',
    coachOptFood: 'খাদ্য',
    coachOptShopping: 'শপিং',
    coachOptEntertainment: 'বিনোদন',
    coachOptNever: 'কখনোই না',
    coachOptYes: 'হ্যাঁ',
    coachOptMaybe: 'হয়তো',
    coachOptNo: 'না',
    coachOptRarely: 'কদাচিৎ',
    coachOptSaveIt: 'সঞ্চয় করি',
    coachOptSpendIt: 'খরচ করি',

    coachOptNotSure: 'নিশ্চিত নই',
    coachOtherHint: 'অন্যান্য (অনুগ্রহ করে উল্লেখ করুন)',
    coachSeeResult: 'ফলাফল দেখুন',
    coachNext: 'পরবর্তী',
    coachSavingPlan: 'আপনার সঞ্চয় পরিকল্পনা',
  };
}

List<MapLocale> locales = [
  MapLocale('en', LocaleData.en, countryCode: 'US'),
  MapLocale('bn', LocaleData.bn, countryCode: 'BD'),
];
