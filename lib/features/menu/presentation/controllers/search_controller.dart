import 'package:canteen_mangement/core/errors/app_error_handler.dart';
import 'package:canteen_mangement/core/usecases/usecase.dart';
import 'package:canteen_mangement/core/utils/custom_snackbar.dart';
import 'package:canteen_mangement/features/menu/domain/entities/menu_item_entity.dart';
import 'package:canteen_mangement/features/menu/domain/usecases/get_menu_items_usecase.dart';
import 'package:get/get.dart';

class MealSearchController extends GetxController {
  final GetMenuItemsUseCase _getMenuItemsUseCase;

  MealSearchController({required GetMenuItemsUseCase getMenuItemsUseCase})
      : _getMenuItemsUseCase = getMenuItemsUseCase;

  final RxList<MenuItemEntity> allItems = <MenuItemEntity>[].obs;
  final RxList<MenuItemEntity> filteredItems = <MenuItemEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllItems();
    ever(searchQuery, (_) => _applyFilter());
  }

  Future<void> fetchAllItems() async {
    try {
      isLoading.value = true;
      allItems.value = await _getMenuItemsUseCase(const NoParams());
      _applyFilter();
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

  void _applyFilter() {
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) {
      filteredItems.assignAll(allItems);
    } else {
      filteredItems.assignAll(
        allItems.where(
          (item) =>
              item.name.toLowerCase().contains(query) ||
              (item.category?.toLowerCase().contains(query) ?? false),
        ),
      );
    }
  }
}
