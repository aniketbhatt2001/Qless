import '../entities/auth_result_entity.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<AuthResultEntity> login(String phone, String password);
  Future<AuthResultEntity> register(String name, String phone, String password);
  Future<UserEntity> getProfile();
  Future<UserEntity> updateProfile({
    String? name,
    String? currentPassword,
    String? newPassword,
  });
  Future<void> deleteAccount();
  Future<void> logout();
}
