import 'package:canteen_mangement/core/network/dio_client.dart';
import 'package:canteen_mangement/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:canteen_mangement/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:canteen_mangement/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:canteen_mangement/features/auth/domain/repositories/auth_repository.dart';
import 'package:canteen_mangement/features/auth/domain/usecases/delete_account_usecase.dart';
import 'package:canteen_mangement/features/auth/domain/usecases/get_profile_usecase.dart';
import 'package:canteen_mangement/features/auth/domain/usecases/login_usecase.dart';
import 'package:canteen_mangement/features/auth/domain/usecases/logout_usecase.dart';
import 'package:canteen_mangement/features/auth/domain/usecases/register_usecase.dart';
import 'package:canteen_mangement/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:canteen_mangement/features/auth/presentation/controllers/auth_controller.dart';
import 'package:get/get.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    final localDataSource = Get.find<AuthLocalDataSource>();

    Get.lazyPut<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(Get.find<DioClient>().dio),
    );

    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(
        remote: Get.find<AuthRemoteDataSource>(),
        local: localDataSource,
      ),
    );

    Get.lazyPut(() => LoginUseCase(Get.find<AuthRepository>()));
    Get.lazyPut(() => RegisterUseCase(Get.find<AuthRepository>()));
    Get.lazyPut(() => GetProfileUseCase(Get.find<AuthRepository>()));
    Get.lazyPut(() => UpdateProfileUseCase(Get.find<AuthRepository>()));
    Get.lazyPut(() => LogoutUseCase(Get.find<AuthRepository>()));
    Get.lazyPut(() => DeleteAccountUseCase(Get.find<AuthRepository>()));

    Get.put(
      AuthController(
        loginUseCase: Get.find(),
        registerUseCase: Get.find(),
        getProfileUseCase: Get.find(),
        updateProfileUseCase: Get.find(),
        logoutUseCase: Get.find(),
        deleteAccountUseCase: Get.find(),
        localDataSource: localDataSource,
      ),
      permanent: true,
    );
  }
}
