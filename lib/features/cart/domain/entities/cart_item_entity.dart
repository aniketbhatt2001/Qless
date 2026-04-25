import 'package:canteen_mangement/features/menu/domain/entities/menu_item_entity.dart';

class CartItemEntity {
  final MenuItemEntity menuItem;
  final int quantity;

  const CartItemEntity({required this.menuItem, required this.quantity});
}
