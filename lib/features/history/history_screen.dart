import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../app/data/services/firebase_service.dart';
import '../../app/routes/app_pages.dart';
import '../../shared/widgets/loading_widget.dart';
import '../../shared/theme/app_theme.dart';

class HistoryController extends GetxController {
  final FirebaseService _firebaseService = Get.find<FirebaseService>();
  
  final isLoading = false.obs;
  final searchHistory = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadSearchHistory();
  }

  void _loadSearchHistory() async {
    isLoading.value = true;
    
    try {
      final history = await _firebaseService.getSearchHistory();
      searchHistory.value = history;
    } catch (e) {
      print('Error loading search history: $e');
      Get.snackbar(
        'Error',
        'Failed to load search history',
        backgroundColor: AppTheme.errorColor,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void viewSessionDetails(String sessionId) async {
    try {
      final recommendations = await _firebaseService.getSessionRecommendations(sessionId);
      
      if (recommendations.isNotEmpty) {
        Get.toNamed(Routes.RESULTS, arguments: {
          'recommendations': recommendations,
          'formData': null, 
        });
      } else {
        Get.snackbar(
          'No Data',
          'No recommendations found for this session',
          backgroundColor: AppTheme.warningColor,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load session details',
        backgroundColor: AppTheme.errorColor,
        colorText: Colors.white,
      );
    }
  }

  void clearHistory() {
    Get.dialog(
      AlertDialog(
        title: const Text('Clear History'),
        content: const Text('Are you sure you want to clear all search history? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
             
              searchHistory.clear();
              Get.back();
              Get.snackbar(
                'Cleared',
                'Search history cleared successfully',
                backgroundColor: AppTheme.successColor,
                colorText: Colors.white,
              );
            },
            child: Text(
              'Clear',
              style: TextStyle(color: AppTheme.errorColor),
            ),
          ),
        ],
      ),
    );
  }

  String formatDate(dynamic timestamp) {
    if (timestamp == null) return 'Unknown date';
    
    try {
      DateTime date;
      if (timestamp is DateTime) {
        date = timestamp;
      } else {
        
        date = DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
      }
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return 'Unknown date';
    }
  }

  String formatTime(dynamic timestamp) {
    if (timestamp == null) return '';
    
    try {
      DateTime date;
      if (timestamp is DateTime) {
        date = timestamp;
      } else {
       
        date = DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
      }
      return DateFormat('hh:mm a').format(date);
    } catch (e) {
      return '';
    }
  }
}

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HistoryController());
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search History'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('Clear History'),
                onTap: controller.clearHistory,
              ),
            ],
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget(message: 'Loading search history...');
        }
        
        if (controller.searchHistory.isEmpty) {
          return _buildEmptyState();
        }
        
        return _buildHistoryList(controller);
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No search history',
              style: Get.textTheme.headlineMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your search history will appear here after you search for schemes',
              style: Get.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList(HistoryController controller) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.searchHistory.length,
      itemBuilder: (context, index) {
        final session = controller.searchHistory[index];
        return _buildHistoryCard(session, controller);
      },
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> session, HistoryController controller) {
    final formData = session['formData'] as Map<String, dynamic>?;
    final recommendationsCount = session['recommendationsCount'] as int? ?? 0;
    final createdAt = session['createdAt'];
    final sessionId = session['id'] as String;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => controller.viewSessionDetails(sessionId),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
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
                          'Search Results',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${controller.formatDate(createdAt)} at ${controller.formatTime(createdAt)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$recommendationsCount schemes',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Profile Summary
              if (formData != null) ...[
                const Divider(),
                const SizedBox(height: 12),
                _buildProfileSummary(formData),
              ],
              
              const SizedBox(height: 12),
              
              // Action
              Row(
                children: [
                  const Spacer(),
                  Text(
                    'Tap to view results',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: AppTheme.primaryColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSummary(Map<String, dynamic> formData) {
    final name = formData['name'] as String?;
    final age = formData['age'] as int?;
    final occupation = formData['occupation'] as String?;
    final state = formData['state'] as String?;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Profile Summary',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (name != null) _buildInfoChip(name),
            if (age != null) _buildInfoChip('Age: $age'),
            if (occupation != null) _buildInfoChip(occupation),
            if (state != null) _buildInfoChip(state),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          color: Colors.grey[700],
        ),
      ),
    );
  }
}
