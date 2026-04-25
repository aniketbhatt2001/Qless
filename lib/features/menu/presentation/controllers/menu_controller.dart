import 'package:canteen_mangement/core/errors/app_error_handler.dart';
import 'package:canteen_mangement/core/usecases/usecase.dart';
import 'package:canteen_mangement/core/utils/custom_snackbar.dart';
import 'package:canteen_mangement/features/menu/domain/entities/menu_item_entity.dart';
import 'package:canteen_mangement/features/menu/domain/usecases/get_menu_items_usecase.dart';
import 'package:get/get.dart';

class MenuController extends GetxController {
  final GetMenuItemsUseCase _getMenuItemsUseCase;

  MenuController({required GetMenuItemsUseCase getMenuItemsUseCase})
      : _getMenuItemsUseCase = getMenuItemsUseCase;

  final RxList<MenuItemEntity> menuItems = <MenuItemEntity>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMenuItems();
  }

  Future<void> fetchMenuItems() async {
    try {
      isLoading.value = true;
      menuItems.value = await _getMenuItemsUseCase(const NoParams());
    } catch (e) {
      CustomSnackbar.show(
        title: 'Error',
        message: AppErrorHandler.getMessage(e),
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
