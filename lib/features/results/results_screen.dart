import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/data/models/scheme_recommendation.dart';
import '../../app/data/models/user_form_data.dart';
import '../../app/routes/app_pages.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/widgets/loading_widget.dart';
import '../../shared/theme/app_theme.dart';

class ResultsController extends GetxController {
  final recommendations = <SchemeRecommendation>[].obs;
  final formData = Rx<UserFormData?>(null);
  final isLoading = false.obs;
  final selectedCategory = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadArguments();
  }

  void _loadArguments() {
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      recommendations.value = args['recommendations'] ?? [];
      formData.value = args['formData'];
    }
  }

  List<SchemeRecommendation> get filteredRecommendations {
    if (selectedCategory.value == 'All') {
      return recommendations.toList()
        ..sort((a, b) => b.relevanceScore.compareTo(a.relevanceScore));
    }
    
    return recommendations
        .where((scheme) => scheme.category == selectedCategory.value)
        .toList()
      ..sort((a, b) => b.relevanceScore.compareTo(a.relevanceScore));
  }

  List<String> get availableCategories {
    final categories = recommendations
        .map((scheme) => scheme.category)
        .toSet()
        .toList();
    categories.insert(0, 'All');
    return categories;
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  void viewSchemeDetails(SchemeRecommendation scheme) {
    Get.toNamed(Routes.SCHEME_DETAIL, arguments: scheme);
  }

  void startNewSearch() {
    Get.offAllNamed(Routes.FORM);
  }

  void goHome() {
    Get.offAllNamed(Routes.HOME);
  }
}

class ResultsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ResultsController());
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scheme Recommendations'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: controller.goHome,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget(message: 'Loading recommendations...');
        }
        
        if (controller.recommendations.isEmpty) {
          return _buildEmptyState(controller);
        }
        
        return Column(
          children: [
            
            _buildSummarySection(controller),
            
    
            _buildCategoryFilter(controller),
            
      
            Expanded(
              child: _buildRecommendationsList(controller),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildEmptyState(ResultsController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No schemes found',
              style: Get.textTheme.headlineMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'We couldn\'t find any relevant schemes for your profile. Try adjusting your information.',
              style: Get.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: 'Update Profile',
              onPressed: controller.startNewSearch,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummarySection(ResultsController controller) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.accentColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
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
              Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                'AI Recommendations',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Found ${controller.recommendations.length} government schemes matching your profile',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  'Total',
                  controller.recommendations.length.toString(),
                  Icons.library_books,
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  'High Match',
                  controller.recommendations
                      .where((s) => s.relevanceScore >= 0.8)
                      .length
                      .toString(),
                  Icons.star,
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  'Categories',
                  (controller.availableCategories.length - 1).toString(),
                  Icons.category,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryFilter(ResultsController controller) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Obx(() => ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.availableCategories.length,
        itemBuilder: (context, index) {
          final category = controller.availableCategories[index];
          final isSelected = controller.selectedCategory.value == category;
          
          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: Material(
              elevation: isSelected ? 4 : 1,
              borderRadius: BorderRadius.circular(25),
              child: InkWell(
                borderRadius: BorderRadius.circular(25),
                onTap: () => controller.selectCategory(category),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: isSelected 
                        ? LinearGradient(
                            colors: [AppTheme.primaryColor, AppTheme.accentColor],
                          )
                        : null,
                    color: isSelected ? null : Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: isSelected 
                          ? Colors.transparent 
                          : Colors.grey.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[700],
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      )),
    );
  }

  Widget _buildRecommendationsList(ResultsController controller) {
    return Obx(() {
      final schemes = controller.filteredRecommendations;
      
      if (schemes.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.filter_list_off,
                  size: 48,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No schemes in this category',
                  style: Get.textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        );
      }
      
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: schemes.length,
        itemBuilder: (context, index) {
          final scheme = schemes[index];
          return _buildSchemeCard(scheme, controller);
        },
      );
    });
  }

  Widget _buildSchemeCard(SchemeRecommendation scheme, ResultsController controller) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => controller.viewSchemeDetails(scheme),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          scheme.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            scheme.ministry,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildRelevanceScore(scheme.relevanceScore),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Description
              Text(
                scheme.shortDescription,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 16),
              
              // Category and Action
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.category,
                          size: 14,
                          color: AppTheme.primaryColor,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          scheme.category,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppTheme.primaryColor,
                  ),
                ],
              ),
              
              if (scheme.topBenefits.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 12),
                Text(
                  'Key Benefits:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                ...scheme.topBenefits.take(3).map((benefit) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(top: 6, right: 12),
                        decoration: BoxDecoration(
                          color: AppTheme.accentColor,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          benefit,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRelevanceScore(double score) {
    Color scoreColor;
    IconData scoreIcon;
    
    if (score >= 0.8) {
      scoreColor = AppTheme.successColor;
      scoreIcon = Icons.star;
    } else if (score >= 0.6) {
      scoreColor = AppTheme.warningColor;
      scoreIcon = Icons.star_half;
    } else {
      scoreColor = Colors.grey;
      scoreIcon = Icons.star_border;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: scoreColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: scoreColor.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            scoreIcon,
            size: 16,
            color: scoreColor,
          ),
          const SizedBox(width: 6),
          Text(
            '${(score * 100).toInt()}%',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: scoreColor,
            ),
          ),
        ],
      ),
    );
  }
}
