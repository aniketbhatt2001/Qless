import 'package:canteen_mangement/core/errors/app_error_handler.dart';
import 'package:canteen_mangement/core/usecases/usecase.dart';
import 'package:canteen_mangement/core/utils/custom_snackbar.dart';
import 'package:canteen_mangement/features/cart/domain/entities/cart_entity.dart';
import 'package:canteen_mangement/features/cart/domain/entities/cart_item_entity.dart';
import 'package:canteen_mangement/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:canteen_mangement/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:canteen_mangement/features/cart/domain/usecases/get_cart_usecase.dart';
import 'package:canteen_mangement/features/cart/domain/usecases/remove_cart_item_usecase.dart';
import 'package:canteen_mangement/features/cart/domain/usecases/update_cart_item_usecase.dart';
import 'package:canteen_mangement/features/menu/domain/entities/menu_item_entity.dart';
import 'package:canteen_mangement/features/menu/presentation/controllers/menu_controller.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  final GetCartUseCase _getCartUseCase;
  final AddToCartUseCase _addToCartUseCase;
  final UpdateCartItemUseCase _updateCartItemUseCase;
  final RemoveCartItemUseCase _removeCartItemUseCase;
  final ClearCartUseCase _clearCartUseCase;

  CartController({
    required GetCartUseCase getCartUseCase,
    required AddToCartUseCase addToCartUseCase,
    required UpdateCartItemUseCase updateCartItemUseCase,
    required RemoveCartItemUseCase removeCartItemUseCase,
    required ClearCartUseCase clearCartUseCase,
  })  : _getCartUseCase = getCartUseCase,
        _addToCartUseCase = addToCartUseCase,
        _updateCartItemUseCase = updateCartItemUseCase,
        _removeCartItemUseCase = removeCartItemUseCase,
        _clearCartUseCase = clearCartUseCase;

  final Rxn<CartEntity> cart = Rxn<CartEntity>();
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCart();
  }

  int getItemQuantity(String menuItemId) {
    if (cart.value == null) return 0;
    final item = cart.value!.items.firstWhereOrNull(
      (i) => i.menuItem.id == menuItemId,
    );
    return item?.quantity ?? 0;
  }

  int get totalItems => cart.value?.items.length ?? 0;

  Future<void> fetchCart() async {
    try {
      isLoading.value = true;
      cart.value = await _getCartUseCase(const NoParams());
    } catch (_) {
      // Cart may be empty — handle gracefully
    } finally {
      isLoading.value = false;
    }
  }

  void _updateCartLocally(
    String menuItemId,
    int quantity, {
    MenuItemEntity? menuItem,
    bool isAbsolute = false,
  }) {
    List<CartItemEntity> items = List.from(cart.value?.items ?? []);
    final existingIndex = items.indexWhere((i) => i.menuItem.id == menuItemId);

    if (existingIndex != -1) {
      final int newQty =
          isAbsolute ? quantity : items[existingIndex].quantity + quantity;
      if (newQty <= 0) {
        items.removeAt(existingIndex);
      } else {
        items[existingIndex] = CartItemEntity(
          menuItem: items[existingIndex].menuItem,
          quantity: newQty,
        );
      }
    } else if (menuItem != null && quantity > 0) {
      items.add(CartItemEntity(menuItem: menuItem, quantity: quantity));
    } else {
      return;
    }

    final newTotal = items.fold(
      0.0,
      (sum, i) => sum + (i.menuItem.price * i.quantity),
    );
    cart.value = CartEntity(id: cart.value?.id, items: items, totalPrice: newTotal);
  }

  Future<void> addItem(
    String menuItemId,
    int quantity, {
    bool showLoading = false,
    bool showSnackbar = true,
  }) async {
    final previousCart = cart.value;
    final menuItem = Get.find<MenuController>()
        .menuItems
        .firstWhereOrNull((i) => i.id == menuItemId);
    _updateCartLocally(menuItemId, quantity, menuItem: menuItem);

    try {
      if (showLoading) isLoading.value = true;
      cart.value = await _addToCartUseCase(
        AddToCartParams(menuItemId: menuItemId, quantity: quantity),
      );
    } catch (e) {
      cart.value = previousCart;
      CustomSnackbar.show(
        title: 'Error',
        message: AppErrorHandler.getMessage(e),
        isError: true,
      );
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  Future<void> updateItem(
    String menuItemId,
    int quantity, {
    bool showLoading = false,
    bool showSnackbar = false,
  }) async {
    final previousCart = cart.value;
    _updateCartLocally(menuItemId, quantity, isAbsolute: true);

    try {
      if (showLoading) isLoading.value = true;
      await _updateCartItemUseCase(
        UpdateCartItemParams(menuItemId: menuItemId, quantity: quantity),
      );
    } catch (e) {
      cart.value = previousCart;
      CustomSnackbar.show(
        title: 'Error',
        message: AppErrorHandler.getMessage(e),
        isError: true,
      );
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  Future<void> removeItem(String menuItemId) async {
    final previousCart = cart.value;
    _updateCartLocally(menuItemId, 0, isAbsolute: true);

    try {
      cart.value = await _removeCartItemUseCase(RemoveCartItemParams(menuItemId));
    } catch (e) {
      cart.value = previousCart;
      CustomSnackbar.show(
        title: 'Error',
        message: AppErrorHandler.getMessage(e),
        isError: true,
      );
    }
  }

  Future<void> clearCart() async {
    final previousCart = cart.value;
    cart.value = null;

    try {
      await _clearCartUseCase(const NoParams());
    } catch (e) {
      cart.value = previousCart;
      CustomSnackbar.show(
        title: 'Error',
        message: AppErrorHandler.getMessage(e),
        isError: true,
      );
    }
  }
}
