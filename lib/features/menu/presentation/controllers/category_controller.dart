import 'package:canteen_mangement/core/errors/app_error_handler.dart';
import 'package:canteen_mangement/core/utils/custom_snackbar.dart';
import 'package:canteen_mangement/features/menu/domain/entities/menu_item_entity.dart';
import 'package:canteen_mangement/features/menu/domain/usecases/get_menu_by_category_usecase.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  final GetMenuByCategoryUseCase _getMenuByCategoryUseCase;
  final String category;

  CategoryController({
    required GetMenuByCategoryUseCase getMenuByCategoryUseCase,
    required this.category,
  }) : _getMenuByCategoryUseCase = getMenuByCategoryUseCase;

  final RxList<MenuItemEntity> categoryItems = <MenuItemEntity>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategoryItems();
  }

  Future<void> fetchCategoryItems() async {
    try {
      isLoading.value = true;
      categoryItems.value = await _getMenuByCategoryUseCase(CategoryParams(category));
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
