import 'package:canteen_mangement/core/constants/app_routes.dart';
import 'package:canteen_mangement/core/constants/app_strings.dart';
import 'package:canteen_mangement/core/errors/app_error_handler.dart';
import 'package:canteen_mangement/core/usecases/usecase.dart';
import 'package:canteen_mangement/core/utils/app_logger.dart';
import 'package:canteen_mangement/core/utils/custom_snackbar.dart';
import 'package:canteen_mangement/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:canteen_mangement/features/auth/domain/entities/user_entity.dart';
import 'package:canteen_mangement/features/auth/domain/usecases/delete_account_usecase.dart';
import 'package:canteen_mangement/features/auth/domain/usecases/get_profile_usecase.dart';
import 'package:canteen_mangement/features/auth/domain/usecases/login_usecase.dart';
import 'package:canteen_mangement/features/auth/domain/usecases/logout_usecase.dart';
import 'package:canteen_mangement/features/auth/domain/usecases/register_usecase.dart';
import 'package:canteen_mangement/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:get/get.dart';

/// Controller for managing authentication state and operations.
///
/// Handles user login, registration, profile management, and logout operations.
/// Uses GetX for reactive state management and dependency injection.
/// All authentication operations are delegated to use cases following Clean Architecture.
class AuthController extends GetxController {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final GetProfileUseCase _getProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  final LogoutUseCase _logoutUseCase;
  final DeleteAccountUseCase _deleteAccountUseCase;
  final AuthLocalDataSource _localDataSource;

  AuthController({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required GetProfileUseCase getProfileUseCase,
    required UpdateProfileUseCase updateProfileUseCase,
    required LogoutUseCase logoutUseCase,
    required DeleteAccountUseCase deleteAccountUseCase,
    required AuthLocalDataSource localDataSource,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _getProfileUseCase = getProfileUseCase,
        _updateProfileUseCase = updateProfileUseCase,
        _logoutUseCase = logoutUseCase,
        _deleteAccountUseCase = deleteAccountUseCase,
        _localDataSource = localDataSource;

  final Rxn<UserEntity> user = Rxn<UserEntity>();
  final RxBool isLoading = false.obs;
  final RxBool isInitializing = true.obs;
  final RxString token = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadAuthData();
  }

  /// Loads authentication data from local storage on controller initialization.
  ///
  /// Validates stored token and fetches user profile if token is valid.
  /// Clears invalid tokens to maintain security.
  /// Sets [isInitializing] to false when complete to trigger UI updates.
  Future<void> _loadAuthData() async {
    try {
      final valid = await _localDataSource.isTokenValid();
      if (valid) {
        final savedToken = await _localDataSource.getToken();
        token.value = savedToken ?? '';
        await getProfile();
        return;
      }
      await _localDataSource.clearToken();
    } finally {
      isInitializing.value = false;
    }
  }

  /// Authenticates user with phone number and password.
  ///
  /// Navigates to dashboard on successful login and stores authentication token.
  /// Displays error snackbar if authentication fails.
  ///
  /// Parameters:
  /// - [phone]: User's phone number
  /// - [password]: User's password
  Future<void> login(String phone, String password) async {
    try {
      isLoading.value = true;
      AppLogger.info('Login attempt for phone: $phone');
      
      final result = await _loginUseCase(LoginParams(phone: phone, password: password));
      token.value = result.token;
      user.value = result.user;
      
      AppLogger.info('Login successful for user: ${result.user.id}');
      Get.offAllNamed(AppRoutes.dashboard);
    } catch (e, stackTrace) {
      AppLogger.error('Login failed for phone: $phone', e, stackTrace);
      CustomSnackbar.show(
        title: AppStrings.error,
        message: AppErrorHandler.getMessage(e),
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Registers a new user account.
  ///
  /// Creates new user account and automatically logs them in on success.
  /// Navigates to dashboard after successful registration.
  /// Displays error snackbar if registration fails.
  ///
  /// Parameters:
  /// - [name]: User's full name
  /// - [phone]: User's phone number
  /// - [password]: User's chosen password
  Future<void> register(String name, String phone, String password) async {
    try {
      isLoading.value = true;
      AppLogger.info('Registration attempt for phone: $phone');
      
      final result = await _registerUseCase(
        RegisterParams(name: name, phone: phone, password: password),
      );
      token.value = result.token;
      user.value = result.user;
      
      AppLogger.info('Registration successful for user: ${result.user.id}');
      Get.offAllNamed(AppRoutes.dashboard);
    } catch (e, stackTrace) {
      AppLogger.error('Registration failed for phone: $phone', e, stackTrace);
      CustomSnackbar.show(
        title: AppStrings.error,
        message: AppErrorHandler.getMessage(e),
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetches current user profile from server.
  ///
  /// Updates [user] reactive variable with latest profile data.
  /// Automatically logs out user if profile fetch fails (invalid token).
  /// Called during app initialization to restore user session.
  Future<void> getProfile() async {
    try {
      user.value = await _getProfileUseCase(const NoParams());
      AppLogger.info('Profile fetched successfully for user: ${user.value?.id}');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to fetch profile, logging out', e, stackTrace);
      await logout();
    }
  }

  /// Updates user profile information.
  ///
  /// Allows updating name and/or password. Password change requires current password.
  /// Displays success snackbar and closes update screen on success.
  /// Displays error snackbar if update fails.
  ///
  /// Parameters:
  /// - [name]: New name (optional)
  /// - [currentPassword]: Current password (required for password change)
  /// - [newPassword]: New password (optional)
  Future<void> updateProfile({
    String? name,
    String? currentPassword,
    String? newPassword,
  }) async {
    try {
      isLoading.value = true;
      AppLogger.info('Updating profile for user: ${user.value?.id}');
      
      user.value = await _updateProfileUseCase(
        UpdateProfileParams(
          name: name,
          currentPassword: currentPassword,
          newPassword: newPassword,
        ),
      );
      
      AppLogger.info('Profile updated successfully');
      Get.back();
      CustomSnackbar.show(
        title: AppStrings.success,
        message: AppStrings.profileUpdated,
      );
    } catch (e, stackTrace) {
      AppLogger.error('Profile update failed', e, stackTrace);
      CustomSnackbar.show(
        title: AppStrings.error,
        message: AppErrorHandler.getMessage(e),
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Permanently deletes user account.
  ///
  /// Removes all user data from server and logs out.
  /// This action cannot be undone.
  /// Displays error snackbar if deletion fails.
  Future<void> deleteAccount() async {
    try {
      isLoading.value = true;
      AppLogger.warning('Account deletion initiated for user: ${user.value?.id}');
      
      await _deleteAccountUseCase(const NoParams());
      
      AppLogger.info('Account deleted successfully');
      await logout();
    } catch (e, stackTrace) {
      AppLogger.error('Account deletion failed', e, stackTrace);
      CustomSnackbar.show(
        title: AppStrings.error,
        message: AppErrorHandler.getMessage(e),
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Logs out current user.
  ///
  /// Clears authentication token and user data from local storage.
  /// Navigates to login screen after successful logout.
  /// Displays success snackbar to confirm logout.
  Future<void> logout() async {
    AppLogger.info('Logout initiated for user: ${user.value?.id}');
    
    await _logoutUseCase(const NoParams());
    user.value = null;
    token.value = '';
    
    AppLogger.info('Logout successful');
    CustomSnackbar.show(
      title: AppStrings.success,
      message: AppStrings.logoutSuccess,
    );
    Get.offAllNamed(AppRoutes.login);
  }
}
