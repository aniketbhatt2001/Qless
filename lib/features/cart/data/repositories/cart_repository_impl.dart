import 'package:canteen_mangement/features/cart/domain/entities/cart_entity.dart';
import 'package:canteen_mangement/features/cart/domain/repositories/cart_repository.dart';
import '../datasources/cart_remote_data_source.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource _remote;
  CartRepositoryImpl(this._remote);

  @override
  Future<CartEntity> getCart() async {
    final model = await _remote.getCart();
    return model.toEntity();
  }

  @override
  Future<CartEntity> addToCart(String menuItemId, int quantity) async {
    final model = await _remote.addToCart(menuItemId, quantity);
    return model.toEntity();
  }

  @override
  Future<CartEntity> updateCartItem(String menuItemId, int quantity) async {
    final model = await _remote.updateCartItem(menuItemId, quantity);
    return model.toEntity();
  }

  @override
  Future<CartEntity> removeCartItem(String menuItemId) async {
    final model = await _remote.removeCartItem(menuItemId);
    return model.toEntity();
  }

  @override
  Future<void> clearCart() => _remote.clearCart();
}
