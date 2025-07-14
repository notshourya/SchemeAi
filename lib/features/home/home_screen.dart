import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/data/services/firebase_service.dart';
import '../../app/data/services/gemini_service.dart';
import '../../app/routes/app_pages.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/theme/app_theme.dart';

class HomeController extends GetxController {
  final FirebaseService _firebaseService = Get.find<FirebaseService>();
  final GeminiService _geminiService = Get.put(GeminiService());
  
  final isLoading = false.obs;

  String get userName => _firebaseService.currentUser?.displayName ?? 'User';
  String get userEmail => _firebaseService.currentUser?.email ?? '';

  @override
  void onInit() {
    super.onInit();
    _checkApiConfiguration();
  }

  void _checkApiConfiguration() async {
    isLoading.value = true;
    try {
      final isConfigured = _geminiService.isConfigured;
      if (!isConfigured) {
        Get.snackbar(
          'Setup Required',
          'Please configure your Gemini API key in the .env file',
          backgroundColor: AppTheme.warningColor,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  void goToForm() {
    Get.toNamed(Routes.FORM);
  }

  void goToProfile() {
    Get.toNamed(Routes.PROFILE);
  }

  void goToHistory() {
    Get.toNamed(Routes.HISTORY);
  }

  void signOut() async {
    try {
      await _firebaseService.signOut();
      Get.offAllNamed(Routes.LOGIN);
      Get.snackbar(
        'Success',
        'Signed out successfully',
        backgroundColor: AppTheme.successColor,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to sign out: ${e.toString()}',
        backgroundColor: AppTheme.errorColor,
        colorText: Colors.white,
      );
    }
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scheme AI'),
        actions: [
          IconButton(
            onPressed: controller.goToHistory,
            icon: const Icon(Icons.history),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: controller.goToProfile,
                child: const Row(
                  children: [
                    Icon(Icons.person),
                    SizedBox(width: 12),
                    Text('Profile'),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: controller.signOut,
                child: const Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 12),
                    Text('Sign Out'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            _buildWelcomeSection(context, controller),
            const SizedBox(height: 32),
            
            // Quick Start Section
            _buildQuickStartSection(context, controller),
            const SizedBox(height: 32),
            
            // Features Section
            _buildFeaturesSection(context),
            const SizedBox(height: 32),
            
            // Recent Activity Section
            _buildRecentActivitySection(context, controller),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context, HomeController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor,
            AppTheme.primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back,',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      controller.userName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.waving_hand,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Text(
              'Discover government schemes tailored specifically for your needs using AI-powered recommendations.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.95),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStartSection(BuildContext context, HomeController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Colors.grey.shade50,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.rocket_launch,
                  color: AppTheme.primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ready to Start?',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    Text(
                      'Get your personalized recommendations now',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          CustomButton(
            text: 'Find Government Schemes',
            icon: Icons.search,
            onPressed: controller.goToForm,
            width: double.infinity,
            height: 56,
          ),
          
          const SizedBox(height: 16),
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppTheme.accentColor,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Fill out your profile to get AI-powered scheme recommendations',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.accentColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection(BuildContext context) {
    final features = [
      {
        'icon': Icons.psychology,
        'title': 'AI-Powered',
        'description': 'Smart recommendations using advanced AI technology',
        'color': AppTheme.primaryColor,
        'gradient': [AppTheme.primaryColor, AppTheme.primaryColor.withOpacity(0.7)],
      },
      {
        'icon': Icons.account_balance,
        'title': 'Government Schemes',
        'description': 'Comprehensive database of 500+ Indian schemes',
        'color': AppTheme.secondaryColor,
        'gradient': [AppTheme.secondaryColor, AppTheme.secondaryColor.withOpacity(0.7)],
      },
      {
        'icon': Icons.person_pin_circle,
        'title': 'Personalized',
        'description': 'Tailored suggestions for your specific needs',
        'color': AppTheme.accentColor,
        'gradient': [AppTheme.accentColor, AppTheme.accentColor.withOpacity(0.7)],
      },
      {
        'icon': Icons.verified_user,
        'title': 'Secure & Private',
        'description': 'Bank-level security, your data never shared',
        'color': AppTheme.warningColor,
        'gradient': [AppTheme.warningColor, AppTheme.warningColor.withOpacity(0.7)],
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.auto_awesome,
              color: AppTheme.primaryColor,
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              'Why Choose Scheme AI?',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.lightOnSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Discover the power of AI-driven government scheme recommendations',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightOnSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 24),
        
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.9, 
          ),
          itemCount: features.length,
          itemBuilder: (context, index) {
            final feature = features[index];
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: feature['gradient'] as List<Color>,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: (feature['color'] as Color).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                   
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            feature['icon'] as IconData,
                            size: 32,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          feature['title'] as String,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Flexible(
                          child: Text(
                            feature['description'] as String,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 11,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRecentActivitySection(BuildContext context, HomeController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Activity',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextButton(
              onPressed: controller.goToHistory,
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Placeholder for recent activity
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Icon(
                  Icons.history,
                  size: 48,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No recent searches',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Start by filling out your profile to get scheme recommendations',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: 'Get Started',
                  onPressed: controller.goToForm,
                  isOutlined: true,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
