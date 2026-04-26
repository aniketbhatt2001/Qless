import 'package:canteen_mangement/features/payment/payment_controller.dart';
import 'package:canteen_mangement/features/payment/payment_service.dart';
import 'package:get/get.dart';

class PaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentService>(() => PaymentService());
    Get.lazyPut<PaymentController>(
      () => PaymentController(
        paymentService: Get.find<PaymentService>(),
      ),
    );
  }
}
