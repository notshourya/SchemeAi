import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/data/services/firebase_service.dart';
import '../../app/routes/app_pages.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/widgets/custom_input_field.dart';
import '../../shared/utils/validators.dart';
import '../../shared/theme/app_theme.dart';

class RegisterController extends GetxController {
  final FirebaseService _firebaseService = Get.find<FirebaseService>();
  
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  
  final isLoading = false.obs;
  final obscurePassword = true.obs;
  final obscureConfirmPassword = true.obs;
  final acceptTerms = false.obs;

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  void toggleAcceptTerms() {
    acceptTerms.value = !acceptTerms.value;
  }

  String? validateConfirmPassword(String? value) {
    return Validators.confirmPassword(value, passwordController.text);
  }

  Future<void> signUpWithEmail() async {
    if (!formKey.currentState!.validate()) return;
    
    if (!acceptTerms.value) {
      Get.snackbar(
        'Terms Required',
        'Please accept the terms and conditions',
        backgroundColor: AppTheme.warningColor,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      
      await _firebaseService.signUpWithEmailPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
        name: nameController.text.trim(),
      );
      
      Get.offAllNamed(Routes.HOME);
      Get.snackbar(
        'Success',
        'Account created successfully!',
        backgroundColor: AppTheme.successColor,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Registration Failed',
        e.toString(),
        backgroundColor: AppTheme.errorColor,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUpWithGoogle() async {
    if (!acceptTerms.value) {
      Get.snackbar(
        'Terms Required',
        'Please accept the terms and conditions',
        backgroundColor: AppTheme.warningColor,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      
      await _firebaseService.signInWithGoogle();
      
      Get.offAllNamed(Routes.HOME);
      Get.snackbar(
        'Success',
        'Welcome!',
        backgroundColor: AppTheme.successColor,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Google Sign-Up Failed',
        e.toString(),
        backgroundColor: AppTheme.errorColor,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void goToLogin() {
    Get.back();
  }
}

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegisterController());
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                
                // Back Button
                IconButton(
                  onPressed: controller.goToLogin,
                  icon: const Icon(Icons.arrow_back),
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                ),
                
                const SizedBox(height: 20),
                
                // Header
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create Account',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Join us to discover government schemes tailored for you',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 40),
                
                // Name Field
                CustomInputField(
                  label: 'Full Name',
                  hint: 'Enter your full name',
                  controller: controller.nameController,
                  prefixIcon: Icons.person_outlined,
                  required: true,
                  validator: Validators.name,
                ),
                
                const SizedBox(height: 20),
                
                // Email Field
                EmailInputField(
                  controller: controller.emailController,
                  required: true,
                ),
                
                const SizedBox(height: 20),
                
                // Password Field
                Obx(() => CustomInputField(
                  label: 'Password',
                  hint: 'Create a strong password',
                  controller: controller.passwordController,
                  obscureText: controller.obscurePassword.value,
                  prefixIcon: Icons.lock_outlined,
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.obscurePassword.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: controller.togglePasswordVisibility,
                  ),
                  required: true,
                  validator: Validators.password,
                )),
                
                const SizedBox(height: 20),
                
                // Confirm Password Field
                Obx(() => CustomInputField(
                  label: 'Confirm Password',
                  hint: 'Re-enter your password',
                  controller: controller.confirmPasswordController,
                  obscureText: controller.obscureConfirmPassword.value,
                  prefixIcon: Icons.lock_outlined,
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.obscureConfirmPassword.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: controller.toggleConfirmPasswordVisibility,
                  ),
                  required: true,
                  validator: controller.validateConfirmPassword,
                )),
                
                const SizedBox(height: 24),
                
                // Terms and Conditions
                Obx(() => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: controller.acceptTerms.value,
                      onChanged: (_) => controller.toggleAcceptTerms(),
                      activeColor: AppTheme.primaryColor,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: controller.toggleAcceptTerms,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text.rich(
                            TextSpan(
                              text: 'I accept the ',
                              style: TextStyle(color: Colors.grey[600]),
                              children: [
                                TextSpan(
                                  text: 'Terms and Conditions',
                                  style: TextStyle(
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                TextSpan(
                                  text: ' and ',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: TextStyle(
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
                
                const SizedBox(height: 32),
                
                // Sign Up Button
                Obx(() => CustomButton(
                  text: 'Create Account',
                  onPressed: controller.signUpWithEmail,
                  isLoading: controller.isLoading.value,
                  width: double.infinity,
                )),
                
                const SizedBox(height: 24),
                
                // Divider
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'or',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Google Sign Up Button
                Obx(() => CustomButton(
                  text: 'Continue with Google',
                  icon: Icons.login,
                  onPressed: controller.signUpWithGoogle,
                  isLoading: controller.isLoading.value,
                  isOutlined: true,
                  width: double.infinity,
                )),
                
                const SizedBox(height: 32),
                
                // Sign In Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    GestureDetector(
                      onTap: controller.goToLogin,
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
