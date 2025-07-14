import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/data/services/firebase_service.dart';
import '../../app/routes/app_pages.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/widgets/custom_input_field.dart';
import '../../shared/utils/validators.dart';
import '../../shared/theme/app_theme.dart';

class LoginController extends GetxController {
  final FirebaseService _firebaseService = Get.find<FirebaseService>();
  
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  final isLoading = false.obs;
  final obscurePassword = true.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> signInWithEmail() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;
      
      await _firebaseService.signInWithEmailPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      
      Get.offAllNamed(Routes.HOME);
      Get.snackbar(
        'Success',
        'Welcome back!',
        backgroundColor: AppTheme.successColor,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Login Failed',
        e.toString(),
        backgroundColor: AppTheme.errorColor,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
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
        'Google Sign-In Failed',
        e.toString(),
        backgroundColor: AppTheme.errorColor,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void goToRegister() {
    Get.toNamed(Routes.REGISTER);
  }

  void resetPassword() async {
    if (emailController.text.trim().isEmpty) {
      Get.snackbar(
        'Email Required',
        'Please enter your email address',
        backgroundColor: AppTheme.warningColor,
        colorText: Colors.white,
      );
      return;
    }

    try {
      await _firebaseService.resetPassword(emailController.text.trim());
      Get.snackbar(
        'Password Reset',
        'Password reset email sent successfully',
        backgroundColor: AppTheme.successColor,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Reset Failed',
        e.toString(),
        backgroundColor: AppTheme.errorColor,
        colorText: Colors.white,
      );
    }
  }
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                
                // Header
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome Back',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in to find relevant government schemes',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 48),
                
                // Email Field
                EmailInputField(
                  controller: controller.emailController,
                  required: true,
                ),
                
                const SizedBox(height: 20),
                
                // Password Field
                Obx(() => CustomInputField(
                  label: 'Password',
                  hint: 'Enter your password',
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
                
                const SizedBox(height: 16),
                
                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: controller.resetPassword,
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Sign In Button
                Obx(() => CustomButton(
                  text: 'Sign In',
                  onPressed: controller.signInWithEmail,
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
                
                // Google Sign In Button
                Obx(() => CustomButton(
                  text: 'Continue with Google',
                  icon: Icons.login,
                  onPressed: controller.signInWithGoogle,
                  isLoading: controller.isLoading.value,
                  isOutlined: true,
                  width: double.infinity,
                )),
                
                const SizedBox(height: 32),
                
                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    GestureDetector(
                      onTap: controller.goToRegister,
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
