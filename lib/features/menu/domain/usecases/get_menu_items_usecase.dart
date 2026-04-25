import 'package:canteen_mangement/core/usecases/usecase.dart';
import '../entities/menu_item_entity.dart';
import '../repositories/menu_repository.dart';

class GetMenuItemsUseCase implements UseCase<List<MenuItemEntity>, NoParams> {
  final MenuRepository _repository;
  GetMenuItemsUseCase(this._repository);

  @override
  Future<List<MenuItemEntity>> call(NoParams params) => _repository.getMenuItems();
}
