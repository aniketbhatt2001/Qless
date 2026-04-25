import 'package:canteen_mangement/features/order/domain/entities/order_entity.dart';
import 'package:canteen_mangement/features/order/domain/repositories/order_repository.dart';
import '../datasources/order_remote_data_source.dart';
import '../models/order_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource _remote;
  OrderRepositoryImpl(this._remote);

  @override
  Future<OrderEntity> placeOrder(String customerName, List<OrderItemEntity> items) async {
    final model = await _remote.placeOrder(
      customerName,
      items.map(OrderItemModel.fromEntity).toList(),
    );
    return model.toEntity();
  }

  @override
  Future<List<OrderEntity>> getMyOrders({String? status}) async {
    final models = await _remote.getMyOrders(status: status);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<OrderEntity> getOrderStatus(String id) async {
    final model = await _remote.getOrderStatus(id);
    return model.toEntity();
  }

  @override
  Future<void> markOrderReady(String id) => _remote.markOrderReady(id);

  @override
  Stream<void> orderUpdates() => _remote.listenToOrderUpdates();
}
