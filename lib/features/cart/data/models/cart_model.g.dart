// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartModel _$CartModelFromJson(Map<String, dynamic> json) => CartModel(
  id: json['_id'] as String?,
  items:
      (json['items'] as List<dynamic>)
          .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
  totalPrice: (json['grandTotal'] as num).toDouble(),
);

Map<String, dynamic> _$CartModelToJson(CartModel instance) => <String, dynamic>{
  '_id': instance.id,
  'items': instance.items,
  'grandTotal': instance.totalPrice,
};
