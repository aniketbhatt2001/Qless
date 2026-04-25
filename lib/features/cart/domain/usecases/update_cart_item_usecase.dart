import 'package:canteen_mangement/core/usecases/usecase.dart';
import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';

class UpdateCartItemParams {
  final String menuItemId;
  final int quantity;
  const UpdateCartItemParams({required this.menuItemId, required this.quantity});
}

class UpdateCartItemUseCase implements UseCase<CartEntity, UpdateCartItemParams> {
  final CartRepository _repository;
  UpdateCartItemUseCase(this._repository);

  @override
  Future<CartEntity> call(UpdateCartItemParams params) =>
      _repository.updateCartItem(params.menuItemId, params.quantity);
}
