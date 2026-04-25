import 'package:dio/dio.dart';
import 'package:canteen_mangement/core/constants/api_endpoints.dart';
import 'package:canteen_mangement/core/errors/app_error_handler.dart';
import '../models/menu_item_model.dart';

abstract class MenuRemoteDataSource {
  Future<List<MenuItemModel>> getMenuItems();
  Future<List<MenuItemModel>> getMenuItemsByCategory(String category);
  Future<MenuItemModel> getMenuItem(String id);
}

class MenuRemoteDataSourceImpl implements MenuRemoteDataSource {
  final Dio _dio;
  MenuRemoteDataSourceImpl(this._dio);

  @override
  Future<List<MenuItemModel>> getMenuItems() async {
    try {
      final response = await _dio.get(ApiEndpoints.getMenuItems);
      return (response.data as List).map((e) => MenuItemModel.fromJson(e)).toList();
    } catch (e) {
      throw AppErrorHandler.handle(e);
    }
  }

  @override
  Future<List<MenuItemModel>> getMenuItemsByCategory(String category) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.getMenuItems,
        queryParameters: {'category': category},
      );
      return (response.data as List).map((e) => MenuItemModel.fromJson(e)).toList();
    } catch (e) {
      throw AppErrorHandler.handle(e);
    }
  }

  @override
  Future<MenuItemModel> getMenuItem(String id) async {
    try {
      final response = await _dio.get(ApiEndpoints.getMenuItem(id));
      return MenuItemModel.fromJson(response.data);
    } catch (e) {
      throw AppErrorHandler.handle(e);
    }
  }
}
