import 'package:flutter/material.dart';

class Responsive {
  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < 768;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 768;

  static double maxContentWidth = 1200;

  static Widget builder({
    required BuildContext context,
    required Widget mobile,
    required Widget desktop,
  }) {
    return isDesktop(context) ? desktop : mobile;
  }
}
