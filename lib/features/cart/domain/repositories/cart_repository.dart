import '../entities/cart_entity.dart';

abstract class CartRepository {
  Future<CartEntity> getCart();
  Future<CartEntity> addToCart(String menuItemId, int quantity);
  Future<CartEntity> updateCartItem(String menuItemId, int quantity);
  Future<CartEntity> removeCartItem(String menuItemId);
  Future<void> clearCart();
}
