import 'package:json_annotation/json_annotation.dart';
import 'package:canteen_mangement/features/order/domain/entities/order_entity.dart';

part 'order_model.g.dart';

@JsonSerializable()
class OrderItemModel {
  final String menuItemId;
  final int quantity;
  final String name;
  final double price;

  const OrderItemModel({
    required this.menuItemId,
    required this.quantity,
    required this.name,
    required this.price,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderItemModelToJson(this);

  OrderItemEntity toEntity() =>
      OrderItemEntity(menuItemId: menuItemId, quantity: quantity, name: name, price: price);

  static OrderItemModel fromEntity(OrderItemEntity e) =>
      OrderItemModel(menuItemId: e.menuItemId, quantity: e.quantity, name: e.name, price: e.price);
}

@JsonSerializable()
class OrderModel {
  @JsonKey(name: '_id')
  final String? id;
  @JsonKey(name: 'userid')
  final String? userid;
  final String? customerName;
  final List<OrderItemModel>? items;
  @JsonKey(name: 'totalAmount')
  final double? totalPrice;
  final String? status;
  final num? queuePosition;
  final DateTime? createdAt;
  @JsonKey(name: 'estimatedWaitMinutes')
  final num? estimatedWaitMinutes;

  const OrderModel({
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

  factory OrderModel.fromJson(Map<String, dynamic> json) => _$OrderModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderModelToJson(this);

  OrderEntity toEntity() => OrderEntity(
        id: id,
        userid: userid,
        customerName: customerName,
        items: items?.map((i) => i.toEntity()).toList(),
        totalPrice: totalPrice,
        status: status,
        queuePosition: queuePosition,
        createdAt: createdAt,
        estimatedWaitMinutes: estimatedWaitMinutes,
      );
}
