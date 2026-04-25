import 'package:canteen_mangement/features/auth/domain/entities/auth_result_entity.dart';
import 'package:canteen_mangement/features/auth/domain/entities/user_entity.dart';
import 'package:canteen_mangement/features/auth/domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/login_request_model.dart';
import '../models/register_request_model.dart';
import '../models/update_profile_request_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remote,
    required AuthLocalDataSource local,
  })  : _remote = remote,
        _local = local;

  @override
  Future<AuthResultEntity> login(String phone, String password) async {
    final model = await _remote.login(LoginRequestModel(phone: phone, password: password));
    await _local.saveToken(model.token);
    return model.toEntity();
  }

  @override
  Future<AuthResultEntity> register(String name, String phone, String password) async {
    final model = await _remote.register(
      RegisterRequestModel(name: name, phone: phone, password: password),
    );
    await _local.saveToken(model.token);
    return model.toEntity();
  }

  @override
  Future<UserEntity> getProfile() async {
    final model = await _remote.getProfile();
    return model.toEntity();
  }

  @override
  Future<UserEntity> updateProfile({
    String? name,
    String? currentPassword,
    String? newPassword,
  }) async {
    final model = await _remote.updateProfile(
      UpdateProfileRequestModel(
        name: name,
        currentPassword: currentPassword,
        newPassword: newPassword,
      ),
    );
    return model.toEntity();
  }

  @override
  Future<void> deleteAccount() => _remote.deleteAccount();

  @override
  Future<void> logout() => _local.clearToken();
}
