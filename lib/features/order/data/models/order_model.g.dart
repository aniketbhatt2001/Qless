// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItemModel _$OrderItemModelFromJson(Map<String, dynamic> json) =>
    OrderItemModel(
      menuItemId: json['menuItemId'] as String,
      quantity: (json['quantity'] as num).toInt(),
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$OrderItemModelToJson(OrderItemModel instance) =>
    <String, dynamic>{
      'menuItemId': instance.menuItemId,
      'quantity': instance.quantity,
      'name': instance.name,
      'price': instance.price,
    };

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => OrderModel(
  id: json['_id'] as String?,
  userid: json['userid'] as String?,
  customerName: json['customerName'] as String?,
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
  totalPrice: (json['totalAmount'] as num?)?.toDouble(),
  status: json['status'] as String?,
  queuePosition: json['queuePosition'] as num?,
  createdAt:
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
  estimatedWaitMinutes: json['estimatedWaitMinutes'] as num?,
);

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'userid': instance.userid,
      'customerName': instance.customerName,
      'items': instance.items,
      'totalAmount': instance.totalPrice,
      'status': instance.status,
      'queuePosition': instance.queuePosition,
      'createdAt': instance.createdAt?.toIso8601String(),
      'estimatedWaitMinutes': instance.estimatedWaitMinutes,
    };
