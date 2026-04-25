import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackbar {
  static void show({
    required String title,
    required String message,
    bool isError = false,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: isError ? Colors.red.shade800 : Colors.green.shade800,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      icon: Icon(
        isError ? Icons.error_outline : Icons.check_circle_outline,
        color: Colors.white,
      ),
      duration: const Duration(seconds: 3),
      snackStyle: SnackStyle.FLOATING,
    );
  }
}
