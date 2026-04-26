import 'dart:async';
import 'dart:developer';
import 'package:canteen_mangement/core/utils/custom_snackbar.dart';
import 'package:canteen_mangement/features/payment/payment_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

enum PaymentStatus { idle, processing, success, failed }

class PaymentController extends GetxController {
  final PaymentService _paymentService;
  late final Razorpay _razorpay;

  PaymentController({required PaymentService paymentService})
    : _paymentService = paymentService;

  final Rx<PaymentStatus> status = PaymentStatus.idle.obs;

  Completer<bool>? _completer;

  @override
  void onInit() {
    super.onInit();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _onSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _onError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _onExternalWallet);
  }

  @override
  void onClose() {
    _razorpay.clear();
    super.onClose();
  }

  void _onSuccess(PaymentSuccessResponse response) {
    log('Razorpay success: ${response.paymentId}');
    status.value = PaymentStatus.success;
    _completer?.complete(true);
    _completer = null;
  }

  void _onError(PaymentFailureResponse response) {
    log('Razorpay error: ${response.code} | ${response.message}');
    if (response.code != Razorpay.PAYMENT_CANCELLED) {
      CustomSnackbar.show(
        title: 'Payment Failed',
        message: response.message ?? 'Payment failed',
        isError: true,
      );
      status.value = PaymentStatus.failed;
    } else {
      status.value = PaymentStatus.idle;
    }
    _completer?.complete(false);
    _completer = null;
  }

  void _onExternalWallet(ExternalWalletResponse response) {
    log('External wallet: ${response.walletName}');
    _completer?.complete(false);
    _completer = null;
  }

  /// Returns true if payment succeeded, false otherwise.
  Future<bool> processPayment({
    required double totalAmount,
    String currency = 'INR',
    required String userEmail,
    required String userPhone,
    required String userName,
  }) async {
    try {
      status.value = PaymentStatus.processing;

      final amountInPaise = (totalAmount * 100).toInt();

      final order = await _paymentService.createOrder(
        amountInPaise: amountInPaise,
        currency: currency,
      );

      final options = {
        'key': dotenv.env['RAZORPAY_KEY_ID'] ?? '',
        'amount': amountInPaise,
        'currency': currency,
        'order_id': order['id'],
        'name': 'QuickerQ Canteen',
        'description': 'Food Order',
        'prefill': {'contact': userPhone, 'email': userEmail, 'name': userName},
        'theme': {'color': '#6366F1'},
        'callback_url': 'quickerq://razorpay',
        'redirect': true,
      };

      _completer = Completer<bool>();
      _razorpay.open(options);
      return await _completer!.future;
    } catch (e) {
      log('processPayment error: $e');
      CustomSnackbar.show(
        title: 'Payment Error',
        message: e.toString(),
        isError: true,
      );
      status.value = PaymentStatus.failed;
      _completer = null;
      return false;
    }
  }

  void reset() => status.value = PaymentStatus.idle;
}
