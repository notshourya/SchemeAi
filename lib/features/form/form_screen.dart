import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/data/models/user_form_data.dart';
import '../../app/data/services/firebase_service.dart';
import '../../app/data/services/gemini_service.dart';
import '../../app/routes/app_pages.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/widgets/custom_input_field.dart';
import '../../shared/widgets/custom_dropdown.dart';
import '../../shared/widgets/loading_widget.dart';
import '../../shared/utils/validators.dart';
import '../../shared/constants/app_constants.dart';
import '../../shared/theme/app_theme.dart';

class FormController extends GetxController {
  final FirebaseService _firebaseService = Get.find<FirebaseService>();
  final GeminiService _geminiService = Get.find<GeminiService>();
  
  final formKey = GlobalKey<FormState>();
  final pageController = PageController();
  

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final incomeController = TextEditingController();
  final districtController = TextEditingController();
  final childrenController = TextEditingController();
  

  final currentPage = 0.obs;
  final isLoading = false.obs;
  final isSubmitting = false.obs;
  

  final gender = RxnString();
  final occupation = RxnString();
  final state = RxnString();
  final category = RxnString();
  final educationLevel = RxnString();
  final landOwnership = RxnString();
  final isBelowPovertyLine = RxnBool();
  final isMarried = RxnBool();
  final hasDisability = RxnBool();
  final selectedInterests = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadExistingData();
  }

  @override
  void onClose() {
    nameController.dispose();
    ageController.dispose();
    incomeController.dispose();
    districtController.dispose();
    childrenController.dispose();
    pageController.dispose();
    super.onClose();
  }

  void _loadExistingData() async {
    isLoading.value = true;
    
    try {
      final userData = await _firebaseService.getUserFormData();
      if (userData != null) {
        _populateForm(userData);
      }
    } catch (e) {
      print('Error loading existing data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _populateForm(UserFormData userData) {
    nameController.text = userData.name ?? '';
    ageController.text = userData.age?.toString() ?? '';
    incomeController.text = userData.annualIncome?.toString() ?? '';
    districtController.text = userData.district ?? '';
    childrenController.text = userData.numberOfChildren?.toString() ?? '';
    
    gender.value = userData.gender;
    occupation.value = userData.occupation;
    state.value = userData.state;
    category.value = userData.category;
    educationLevel.value = userData.educationLevel;
    landOwnership.value = userData.landOwnership;
    isBelowPovertyLine.value = userData.isBelowPovertyLine;
    isMarried.value = userData.isMarried;
    hasDisability.value = userData.hasDisability;
    selectedInterests.value = userData.interests ?? [];
  }

  void nextPage() {
    if (currentPage.value < 2) {
      if (_validateCurrentPage()) {
        currentPage.value++;
        pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _validateCurrentPage() {
    switch (currentPage.value) {
      case 0:
        return _validateBasicInfo();
      case 1:
        return _validateDemographicInfo();
      case 2:
        return _validateAdditionalInfo();
      default:
        return false;
    }
  }

  bool _validateBasicInfo() {
    if (nameController.text.trim().isEmpty) {
      _showError('Please enter your name');
      return false;
    }
    if (ageController.text.trim().isEmpty) {
      _showError('Please enter your age');
      return false;
    }
    if (gender.value == null) {
      _showError('Please select your gender');
      return false;
    }
    return true;
  }

  bool _validateDemographicInfo() {
    if (occupation.value == null) {
      _showError('Please select your occupation');
      return false;
    }
    if (incomeController.text.trim().isEmpty) {
      _showError('Please enter your annual income');
      return false;
    }
    if (state.value == null) {
      _showError('Please select your state');
      return false;
    }
    if (category.value == null) {
      _showError('Please select your category');
      return false;
    }
    return true;
  }

  bool _validateAdditionalInfo() {
    if (educationLevel.value == null) {
      _showError('Please select your education level');
      return false;
    }
    return true;
  }

  void toggleInterest(String interest) {
    if (selectedInterests.contains(interest)) {
      selectedInterests.remove(interest);
    } else {
      selectedInterests.add(interest);
    }
  }

  void _showError(String message) {
    Get.snackbar(
      'Validation Error',
      message,
      backgroundColor: AppTheme.errorColor,
      colorText: Colors.white,
    );
  }

  UserFormData _buildFormData() {
    return UserFormData(
      name: nameController.text.trim(),
      age: int.tryParse(ageController.text),
      gender: gender.value,
      occupation: occupation.value,
      annualIncome: double.tryParse(incomeController.text.replaceAll(',', '')),
      state: state.value,
      district: districtController.text.trim().isNotEmpty 
          ? districtController.text.trim() 
          : null,
      category: category.value,
      isBelowPovertyLine: isBelowPovertyLine.value,
      educationLevel: educationLevel.value,
      isMarried: isMarried.value,
      numberOfChildren: int.tryParse(childrenController.text),
      hasDisability: hasDisability.value,
      landOwnership: landOwnership.value,
      interests: selectedInterests.isNotEmpty ? selectedInterests.toList() : null,
    );
  }

  Future<void> submitForm() async {
    if (!_validateCurrentPage()) return;

    isSubmitting.value = true;
    
    try {
      final formData = _buildFormData();
      
    
      await _firebaseService.saveUserFormData(formData);
      
    
      final recommendations = await _geminiService.getSchemeRecommendations(formData);
      
     
      await _firebaseService.saveSchemeRecommendations(recommendations, formData);
      
     
      Get.offNamed(Routes.RESULTS, arguments: {
        'recommendations': recommendations,
        'formData': formData,
      });
      
      Get.snackbar(
        'Success',
        'Found ${recommendations.length} relevant schemes for you!',
        backgroundColor: AppTheme.successColor,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to get recommendations: ${e.toString()}',
        backgroundColor: AppTheme.errorColor,
        colorText: Colors.white,
      );
    } finally {
      isSubmitting.value = false;
    }
  }
}

class FormScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FormController());
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Information'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget(message: 'Loading your data...');
        }
        
        return Column(
          children: [
          
            _buildProgressIndicator(controller),
            
            
            Expanded(
              child: PageView(
                controller: controller.pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (page) => controller.currentPage.value = page,
                children: [
                  _buildBasicInfoPage(controller),
                  _buildDemographicInfoPage(controller),
                  _buildAdditionalInfoPage(controller),
                ],
              ),
            ),
            
          
            _buildNavigationButtons(controller),
          ],
        );
      }),
    );
  }

  Widget _buildProgressIndicator(FormController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          for (int i = 0; i < 3; i++)
            Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(right: i < 2 ? 8 : 0),
                decoration: BoxDecoration(
                  color: i <= controller.currentPage.value
                      ? AppTheme.primaryColor
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoPage(FormController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Basic Information',
              style: Get.textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Let\'s start with your basic details',
              style: Get.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),
            
            CustomInputField(
              label: 'Full Name',
              hint: 'Enter your full name',
              controller: controller.nameController,
              prefixIcon: Icons.person_outlined,
              required: true,
              validator: Validators.name,
            ),
            
            const SizedBox(height: 20),
            
            NumberInputField(
              label: 'Age',
              hint: 'Enter your age',
              controller: controller.ageController,
              required: true,
              min: AppConstants.minAge,
              max: AppConstants.maxAge,
            ),
            
            const SizedBox(height: 20),
            
            Obx(() => GenderDropdown(
              value: controller.gender.value,
              onChanged: (value) => controller.gender.value = value,
              required: true,
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildDemographicInfoPage(FormController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Demographic Information',
            style: Get.textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Help us understand your background',
            style: Get.textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          
          Obx(() => OccupationDropdown(
            value: controller.occupation.value,
            onChanged: (value) => controller.occupation.value = value,
            required: true,
          )),
          
          const SizedBox(height: 20),
          
          CustomInputField(
            label: 'Annual Income (₹)',
            hint: 'Enter your annual income',
            controller: controller.incomeController,
            keyboardType: TextInputType.number,
            prefixIcon: Icons.currency_rupee,
            required: true,
            validator: Validators.income,
          ),
          
          const SizedBox(height: 20),
          
          Obx(() => StateDropdown(
            value: controller.state.value,
            onChanged: (value) => controller.state.value = value,
            required: true,
          )),
          
          const SizedBox(height: 20),
          
          CustomInputField(
            label: 'District',
            hint: 'Enter your district (optional)',
            controller: controller.districtController,
            prefixIcon: Icons.location_city,
          ),
          
          const SizedBox(height: 20),
          
          Obx(() => CategoryDropdown(
            value: controller.category.value,
            onChanged: (value) => controller.category.value = value,
            required: true,
          )),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfoPage(FormController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Additional Information',
            style: Get.textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'These details help us find more relevant schemes',
            style: Get.textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          
          Obx(() => EducationDropdown(
            value: controller.educationLevel.value,
            onChanged: (value) => controller.educationLevel.value = value,
            required: true,
          )),
          
          const SizedBox(height: 20),
          
          
          _buildBooleanField(
            'Below Poverty Line',
            'Are you below the poverty line?',
            controller.isBelowPovertyLine,
          ),
          
          const SizedBox(height: 16),
          
          _buildBooleanField(
            'Married',
            'What is your marital status?',
            controller.isMarried,
          ),
          
          const SizedBox(height: 16),
          
          _buildBooleanField(
            'Has Disability',
            'Do you have any disability?',
            controller.hasDisability,
          ),
          
          const SizedBox(height: 20),
          
          NumberInputField(
            label: 'Number of Children',
            hint: 'Enter number of children (optional)',
            controller: controller.childrenController,
            min: 0,
            max: 20,
          ),
          
          const SizedBox(height: 20),
          
          Obx(() => CustomDropdown<String>(
            label: 'Land Ownership',
            hint: 'Select land ownership type',
            value: controller.landOwnership.value,
            items: AppConstants.landOwnershipTypes,
            itemLabel: (item) => item,
            onChanged: (value) => controller.landOwnership.value = value,
          )),
          
          const SizedBox(height: 20),
          
        
          _buildInterestsSection(controller),
        ],
      ),
    );
  }

  Widget _buildBooleanField(String label, String question, RxnBool value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => Row(
          children: [
            Expanded(
              child: RadioListTile<bool>(
                title: const Text('Yes'),
                value: true,
                groupValue: value.value,
                onChanged: (val) => value.value = val,
                contentPadding: EdgeInsets.zero,
              ),
            ),
            Expanded(
              child: RadioListTile<bool>(
                title: const Text('No'),
                value: false,
                groupValue: value.value,
                onChanged: (val) => value.value = val,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        )),
      ],
    );
  }

  Widget _buildInterestsSection(FormController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Areas of Interest',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Select areas you\'re interested in (optional)',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 16),
        Obx(() => Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AppConstants.interestAreas.map((interest) {
            final isSelected = controller.selectedInterests.contains(interest);
            return FilterChip(
              label: Text(interest),
              selected: isSelected,
              onSelected: (selected) => controller.toggleInterest(interest),
              selectedColor: AppTheme.primaryColor.withOpacity(0.2),
              checkmarkColor: AppTheme.primaryColor,
            );
          }).toList(),
        )),
      ],
    );
  }

  Widget _buildNavigationButtons(FormController controller) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          if (controller.currentPage.value > 0)
            Expanded(
              child: CustomButton(
                text: 'Previous',
                onPressed: controller.previousPage,
                isOutlined: true,
              ),
            ),
          if (controller.currentPage.value > 0) const SizedBox(width: 16),
          Expanded(
            child: Obx(() => CustomButton(
              text: controller.currentPage.value == 2 
                  ? 'Find Schemes' 
                  : 'Next',
              onPressed: controller.currentPage.value == 2
                  ? controller.submitForm
                  : controller.nextPage,
              isLoading: controller.isSubmitting.value,
            )),
          ),
        ],
      ),
    );
  }
}
