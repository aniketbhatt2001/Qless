import 'package:canteen_mangement/core/constants/app_routes.dart';
import 'package:canteen_mangement/core/network/dio_client.dart';
import 'package:canteen_mangement/core/utils/alice_helper.dart';
import 'package:canteen_mangement/core/theme/app_theme.dart';
import 'package:canteen_mangement/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:canteen_mangement/features/auth/presentation/bindings/auth_binding.dart';
import 'package:canteen_mangement/features/auth/presentation/controllers/auth_controller.dart';
import 'package:canteen_mangement/features/auth/presentation/views/login_view.dart';
import 'package:canteen_mangement/features/auth/presentation/views/register_view.dart';
import 'package:canteen_mangement/features/auth/presentation/views/splash_view.dart';
import 'package:canteen_mangement/features/dashboard/presentation/bindings/dashboard_binding.dart';
import 'package:canteen_mangement/features/payment/payment_binding.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:canteen_mangement/features/cart/presentation/views/cart_view.dart';
import 'package:canteen_mangement/features/dashboard/presentation/views/dashboard_view_original_backup.dart';
import 'package:canteen_mangement/features/menu/presentation/views/menu_detail_view.dart';
import 'package:canteen_mangement/features/order/presentation/views/order_list_view.dart';
import 'package:canteen_mangement/features/auth/presentation/views/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  final prefs = await SharedPreferences.getInstance();
  final localDataSource = AuthLocalDataSourceImpl(prefs);
  Get.put<AuthLocalDataSource>(localDataSource, permanent: true);

  final dioClient = DioClient(
    getToken: localDataSource.getToken,
    isTokenValid: localDataSource.isTokenValid,
  );
  Get.put<DioClient>(dioClient, permanent: true);

  AuthBinding().dependencies();
  PaymentBinding().dependencies();

  dioClient.onUnauthorized = () {
    Get.find<AuthController>().logout();
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: GetMaterialApp(
        title: 'QuickerQ',
        debugShowCheckedModeBanner: false,
        navigatorKey: AliceHelper.navigatorKey,
        theme: AppTheme.light(),
        initialRoute: AppRoutes.splash,
        getPages: [
          GetPage(name: AppRoutes.splash, page: () => const SplashView()),
          GetPage(name: AppRoutes.login, page: () => LoginView()),
          GetPage(name: AppRoutes.register, page: () => RegisterView()),
          GetPage(
            name: AppRoutes.dashboard,
            page: () => const DashboardView(),
            binding: DashboardBinding(),
          ),
          GetPage(
            name: AppRoutes.menuDetail,
            page: () => const MenuDetailView(),
          ),
          GetPage(name: AppRoutes.cart, page: () => CartView()),
          GetPage(name: AppRoutes.orders, page: () => const OrderListView()),
          GetPage(name: AppRoutes.profile, page: () => ProfileView()),
        ],
      ),
    );
  }
}
