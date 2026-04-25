import 'package:canteen_mangement/core/usecases/usecase.dart';
import '../entities/menu_item_entity.dart';
import '../repositories/menu_repository.dart';

class MenuItemParams {
  final String id;
  const MenuItemParams(this.id);
}

class GetMenuItemUseCase implements UseCase<MenuItemEntity, MenuItemParams> {
  final MenuRepository _repository;
  GetMenuItemUseCase(this._repository);

  @override
  Future<MenuItemEntity> call(MenuItemParams params) =>
      _repository.getMenuItem(params.id);
}
