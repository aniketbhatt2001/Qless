import 'package:dio/dio.dart';
import 'package:canteen_mangement/core/constants/api_endpoints.dart';
import 'package:canteen_mangement/core/errors/app_error_handler.dart';
import '../models/cart_model.dart';

abstract class CartRemoteDataSource {
  Future<CartModel> getCart();
  Future<CartModel> addToCart(String menuItemId, int quantity);
  Future<CartModel> updateCartItem(String menuItemId, int quantity);
  Future<CartModel> removeCartItem(String menuItemId);
  Future<void> clearCart();
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final Dio _dio;
  CartRemoteDataSourceImpl(this._dio);

  @override
  Future<CartModel> getCart() async {
    try {
      final response = await _dio.get(ApiEndpoints.getCart);
      return CartModel.fromJson(response.data);
    } catch (e) {
      throw AppErrorHandler.handle(e);
    }
  }

  @override
  Future<CartModel> addToCart(String menuItemId, int quantity) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.addToCart,
        data: {'menuItemId': menuItemId, 'quantity': quantity},
      );
      return CartModel.fromJson(response.data);
    } catch (e) {
      throw AppErrorHandler.handle(e);
    }
  }

  @override
  Future<CartModel> updateCartItem(String menuItemId, int quantity) async {
    try {
      final response = await _dio.put(
        ApiEndpoints.updateCartItem(menuItemId),
        data: {'quantity': quantity},
      );
      return CartModel.fromJson(response.data);
    } catch (e) {
      throw AppErrorHandler.handle(e);
    }
  }

  @override
  Future<CartModel> removeCartItem(String menuItemId) async {
    try {
      final response = await _dio.delete(ApiEndpoints.removeCartItem(menuItemId));
      return CartModel.fromJson(response.data);
    } catch (e) {
      throw AppErrorHandler.handle(e);
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      await _dio.delete(ApiEndpoints.clearCart);
    } catch (e) {
      throw AppErrorHandler.handle(e);
    }
  }
}
