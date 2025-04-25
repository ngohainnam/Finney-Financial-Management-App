import 'package:flutter/material.dart';
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
  static const String financialBasics = 'financialBasics';
  // Learn page keys
  static const String askFinneyAI = 'askFinneyAI';
  static const String moneyManagement = 'moneyManagement';
  static const String moneyManagementSubtitle = 'moneyManagementSubtitle';
  static const String savingBudgeting = 'savingBudgeting';
  static const String savingBudgetingSubtitle = 'savingBudgetingSubtitle';
  static const String investingFundamentals = 'investingFundamentals';
  static const String investingFundamentalsSubtitle = 'investingFundamentalsSubtitle';
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
  static const String investingFundamentalsPoint1 = 'investingFundamentalsPoint1';
  static const String investingFundamentalsPoint2 = 'investingFundamentalsPoint2';
  static const String investingFundamentalsPoint3 = 'investingFundamentalsPoint3';
  static const String investingFundamentalsPoint4 = 'investingFundamentalsPoint4';
  static const String financialSafetyPoint1 = 'financialSafetyPoint1';
  static const String financialSafetyPoint2 = 'financialSafetyPoint2';
  static const String financialSafetyPoint3 = 'financialSafetyPoint3';
  static const String financialSafetyPoint4 = 'financialSafetyPoint4';
  static const String resourceMoneyManagementVideo = 'resourceMoneyManagementVideo';
  static const String resourceMoneyManagementArticle1 = 'resourceMoneyManagementArticle1';
  static const String resourceMoneyManagementArticle2 = 'resourceMoneyManagementArticle2';
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

  static const Map<String, String> en = {
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
    investingFundamentalsPoint4: 'Start with small investments and grow gradually',
    financialSafetyPoint1: 'Recognize and avoid financial scams',
    financialSafetyPoint2: 'Understand the importance of insurance',
    financialSafetyPoint3: 'Secure your online financial accounts',
    financialSafetyPoint4: 'Learn about identity theft protection',
    resourceMoneyManagementVideo: 'Basic Money Management',
    resourceMoneyManagementArticle1: 'Investopedia: Personal Finance Basics',
    resourceMoneyManagementArticle2: 'Investopedia: Ultimate Guide to Financial Literacy',
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
  };

  static const Map<String, String> bd = {
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
    errorLoadingData: 'ব্যবহারকারীর ডেটা লোড করতে ব্যর্থ',
    errorSavingData: 'ব্যবহারকারীর ডেটা সংরক্ষণ করতে ব্যর্থ',
    user: 'ব্যবহারকারী',
    notAvailable: 'পাওয়া যায়নি',
    financialBasics: 'আর্থিক মৌলিক বিষয়',
    askFinneyAI: 'যেকোনো সাহায্যের জন্য ফিনি এআই-কে জিজ্ঞাসা করুন',
    moneyManagement: 'অর্থ ব্যবস্থাপনা',
    moneyManagementSubtitle: 'আপনার অর্থ ট্র্যাক, পরিকল্পনা এবং নিয়ন্ত্রণ করুন',
    savingBudgeting: 'সঞ্চয় ও বাজেটিং',
    savingBudgetingSubtitle: 'কীভাবে স্মার্টলি সঞ্চয় এবং বাজেট করতে হয় তা শিখুন',
    investingFundamentals: 'বিনিয়োগের মৌলিক বিষয়',
    investingFundamentalsSubtitle: 'আপনার অর্থ কীভাবে বাড়ানো যায় তা বুঝুন',
    financialSafety: 'আর্থিক নিরাপত্তা',
    financialSafetySubtitle: 'নিরাপদ থাকুন এবং প্রতারণা এড়ান',
    keyPoints: 'মূল বিষয়',
    learnMore: 'আরও জানুন',
    backToTopics: 'বিষয়গুলোতে ফিরে যান',
    aiAssistant: 'এআই সহকারী',
    moneyManagementPoint1: 'নিয়মিত আয় এবং ব্যয় ট্র্যাক করুন',
    moneyManagementPoint2: 'প্রয়োজন এবং চাওয়ার মধ্যে পার্থক্য করুন',
    moneyManagementPoint3: 'বেসিক ব্যাংকিং পরিষেবা বুঝুন',
    moneyManagementPoint4: 'একটি সাধারণ আর্থিক রেকর্ড বজায় রাখুন',
    savingBudgetingPoint1: '50-30-20 নিয়ম অনুসরণ করুন (প্রয়োজন-চাওয়া-সঞ্চয়)',
    savingBudgetingPoint2: 'জরুরি তহবিল তৈরি করুন (3-6 মাসের খরচ)',
    savingBudgetingPoint3: 'আপনার সঞ্চয় স্বয়ংক্রিয় করুন',
    savingBudgetingPoint4: 'মাসিক বাজেট পর্যালোচনা এবং সমন্বয় করুন',
    investingFundamentalsPoint1: 'ঝুঁকি এবং রিটার্ন বুঝুন',
    investingFundamentalsPoint2: 'আপনার বিনিয়োগ বৈচিত্র্যময় করুন',
    investingFundamentalsPoint3: 'স্টক, বন্ড এবং মিউচুয়াল ফান্ড সম্পর্কে জানুন',
    investingFundamentalsPoint4: 'ছোট বিনিয়োগ দিয়ে শুরু করুন এবং ধীরে ধীরে বাড়ান',
    financialSafetyPoint1: 'আর্থিক প্রতারণা চিনুন এবং এড়ান',
    financialSafetyPoint2: 'বীমার গুরুত্ব বুঝুন',
    financialSafetyPoint3: 'আপনার অনলাইন আর্থিক অ্যাকাউন্ট সুরক্ষিত করুন',
    financialSafetyPoint4: 'পরিচয় চুরি সুরক্ষা সম্পর্কে জানুন',
    resourceMoneyManagementVideo: 'বেসিক মানি ম্যানেজমেন্ট',
    resourceMoneyManagementArticle1: 'ইনভেস্টোপিডিয়া: ব্যক্তিগত অর্থের মৌলিক বিষয়',
    resourceMoneyManagementArticle2: 'ইনভেস্টোপিডিয়া: আর্থিক সাক্ষরতার চূড়ান্ত গাইড',
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
    welcomeMessage: 'ফিনি এআই-এ স্বাগতম! আমি আজ আপনাকে কীভাবে সহায়তা করতে পারি?',
    suggestedQuestion1: 'বাজেটিং কী?',
    suggestedQuestion2: 'কীভাবে আমি কার্যকরভাবে অর্থ সঞ্চয় করতে পারি?',
    suggestedQuestion3: 'বিনিয়োগের মৌলিক বিষয়গুলো কী কী?',
  };
}

const List<MapLocale> locales = [
  MapLocale(
    'en',
    LocaleData.en,
    countryCode: 'US',
  ),
  MapLocale(
    'bn',
    LocaleData.bd,
    countryCode: 'BD',
  ),
];