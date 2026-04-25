import 'package:canteen_mangement/core/usecases/usecase.dart';
import '../entities/menu_item_entity.dart';
import '../repositories/menu_repository.dart';

class CategoryParams {
  final String category;
  const CategoryParams(this.category);
}

class GetMenuByCategoryUseCase implements UseCase<List<MenuItemEntity>, CategoryParams> {
  final MenuRepository _repository;
  GetMenuByCategoryUseCase(this._repository);

  @override
  Future<List<MenuItemEntity>> call(CategoryParams params) =>
      _repository.getMenuItemsByCategory(params.category);
}
