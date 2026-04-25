import 'dart:async';

import 'package:canteen_mangement/core/errors/app_error_handler.dart';
import 'package:canteen_mangement/core/utils/custom_snackbar.dart';
import 'package:canteen_mangement/features/auth/presentation/controllers/auth_controller.dart';
import 'package:canteen_mangement/features/cart/presentation/controllers/cart_controller.dart';
import 'package:canteen_mangement/features/order/domain/entities/order_entity.dart';
import 'package:canteen_mangement/features/order/domain/repositories/order_repository.dart';
import 'package:canteen_mangement/features/order/domain/usecases/get_my_orders_usecase.dart';
import 'package:canteen_mangement/features/order/domain/usecases/get_order_status_usecase.dart';
import 'package:canteen_mangement/features/order/domain/usecases/place_order_usecase.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  final PlaceOrderUseCase _placeOrderUseCase;
  final GetMyOrdersUseCase _getMyOrdersUseCase;
  final GetOrderStatusUseCase _getOrderStatusUseCase;
  final OrderRepository _orderRepository;

  OrderController({
    required PlaceOrderUseCase placeOrderUseCase,
    required GetMyOrdersUseCase getMyOrdersUseCase,
    required GetOrderStatusUseCase getOrderStatusUseCase,
    required OrderRepository orderRepository,
  })  : _placeOrderUseCase = placeOrderUseCase,
        _getMyOrdersUseCase = getMyOrdersUseCase,
        _getOrderStatusUseCase = getOrderStatusUseCase,
        _orderRepository = orderRepository;

  final RxList<OrderEntity> myOrders = <OrderEntity>[].obs;
  final RxBool isLoading = false.obs;
  bool _refetching = false;

  StreamSubscription<void>? _orderUpdateSubscription;

  @override
  void onClose() {
    _orderUpdateSubscription?.cancel();
    super.onClose();
  }

  Future<void> fetchMyOrders({String? status}) async {
    try {
      isLoading.value = true;
      myOrders.value = await _getMyOrdersUseCase(GetMyOrdersParams(status: status));
      _orderUpdateSubscription?.cancel();
      _orderUpdateSubscription = _orderRepository.orderUpdates().listen((_) {
        refetchMyOrders();
      });
    } catch (e) {
      CustomSnackbar.show(
        title: 'Error',
        message: AppErrorHandler.getMessage(e),
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refetchMyOrders({String? status}) async {
    if (_refetching) return;
    try {
      _refetching = true;
      myOrders.value = await _getMyOrdersUseCase(GetMyOrdersParams(status: status));
    } catch (e) {
      CustomSnackbar.show(
        title: 'Error',
        message: AppErrorHandler.getMessage(e),
        isError: true,
      );
    } finally {
      _refetching = false;
    }
  }

  Future<bool> placeOrderFromCart() async {
    try {
      isLoading.value = true;
      final cartController = Get.find<CartController>();
      final authController = Get.find<AuthController>();

      final cart = cartController.cart.value;
      if (cart == null || cart.items.isEmpty) {
        CustomSnackbar.show(title: 'Error', message: 'Cart is empty', isError: true);
        return false;
      }

      await _placeOrderUseCase(
        PlaceOrderParams(
          customerName: authController.user.value?.name ?? 'Guest',
          items: cart.items
              .map(
                (e) => OrderItemEntity(
                  menuItemId: e.menuItem.id,
                  quantity: e.quantity,
                  name: e.menuItem.name,
                  price: e.menuItem.price,
                ),
              )
              .toList(),
        ),
      );

      CustomSnackbar.show(title: 'Success', message: 'Order placed successfully');
      cartController.cart.value = null;
      return true;
    } catch (e) {
      CustomSnackbar.show(
        title: 'Error',
        message: AppErrorHandler.getMessage(e),
        isError: true,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<OrderEntity?> getOrderStatus(String id) async {
    try {
      return await _getOrderStatusUseCase(id);
    } catch (e) {
      CustomSnackbar.show(
        title: 'Error',
        message: AppErrorHandler.getMessage(e),
        isError: true,
      );
      return null;
    }
  }
}
