import 'package:canteen_mangement/core/usecases/usecase.dart';
import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

class PlaceOrderParams {
  final String customerName;
  final List<OrderItemEntity> items;
  const PlaceOrderParams({required this.customerName, required this.items});
}

class PlaceOrderUseCase implements UseCase<OrderEntity, PlaceOrderParams> {
  final OrderRepository _repository;
  PlaceOrderUseCase(this._repository);

  @override
  Future<OrderEntity> call(PlaceOrderParams params) =>
      _repository.placeOrder(params.customerName, params.items);
}
