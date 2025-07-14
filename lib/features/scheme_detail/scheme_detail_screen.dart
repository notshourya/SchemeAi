import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/data/models/scheme_recommendation.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/theme/app_theme.dart';

class SchemeDetailController extends GetxController {
  final scheme = Rx<SchemeRecommendation?>(null);

  @override
  void onInit() {
    super.onInit();
    _loadArguments();
  }

  void _loadArguments() {
    final args = Get.arguments;
    if (args is SchemeRecommendation) {
      scheme.value = args;
    }
  }

  Future<void> openWebsite() async {
    final url = scheme.value?.websiteUrl;
    if (url != null && url.isNotEmpty) {
      
      Get.snackbar(
        'Website',
        'Visit: $url',
        backgroundColor: AppTheme.primaryColor,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    } else {
      Get.snackbar(
        'No Website',
        'Website URL not available for this scheme',
        backgroundColor: AppTheme.warningColor,
        colorText: Colors.white,
      );
    }
  }

  void shareScheme() {
    final schemeData = scheme.value;
    if (schemeData != null) {
      // TODO: Implement share functionality
      Get.snackbar(
        'Share',
        'Share functionality will be implemented',
        backgroundColor: AppTheme.primaryColor,
        colorText: Colors.white,
      );
    }
  }
}

class SchemeDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SchemeDetailController());
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scheme Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: controller.shareScheme,
          ),
        ],
      ),
      body: Obx(() {
        final scheme = controller.scheme.value;
        
        if (scheme == null) {
          return const Center(
            child: Text('Scheme details not found'),
          );
        }
        
        return SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(scheme, controller),
              _buildContent(scheme),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHeader(SchemeRecommendation scheme, SchemeDetailController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.accentColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.account_balance,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Government Scheme',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            scheme.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            scheme.ministry,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  scheme.category,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star,
                      size: 16,
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      scheme.formattedRelevanceScore,
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (scheme.hasWebsite)
            CustomButton(
              text: 'Visit Official Website',
              onPressed: controller.openWebsite,
              backgroundColor: Colors.white,
              textColor: AppTheme.primaryColor,
              width: double.infinity,
              icon: Icons.open_in_new,
            ),
        ],
      ),
    );
  }

  Widget _buildContent(SchemeRecommendation scheme) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            'Description',
            scheme.description,
            Icons.description,
          ),
          
          const SizedBox(height: 24),
          
          _buildSection(
            'Eligibility Criteria',
            scheme.eligibilityText,
            Icons.checklist,
          ),
          
          const SizedBox(height: 24),
          
          _buildSection(
            'Benefits',
            scheme.benefitsText,
            Icons.card_giftcard,
          ),
          
          const SizedBox(height: 24),
          
          _buildSection(
            'Application Process',
            scheme.applicationProcess,
            Icons.assignment,
          ),
          
          const SizedBox(height: 24),
          
          _buildSection(
            'Required Documents',
            scheme.documentsText,
            Icons.folder,
          ),
          
          if (scheme.hasDeadline) ...[
            const SizedBox(height: 24),
            _buildSection(
              'Application Deadline',
              scheme.deadline!,
              Icons.schedule,
            ),
          ],
          
          const SizedBox(height: 32),
          
          
          _buildActionButtons(scheme),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content, IconData icon) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              content,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(SchemeRecommendation scheme) {
    return Column(
      children: [
        if (scheme.hasWebsite)
          CustomButton(
            text: 'Apply Online',
            onPressed: () {
              //TODO: Open website for application
            },
            width: double.infinity,
            icon: Icons.web,
          ),
        
        const SizedBox(height: 12),
        
        CustomButton(
          text: 'Save Scheme',
          onPressed: () {
            // Implement save functionality
            Get.snackbar(
              'Saved',
              'Scheme saved to your favorites',
              backgroundColor: AppTheme.successColor,
              colorText: Colors.white,
            );
          },
          width: double.infinity,
          icon: Icons.bookmark,
          isOutlined: true,
        ),
      ],
    );
  }
}
