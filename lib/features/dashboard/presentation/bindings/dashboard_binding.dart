import 'package:canteen_mangement/features/cart/presentation/bindings/cart_binding.dart';
import 'package:canteen_mangement/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:canteen_mangement/features/menu/presentation/bindings/menu_binding.dart';
import 'package:canteen_mangement/features/order/presentation/bindings/order_binding.dart';
import 'package:get/get.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    MenuBinding().dependencies();
    CartBinding().dependencies();
    OrderBinding().dependencies();
    Get.lazyPut(() => DashboardController(), fenix: true);
  }
}
