import 'package:json_annotation/json_annotation.dart';
import 'package:canteen_mangement/features/cart/domain/entities/cart_entity.dart';
import 'cart_item_model.dart';

part 'cart_model.g.dart';

@JsonSerializable()
class CartModel {
  @JsonKey(name: '_id')
  final String? id;
  final List<CartItemModel> items;
  @JsonKey(name: 'grandTotal')
  final double totalPrice;

  const CartModel({this.id, required this.items, required this.totalPrice});

  factory CartModel.fromJson(Map<String, dynamic> json) => _$CartModelFromJson(json);
  Map<String, dynamic> toJson() => _$CartModelToJson(this);

  CartEntity toEntity() => CartEntity(
        id: id,
        items: items.map((i) => i.toEntity()).toList(),
        totalPrice: totalPrice,
      );
}
