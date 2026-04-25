import 'package:canteen_mangement/core/usecases/usecase.dart';
import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';

class AddToCartParams {
  final String menuItemId;
  final int quantity;
  const AddToCartParams({required this.menuItemId, required this.quantity});
}

class AddToCartUseCase implements UseCase<CartEntity, AddToCartParams> {
  final CartRepository _repository;
  AddToCartUseCase(this._repository);

  @override
  Future<CartEntity> call(AddToCartParams params) =>
      _repository.addToCart(params.menuItemId, params.quantity);
}
