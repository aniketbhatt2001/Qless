import 'package:canteen_mangement/core/utils/custom_snackbar.dart';
import 'package:canteen_mangement/features/payment/payment_service.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';

enum PaymentStatus { idle, processing, success, failed }

class PaymentController extends GetxController {
  final PaymentService _paymentService;

  PaymentController({required PaymentService paymentService})
      : _paymentService = paymentService;

  final Rx<PaymentStatus> status = PaymentStatus.idle.obs;

  /// Returns true if payment succeeded, false otherwise.
  Future<bool> processPayment({
    required double totalAmount, // in rupees
    String currency = 'inr',
  }) async {
    try {
      status.value = PaymentStatus.processing;

      // Convert ₹ to paise (smallest unit)
      final amountInPaise = (totalAmount * 100).toInt();

      final clientSecret = await _paymentService.createPaymentIntent(
        amountInPaise: amountInPaise,
        currency: currency,
      );

      await _paymentService.initAndPresentPaymentSheet(
        clientSecret: clientSecret,
        merchantDisplayName: 'QuickerQ Canteen',
      );

      status.value = PaymentStatus.success;
      return true;
    } on StripeException catch (e) {
      // User cancelled or card declined
      final msg = e.error.localizedMessage ?? e.error.message ?? 'Payment cancelled';
      if (e.error.code != FailureCode.Canceled) {
        CustomSnackbar.show(title: 'Payment Failed', message: msg, isError: true);
        status.value = PaymentStatus.failed;
      } else {
        status.value = PaymentStatus.idle;
      }
      return false;
    } catch (e) {
      CustomSnackbar.show(
        title: 'Payment Error',
        message: e.toString(),
        isError: true,
      );
      status.value = PaymentStatus.failed;
      return false;
    }
  }

  void reset() => status.value = PaymentStatus.idle;
}
