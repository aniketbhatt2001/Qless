import 'package:canteen_mangement/core/network/dio_client.dart';
import 'package:canteen_mangement/features/cart/data/datasources/cart_remote_data_source.dart';
import 'package:canteen_mangement/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:canteen_mangement/features/cart/domain/repositories/cart_repository.dart';
import 'package:canteen_mangement/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:canteen_mangement/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:canteen_mangement/features/cart/domain/usecases/get_cart_usecase.dart';
import 'package:canteen_mangement/features/cart/domain/usecases/remove_cart_item_usecase.dart';
import 'package:canteen_mangement/features/cart/domain/usecases/update_cart_item_usecase.dart';
import 'package:canteen_mangement/features/cart/presentation/controllers/cart_controller.dart';
import 'package:get/get.dart';

class CartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CartRemoteDataSource>(
      () => CartRemoteDataSourceImpl(Get.find<DioClient>().dio),
    );

    Get.lazyPut<CartRepository>(
      () => CartRepositoryImpl(Get.find<CartRemoteDataSource>()),
    );

    Get.lazyPut(() => GetCartUseCase(Get.find<CartRepository>()));
    Get.lazyPut(() => AddToCartUseCase(Get.find<CartRepository>()));
    Get.lazyPut(() => UpdateCartItemUseCase(Get.find<CartRepository>()));
    Get.lazyPut(() => RemoveCartItemUseCase(Get.find<CartRepository>()));
    Get.lazyPut(() => ClearCartUseCase(Get.find<CartRepository>()));

    Get.lazyPut(
      () => CartController(
        getCartUseCase: Get.find(),
        addToCartUseCase: Get.find(),
        updateCartItemUseCase: Get.find(),
        removeCartItemUseCase: Get.find(),
        clearCartUseCase: Get.find(),
      ),
      fenix: true,
    );
  }
}
