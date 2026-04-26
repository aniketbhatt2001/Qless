import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

/// Handles Stripe PaymentIntent creation and sheet presentation.
/// Replace [_backendUrl] with your actual backend endpoint.
class PaymentService {
  // Android emulator uses 10.0.2.2 to reach host localhost.
  // For a physical device, replace with your machine's local IP (e.g. http://192.168.1.x:4242/api).
  // For production, replace with your deployed URL.
  static const String _backendUrl = 'https://qless-d1u4.onrender.com/api';

  /// Creates a PaymentIntent on your backend and returns the clientSecret.
  Future<String> createPaymentIntent({
    required int amountInPaise,
    required String currency,
  }) async {
    final response = await http.post(
      Uri.parse('$_backendUrl/payments/create-intent'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'amount': amountInPaise,
        'currency': currency,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create payment intent: ${response.body}');
    }

    final data = jsonDecode(response.body);
    final clientSecret = data['clientSecret'] as String?;
    if (clientSecret == null) {
      throw Exception('clientSecret missing in response');
    }
    return clientSecret;
  }

  /// Initialises the Stripe payment sheet and presents it.
  Future<void> initAndPresentPaymentSheet({
    required String clientSecret,
    required String merchantDisplayName,
  }) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: merchantDisplayName,
        style: ThemeMode.light,
        appearance: const PaymentSheetAppearance(
          colors: PaymentSheetAppearanceColors(
            primary: Color(0xFF6366F1),
          ),
          shapes: PaymentSheetShape(
            borderRadius: 12,
          ),
        ),
      ),
    );

    await Stripe.instance.presentPaymentSheet();
  }
}
