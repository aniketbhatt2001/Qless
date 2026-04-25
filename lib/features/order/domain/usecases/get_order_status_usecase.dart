import 'package:canteen_mangement/core/usecases/usecase.dart';
import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

class GetOrderStatusUseCase implements UseCase<OrderEntity, String> {
  final OrderRepository _repository;
  GetOrderStatusUseCase(this._repository);

  @override
  Future<OrderEntity> call(String id) => _repository.getOrderStatus(id);
}
