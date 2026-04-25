import 'package:canteen_mangement/core/usecases/usecase.dart';
import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';

class GetCartUseCase implements UseCase<CartEntity, NoParams> {
  final CartRepository _repository;
  GetCartUseCase(this._repository);

  @override
  Future<CartEntity> call(NoParams params) => _repository.getCart();
}
