class AppConstants {
  // App Information
  static const String appName = 'Scheme AI';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Find relevant Indian government schemes with AI';

  // API Constants
  static const String geminiBaseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';
  static const Duration apiTimeout = Duration(seconds: 30);
  static const int maxRetries = 3;

  // Storage Keys
  static const String userFormDataKey = 'user_form_data';
  static const String themePreferenceKey = 'theme_preference';
  static const String isFirstLaunchKey = 'is_first_launch';
  static const String lastSearchKey = 'last_search';

  // Validation Constants
  static const int minAge = 1;
  static const int maxAge = 120;
  static const double minIncome = 0;
  static const double maxIncome = 10000000; 
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const int phoneNumberLength = 10;

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 8.0;
  static const double cardElevation = 2.0;
  static const Duration animationDuration = Duration(milliseconds: 300);

  // Colors 
  static const String primaryColorHex = '#2E7D32';
  static const String secondaryColorHex = '#1976D2';
  static const String errorColorHex = '#E53935';

  // Government Scheme Categories
  static const List<String> schemeCategories = [
    'Agriculture',
    'Education',
    'Health',
    'Employment',
    'Housing',
    'Social Welfare',
    'Women & Child Development',
    'Rural Development',
    'Financial Services',
    'Skill Development',
  ];

  // Interest Areas
  static const List<String> interestAreas = [
    'Agriculture & Farming',
    'Education & Skill Development',
    'Healthcare',
    'Employment & Jobs',
    'Housing & Shelter',
    'Women Empowerment',
    'Child Development',
    'Senior Citizen Welfare',
    'Disability Support',
    'Financial Assistance',
    'Rural Development',
    'Urban Development',
    'Environmental Conservation',
    'Digital Literacy',
    'Entrepreneurship',
  ];

  // Land Ownership Types
  static const List<String> landOwnershipTypes = [
    'Landless',
    'Marginal Farmer (< 1 hectare)',
    'Small Farmer (1-2 hectares)',
    'Semi-medium Farmer (2-4 hectares)',
    'Medium Farmer (4-10 hectares)',
    'Large Farmer (> 10 hectares)',
    'Not Applicable',
  ];

  // Error Messages
  static const String networkError = 'Network error. Please check your internet connection.';
  static const String apiError = 'Service temporarily unavailable. Please try again later.';
  static const String authError = 'Authentication failed. Please log in again.';
  static const String validationError = 'Please fill all required fields correctly.';
  static const String noDataError = 'No data available.';
  static const String unknownError = 'Something went wrong. Please try again.';

  // Success Messages
  static const String loginSuccess = 'Login successful!';
  static const String registerSuccess = 'Registration successful!';
  static const String logoutSuccess = 'Logout successful!';
  static const String dataUpdateSuccess = 'Information updated successfully!';
  static const String recommendationsFoundSuccess = 'Scheme recommendations found!';

  // Loading Messages
  static const String loginLoading = 'Signing in...';
  static const String registerLoading = 'Creating account...';
  static const String googleSignInLoading = 'Signing in with Google...';
  static const String fetchingRecommendations = 'Finding relevant schemes for you...';
  static const String savingData = 'Saving your information...';
  static const String loadingProfile = 'Loading your profile...';

  // App Features
  static const List<String> appFeatures = [
    'AI-powered scheme recommendations',
    'Personalized suggestions based on your profile',
    'Comprehensive government scheme database',
    'Easy application process guidance',
    'Search history and favorites',
    'Multi-language support',
    'Offline scheme information',
    'Regular updates on new schemes',
  ];

  // Legal
  static const String privacyPolicyUrl = 'https://your-app.com/privacy';
  static const String termsOfServiceUrl = 'https://your-app.com/terms';
  static const String supportEmail = 'support@your-app.com';
  static const String supportPhone = '+91-1234567890';

  // Social Media
  static const String facebookUrl = 'https://facebook.com/your-app';
  static const String twitterUrl = 'https://twitter.com/your-app';
  static const String linkedinUrl = 'https://linkedin.com/company/your-app';

  // Government Resources
  static const String myGovUrl = 'https://www.mygov.in';
  static const String digitalIndiaUrl = 'https://digitalindia.gov.in';
  static const String pmjayUrl = 'https://pmjay.gov.in';
  static const String pmkisanUrl = 'https://pmkisan.gov.in';

  // File Limits
  static const int maxFileSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedFileTypes = ['.pdf', '.jpg', '.jpeg', '.png'];

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Cache
  static const Duration cacheExpiration = Duration(hours: 24);
  static const int maxCacheSize = 100; // Number of cached items

  // Form Validation Patterns
  static const String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  static const String phonePattern = r'^[6-9]\d{9}$';
  static const String aadharPattern = r'^[2-9]{1}[0-9]{3}[0-9]{4}[0-9]{4}$';
  static const String panPattern = r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$';

  // Notifications
  static const String defaultNotificationTitle = 'Scheme AI';
  static const Duration notificationTimeout = Duration(seconds: 3);

  // Database
  static const String userCollection = 'users';
  static const String schemeCollection = 'schemes';
  static const String searchSessionCollection = 'searchSessions';
  static const String feedbackCollection = 'feedback';

  // Feature Flags
  static const bool enableOfflineMode = true;
  static const bool enableNotifications = true;
  static const bool enableAnalytics = false; // Set to false for privacy
  static const bool enableCrashReporting = false; // Set to false for privacy
}
