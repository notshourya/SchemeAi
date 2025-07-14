import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/data/services/firebase_service.dart';
import '../../app/data/models/user_form_data.dart';
import '../../app/routes/app_pages.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/widgets/loading_widget.dart';
import '../../shared/theme/app_theme.dart';

class ProfileController extends GetxController {
  final FirebaseService _firebaseService = Get.find<FirebaseService>();
  
  final isLoading = false.obs;
  final userData = Rx<UserFormData?>(null);
  final userName = ''.obs;
  final userEmail = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  void _loadUserData() async {
    isLoading.value = true;
    
    try {
      final user = _firebaseService.currentUser;
      userName.value = user?.displayName ?? 'User';
      userEmail.value = user?.email ?? '';
      
      final formData = await _firebaseService.getUserFormData();
      userData.value = formData;
    } catch (e) {
      print('Error loading user data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void editProfile() {
    Get.toNamed(Routes.FORM);
  }

  void viewHistory() {
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
        'Failed to sign out',
        backgroundColor: AppTheme.errorColor,
        colorText: Colors.white,
      );
    }
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: controller.editProfile,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget(message: 'Loading profile...');
        }
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              _buildProfileHeader(controller),
              const SizedBox(height: 32),
              _buildProfileDetails(controller),
              const SizedBox(height: 32),
              _buildActionButtons(controller),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProfileHeader(ProfileController controller) {
    return Container(
      width: double.infinity,
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
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 45,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 42,
                  backgroundColor: Colors.grey[100],
                  child: Icon(
                    Icons.person,
                    size: 42,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppTheme.successColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.verified,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            controller.userName.value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            controller.userEmail.value,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileDetails(ProfileController controller) {
    final userData = controller.userData.value;
    
    if (userData == null) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person_add,
                size: 48,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Complete Your Profile',
              style: Get.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your personal information to get AI-powered scheme recommendations',
              style: Get.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Complete Profile',
              onPressed: controller.editProfile,
              icon: Icons.edit,
            ),
          ],
        ),
      );
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Profile Details',
          style: Get.textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        
        _buildDetailCard('Personal Information', [
          _buildDetailItem('Name', userData.name ?? 'Not provided'),
          _buildDetailItem('Age', userData.age?.toString() ?? 'Not provided'),
          _buildDetailItem('Gender', userData.gender ?? 'Not provided'),
          _buildDetailItem('Education', userData.educationLevel ?? 'Not provided'),
        ]),
        
        const SizedBox(height: 16),
        
        _buildDetailCard('Professional Information', [
          _buildDetailItem('Occupation', userData.occupation ?? 'Not provided'),
          _buildDetailItem('Annual Income', userData.annualIncome != null 
              ? '₹${userData.annualIncome!.toStringAsFixed(0)}' 
              : 'Not provided'),
        ]),
        
        const SizedBox(height: 16),
        
        _buildDetailCard('Location Information', [
          _buildDetailItem('State', userData.state ?? 'Not provided'),
          _buildDetailItem('District', userData.district ?? 'Not provided'),
          _buildDetailItem('Category', userData.category ?? 'Not provided'),
        ]),
        
        const SizedBox(height: 16),
        
        _buildDetailCard('Additional Information', [
          _buildDetailItem('Marital Status', 
              userData.isMarried != null 
                  ? (userData.isMarried! ? 'Married' : 'Unmarried')
                  : 'Not provided'),
          _buildDetailItem('Number of Children', 
              userData.numberOfChildren?.toString() ?? 'Not provided'),
          _buildDetailItem('Below Poverty Line', 
              userData.isBelowPovertyLine != null 
                  ? (userData.isBelowPovertyLine! ? 'Yes' : 'No')
                  : 'Not provided'),
          _buildDetailItem('Has Disability', 
              userData.hasDisability != null 
                  ? (userData.hasDisability! ? 'Yes' : 'No')
                  : 'Not provided'),
          _buildDetailItem('Land Ownership', 
              userData.landOwnership ?? 'Not provided'),
        ]),
        
        if (userData.interests != null && userData.interests!.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildInterestsCard(userData.interests!),
        ],
      ],
    );
  }

  Widget _buildDetailCard(String title, List<Widget> items) {
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
                    _getIconForTitle(title),
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
            ...items,
          ],
        ),
      ),
    );
  }

  IconData _getIconForTitle(String title) {
    switch (title) {
      case 'Personal Information':
        return Icons.person;
      case 'Professional Information':
        return Icons.work;
      case 'Location Information':
        return Icons.location_on;
      case 'Additional Information':
        return Icons.info;
      default:
        return Icons.info;
    }
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterestsCard(List<String> interests) {
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
                    Icons.interests,
                    size: 20,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Areas of Interest',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: interests.map((interest) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    interest,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w600,
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

  Widget _buildActionButtons(ProfileController controller) {
    return Column(
      children: [
        CustomButton(
          text: 'Edit Profile',
          onPressed: controller.editProfile,
          width: double.infinity,
          icon: Icons.edit,
        ),
        const SizedBox(height: 16),
        CustomButton(
          text: 'View Search History',
          onPressed: controller.viewHistory,
          width: double.infinity,
          icon: Icons.history,
          isOutlined: true,
        ),
        const SizedBox(height: 32),
        CustomButton(
          text: 'Sign Out',
          onPressed: controller.signOut,
          width: double.infinity,
          icon: Icons.logout,
          backgroundColor: AppTheme.errorColor,
        ),
      ],
    );
  }
}
