import 'package:canteen_mangement/core/usecases/usecase.dart';
import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';

class RemoveCartItemParams {
  final String menuItemId;
  const RemoveCartItemParams(this.menuItemId);
}

class RemoveCartItemUseCase implements UseCase<CartEntity, RemoveCartItemParams> {
  final CartRepository _repository;
  RemoveCartItemUseCase(this._repository);

  @override
  Future<CartEntity> call(RemoveCartItemParams params) =>
      _repository.removeCartItem(params.menuItemId);
}
