import 'package:json_annotation/json_annotation.dart';
import 'package:canteen_mangement/features/cart/domain/entities/cart_item_entity.dart';
import 'package:canteen_mangement/features/menu/data/models/menu_item_model.dart';

part 'cart_item_model.g.dart';

@JsonSerializable()
class CartItemModel {
  final MenuItemModel menuItem;
  final int quantity;

  const CartItemModel({required this.menuItem, required this.quantity});

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$CartItemModelToJson(this);

  CartItemEntity toEntity() =>
      CartItemEntity(menuItem: menuItem.toEntity(), quantity: quantity);
}
