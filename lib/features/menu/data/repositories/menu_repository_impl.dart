import 'package:canteen_mangement/features/menu/domain/entities/menu_item_entity.dart';
import 'package:canteen_mangement/features/menu/domain/repositories/menu_repository.dart';
import '../datasources/menu_remote_data_source.dart';

class MenuRepositoryImpl implements MenuRepository {
  final MenuRemoteDataSource _remote;
  MenuRepositoryImpl(this._remote);

  @override
  Future<List<MenuItemEntity>> getMenuItems() async {
    final models = await _remote.getMenuItems();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<MenuItemEntity>> getMenuItemsByCategory(String category) async {
    final models = await _remote.getMenuItemsByCategory(category);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<MenuItemEntity> getMenuItem(String id) async {
    final model = await _remote.getMenuItem(id);
    return model.toEntity();
  }
}
