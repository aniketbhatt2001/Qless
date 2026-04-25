import 'package:canteen_mangement/core/theme/custom%20theme_tokens.dart';
import 'package:canteen_mangement/core/utils/custom_snackbar.dart';
import 'package:canteen_mangement/core/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:canteen_mangement/features/auth/presentation/controllers/auth_controller.dart';
import 'package:lucide_icons/lucide_icons.dart';

class RegisterView extends StatelessWidget {
  final AuthController _authController = Get.find<AuthController>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final RxBool _isPasswordVisible = false.obs;
  final RxBool _isConfirmPasswordVisible = false.obs;

  RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive.isDesktop(context)
        ? _buildDesktop(context)
        : _buildMobile(context);
  }

  Widget _buildMobile(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = context.tokens;
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: _formContent(context, theme, tokens),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktop(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = context.tokens;
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Row(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0EA5E9), Color(0xFF06B6D4)],
                ),
              ),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(LucideIcons.utensilsCrossed, color: Colors.white, size: 72),
                    SizedBox(height: 24),
                    Text(
                      'QuickerQ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Order smarter, eat faster.',
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: 520,
            color: Colors.white,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 32),
                child: _formContent(context, theme, tokens),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _formContent(BuildContext context, ThemeData theme, AppTokens tokens) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (Responsive.isMobile(context)) ...[
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(tokens.rXl),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(LucideIcons.utensilsCrossed, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 32),
          Text(
            'Join',
            style: theme.textTheme.displaySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
            ),
          ),
          Text('QuickerQ', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 12),
          Text('Create your account to get started', style: theme.textTheme.bodyMedium),
          const SizedBox(height: 40),
        ] else ...[
          Text(
            'Create Account',
            style: theme.textTheme.displaySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 8),
          Text('Fill in your details to get started', style: theme.textTheme.bodyMedium),
          const SizedBox(height: 32),
        ],
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(tokens.rXl),
            boxShadow: tokens.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Full Name', style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Enter your full name',
                  prefixIcon: Icon(LucideIcons.user),
                ),
              ),
              const SizedBox(height: 20),
              Text('Email Address', style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Enter your email',
                  prefixIcon: Icon(LucideIcons.mail),
                ),
              ),
              const SizedBox(height: 20),
              Text('Mobile Number', style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: 'Enter 10-digit mobile num',
                  prefixIcon: Icon(LucideIcons.phone),
                ),
              ),
              const SizedBox(height: 20),
              Text('Password', style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              Obx(
                () => TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible.value,
                  decoration: InputDecoration(
                    hintText: 'Minimum 6 characters',
                    prefixIcon: const Icon(LucideIcons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible.value ? LucideIcons.eye : LucideIcons.eyeOff,
                        size: 20,
                      ),
                      onPressed: () => _isPasswordVisible.toggle(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('Confirm Password', style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              Obx(
                () => TextField(
                  controller: _confirmPasswordController,
                  obscureText: !_isConfirmPasswordVisible.value,
                  decoration: InputDecoration(
                    hintText: 'Re-enter your password',
                    prefixIcon: const Icon(LucideIcons.checkCircle2),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible.value
                            ? LucideIcons.eye
                            : LucideIcons.eyeOff,
                        size: 20,
                      ),
                      onPressed: () => _isConfirmPasswordVisible.toggle(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Obx(
                () => _authController.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: () {
                          if (_passwordController.text != _confirmPasswordController.text) {
                            CustomSnackbar.show(
                              title: 'Error',
                              message: 'Passwords do not match',
                              isError: true,
                            );
                            return;
                          }
                          _authController.register(
                            _nameController.text,
                            _phoneController.text,
                            _passwordController.text,
                          );
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Create Account'),
                            SizedBox(width: 8),
                            Icon(LucideIcons.arrowRight, size: 20),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Already have an account? ', style: theme.textTheme.bodyMedium),
            GestureDetector(
              onTap: () => Get.back(),
              child: Text(
                'Sign In',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 48),
      ],
    );
  }
}
