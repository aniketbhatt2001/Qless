class OrderItemEntity {
  final String menuItemId;
  final int quantity;
  final String name;
  final double price;

  const OrderItemEntity({
    required this.menuItemId,
    required this.quantity,
    required this.name,
    required this.price,
  });
}

class OrderEntity {
  final String? id;
  final String? userid;
  final String? customerName;
  final List<OrderItemEntity>? items;
  final double? totalPrice;
  final String? status;
  final num? queuePosition;
  final DateTime? createdAt;
  final num? estimatedWaitMinutes;

  const OrderEntity({
    this.id,
    this.userid,
    this.customerName,
    this.items,
    this.totalPrice,
    this.status,
    this.queuePosition,
    this.createdAt,
    this.estimatedWaitMinutes,
  });
}
