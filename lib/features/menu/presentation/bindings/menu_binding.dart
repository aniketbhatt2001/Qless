import 'package:canteen_mangement/core/network/dio_client.dart';
import 'package:canteen_mangement/features/menu/data/datasources/menu_remote_data_source.dart';
import 'package:canteen_mangement/features/menu/data/repositories/menu_repository_impl.dart';
import 'package:canteen_mangement/features/menu/domain/repositories/menu_repository.dart';
import 'package:canteen_mangement/features/menu/domain/usecases/get_menu_by_category_usecase.dart';
import 'package:canteen_mangement/features/menu/domain/usecases/get_menu_item_usecase.dart';
import 'package:canteen_mangement/features/menu/domain/usecases/get_menu_items_usecase.dart';
import 'package:canteen_mangement/features/menu/presentation/controllers/menu_controller.dart';
import 'package:get/get.dart';

class MenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MenuRemoteDataSource>(
      () => MenuRemoteDataSourceImpl(Get.find<DioClient>().dio),
    );

    Get.lazyPut<MenuRepository>(
      () => MenuRepositoryImpl(Get.find<MenuRemoteDataSource>()),
    );

    Get.lazyPut(() => GetMenuItemsUseCase(Get.find<MenuRepository>()));
    Get.lazyPut(() => GetMenuByCategoryUseCase(Get.find<MenuRepository>()));
    Get.lazyPut(() => GetMenuItemUseCase(Get.find<MenuRepository>()));

    Get.lazyPut(
      () => MenuController(getMenuItemsUseCase: Get.find()),
      fenix: true,
    );
  }
}
