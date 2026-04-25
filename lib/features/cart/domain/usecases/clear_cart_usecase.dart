import 'package:canteen_mangement/core/usecases/usecase.dart';
import '../repositories/cart_repository.dart';

class ClearCartUseCase implements UseCase<void, NoParams> {
  final CartRepository _repository;
  ClearCartUseCase(this._repository);

  @override
  Future<void> call(NoParams params) => _repository.clearCart();
}
