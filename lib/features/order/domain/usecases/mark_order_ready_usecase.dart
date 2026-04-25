import 'package:canteen_mangement/core/usecases/usecase.dart';
import '../repositories/order_repository.dart';

class MarkOrderReadyUseCase implements UseCase<void, String> {
  final OrderRepository _repository;
  MarkOrderReadyUseCase(this._repository);

  @override
  Future<void> call(String id) => _repository.markOrderReady(id);
}
