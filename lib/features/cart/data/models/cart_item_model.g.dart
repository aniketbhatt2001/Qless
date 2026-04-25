// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartItemModel _$CartItemModelFromJson(Map<String, dynamic> json) =>
    CartItemModel(
      menuItem: MenuItemModel.fromJson(
        json['menuItem'] as Map<String, dynamic>,
      ),
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$CartItemModelToJson(CartItemModel instance) =>
    <String, dynamic>{
      'menuItem': instance.menuItem,
      'quantity': instance.quantity,
    };
