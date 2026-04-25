import '../entities/menu_item_entity.dart';

abstract class MenuRepository {
  Future<List<MenuItemEntity>> getMenuItems();
  Future<List<MenuItemEntity>> getMenuItemsByCategory(String category);
  Future<MenuItemEntity> getMenuItem(String id);
}
