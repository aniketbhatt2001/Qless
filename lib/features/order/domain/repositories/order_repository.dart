import '../entities/order_entity.dart';

abstract class OrderRepository {
  Future<OrderEntity> placeOrder(String customerName, List<OrderItemEntity> items);
  Future<List<OrderEntity>> getMyOrders({String? status});
  Future<OrderEntity> getOrderStatus(String id);
  Future<void> markOrderReady(String id);
  Stream<void> orderUpdates();
}
