import 'package:canteen_mangement/core/network/dio_client.dart';
import 'package:canteen_mangement/features/order/data/datasources/order_remote_data_source.dart';
import 'package:canteen_mangement/features/order/data/repositories/order_repository_impl.dart';
import 'package:canteen_mangement/features/order/domain/repositories/order_repository.dart';
import 'package:canteen_mangement/features/order/domain/usecases/get_my_orders_usecase.dart';
import 'package:canteen_mangement/features/order/domain/usecases/get_order_status_usecase.dart';
import 'package:canteen_mangement/features/order/domain/usecases/mark_order_ready_usecase.dart';
import 'package:canteen_mangement/features/order/domain/usecases/place_order_usecase.dart';
import 'package:canteen_mangement/features/order/presentation/controllers/order_controller.dart';
import 'package:get/get.dart';

class OrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderRemoteDataSource>(
      () => OrderRemoteDataSourceImpl(Get.find<DioClient>().dio),
    );

    Get.lazyPut<OrderRepository>(
      () => OrderRepositoryImpl(Get.find<OrderRemoteDataSource>()),
    );

    Get.lazyPut(() => PlaceOrderUseCase(Get.find<OrderRepository>()));
    Get.lazyPut(() => GetMyOrdersUseCase(Get.find<OrderRepository>()));
    Get.lazyPut(() => GetOrderStatusUseCase(Get.find<OrderRepository>()));
    Get.lazyPut(() => MarkOrderReadyUseCase(Get.find<OrderRepository>()));

    Get.lazyPut(
      () => OrderController(
        placeOrderUseCase: Get.find(),
        getMyOrdersUseCase: Get.find(),
        getOrderStatusUseCase: Get.find(),
        orderRepository: Get.find(),
      ),
      fenix: true,
    );
  }
}
