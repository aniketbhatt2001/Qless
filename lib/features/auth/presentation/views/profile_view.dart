import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:canteen_mangement/features/auth/presentation/controllers/auth_controller.dart';
import 'package:canteen_mangement/core/utils/responsive.dart';
import 'package:canteen_mangement/core/widgets/common_app_bar.dart';

class ProfileView extends StatelessWidget {
  final AuthController _authController = Get.find<AuthController>();

  ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const CommonAppBar(title: "Profile"),
      body: Obx(() {
        final user = _authController.user.value;
        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }
        final fullName = user.name;
        final content = _buildProfileContent(context, fullName, user);

        if (Responsive.isDesktop(context)) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: content,
            ),
          );
        }
        return content;
      }),
    );
  }

  Widget _buildProfileContent(BuildContext context, String fullName, dynamic user) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "PERSONAL INFORMATION",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0EA5E9),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildInfoField("FULL NAME", fullName),
                  const SizedBox(height: 20),
                  _buildInfoField(
                    "MOBILE NUMBER",
                    user.phone.startsWith('+91')
                        ? user.phone
                        : '+91 ${user.phone}',
                  ),
                  const SizedBox(height: 20),
                  _buildInfoField(
                    "EMAIL ADDRESS",
                    "${fullName.toLowerCase().replaceAll(' ', '.')}@example.com",
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: () => _showUpdateProfileDialog(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF0EA5E9)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        foregroundColor: const Color(0xFF0EA5E9),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.edit, size: 20),
                          SizedBox(width: 8),
                          Text("Update Profile",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    width: double.infinity,
                    height: 58,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0EA5E9).withValues(alpha: 0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      onPressed: () => _confirmLogout(context),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout, size: 22),
                          SizedBox(width: 12),
                          Text("Logout Account",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Builder(
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF64748B),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: BoxDecoration(
                // color: Theme.of(context).colorScheme.surfc,
                // color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Text(
                value.isEmpty ? "Not provided" : value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF0F172A),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _confirmLogout(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Logout",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              "Are you sure you want to log out of your account?",
              style: TextStyle(color: Color(0xFF64748B)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      _authController.logout();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Logout"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showUpdateProfileDialog(BuildContext context) {
    final nameController = TextEditingController(
      text: _authController.user.value?.name,
    );
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    Get.bottomSheet(
      isScrollControlled: true,
      Container(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Update Profile",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildTextField(
                label: "NAME",
                controller: nameController,
                hint: "Enter your name",
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? "Name is required"
                            : null,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                label: "CURRENT PASSWORD",
                controller: currentPasswordController,
                hint: "Enter current password (optional)",
                isPassword: true,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                label: "NEW PASSWORD",
                controller: newPasswordController,
                hint: "Enter new password (optional)",
                isPassword: true,
              ),
              const SizedBox(height: 32),
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed:
                        _authController.isLoading.value
                            ? null
                            : () {
                              if (formKey.currentState!.validate()) {
                                _authController.updateProfile(
                                  name: nameController.text.trim(),
                                  currentPassword:
                                      currentPasswordController.text.isEmpty
                                          ? null
                                          : currentPasswordController.text,
                                  newPassword:
                                      newPasswordController.text.isEmpty
                                          ? null
                                          : newPasswordController.text,
                                );
                              }
                            },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0EA5E9),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child:
                        _authController.isLoading.value
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text(
                              "Update Profile",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Color(0xFF64748B),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF0EA5E9)),
            ),
          ),
        ),
      ],
    );
  }
}
