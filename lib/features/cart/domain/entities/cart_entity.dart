import 'cart_item_entity.dart';

class CartEntity {
  final String? id;
  final List<CartItemEntity> items;
  final double totalPrice;

  const CartEntity({this.id, required this.items, required this.totalPrice});
}
