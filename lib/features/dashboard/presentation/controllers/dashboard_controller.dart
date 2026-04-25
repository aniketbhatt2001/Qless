import 'package:canteen_mangement/features/auth/presentation/controllers/auth_controller.dart';
import 'package:canteen_mangement/features/cart/presentation/controllers/cart_controller.dart';
import 'package:canteen_mangement/features/order/presentation/controllers/order_controller.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  static int get currentId =>
      Get.find<DashboardController>().currentIndex.value;

  final currentIndex = 0.obs;
  final lastTabIndex = 0.obs;

  void changeIndex(int index) {
    if (index != 2) {
      lastTabIndex.value = index;
    }

    if (currentIndex.value == index) {
      final navigator = Get.nestedKey(index)?.currentState;
      if (navigator != null && navigator.canPop()) {
        navigator.popUntil((route) => route.isFirst);
      }
    } else {
      currentIndex.value = index;

      if (index == 1) {
        Get.find<CartController>().fetchCart();
      } else if (index == 3) {
        Get.find<OrderController>().fetchMyOrders();
      } else if (index == 4) {
        Get.find<AuthController>().getProfile();
      }
    }
  }
}
