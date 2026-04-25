import 'dart:async';

import 'package:dio/dio.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:canteen_mangement/core/constants/api_endpoints.dart';
import 'package:canteen_mangement/core/errors/app_error_handler.dart';
import '../models/order_model.dart';

abstract class OrderRemoteDataSource {
  Future<OrderModel> placeOrder(String customerName, List<OrderItemModel> items);
  Future<List<OrderModel>> getMyOrders({String? status});
  Future<OrderModel> getOrderStatus(String id);
  Future<void> markOrderReady(String id);
  Stream<void> listenToOrderUpdates();
  void disconnectSocket();
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final Dio _dio;
  io.Socket? _socket;
  final StreamController<void> _updateController = StreamController.broadcast();

  OrderRemoteDataSourceImpl(this._dio);

  void _connectSocket() {
    if (_socket != null && _socket!.connected) return;
    _socket = io.io(
      ApiEndpoints.socketUrl,
      io.OptionBuilder().setTransports(['websocket']).build(),
    );
    _socket?.on('queue:update', (_) => _updateController.add(null));
  }

  @override
  Future<OrderModel> placeOrder(String customerName, List<OrderItemModel> items) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.placeOrder,
        data: {
          'customerName': customerName,
          'items': items.map((i) => i.toJson()).toList(),
        },
      );
      return OrderModel.fromJson(response.data);
    } catch (e) {
      throw AppErrorHandler.handle(e);
    }
  }

  @override
  Future<List<OrderModel>> getMyOrders({String? status}) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.getMyOrders,
        queryParameters: status != null ? {'status': status} : null,
      );
      return (response.data as List).map((e) => OrderModel.fromJson(e)).toList();
    } catch (e) {
      throw AppErrorHandler.handle(e);
    }
  }

  @override
  Future<OrderModel> getOrderStatus(String id) async {
    try {
      final response = await _dio.get(ApiEndpoints.getOrderStatus(id));
      return OrderModel.fromJson(response.data);
    } catch (e) {
      throw AppErrorHandler.handle(e);
    }
  }

  @override
  Future<void> markOrderReady(String id) async {
    try {
      await _dio.patch(ApiEndpoints.markOrderReady(id));
    } catch (e) {
      throw AppErrorHandler.handle(e);
    }
  }

  @override
  Stream<void> listenToOrderUpdates() {
    _connectSocket();
    return _updateController.stream;
  }

  @override
  void disconnectSocket() {
    _socket?.disconnect();
    _socket = null;
  }
}
