import 'package:flutter_alice/alice.dart';
import 'package:flutter/material.dart';

class AliceHelper {
  static final Alice alice = Alice(
    showNotification: true,
    showInspectorOnShake: true,
  );

  static GlobalKey<NavigatorState> get navigatorKey => alice.getNavigatorKey()!;
}
