import 'dart:developer';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentService {
  static const String _backendUrl = 'https://qless-d1u4.onrender.com/api';

  /// Creates a Razorpay order on the backend and returns the order id.
  Future<Map<String, dynamic>> createOrder({
    required int amountInPaise,
    required String currency,
  }) async {
    final response = await http.post(
      Uri.parse('$_backendUrl/payments/create-order'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'amount': amountInPaise, 'currency': currency}),
    );
    log('createOrder response: ${response.body}');

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create order: ${response.body}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return data;
  }
}
