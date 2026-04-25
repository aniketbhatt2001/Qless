import 'package:canteen_mangement/core/usecases/usecase.dart';
import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

class GetMyOrdersParams {
  final String? status;
  const GetMyOrdersParams({this.status});
}

class GetMyOrdersUseCase implements UseCase<List<OrderEntity>, GetMyOrdersParams> {
  final OrderRepository _repository;
  GetMyOrdersUseCase(this._repository);

  @override
  Future<List<OrderEntity>> call(GetMyOrdersParams params) =>
      _repository.getMyOrders(status: params.status);
}
