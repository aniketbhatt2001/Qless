import 'package:canteen_mangement/core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class UpdateProfileParams {
  final String? name;
  final String? currentPassword;
  final String? newPassword;
  const UpdateProfileParams({this.name, this.currentPassword, this.newPassword});
}

class UpdateProfileUseCase implements UseCase<UserEntity, UpdateProfileParams> {
  final AuthRepository _repository;
  UpdateProfileUseCase(this._repository);

  @override
  Future<UserEntity> call(UpdateProfileParams params) => _repository.updateProfile(
        name: params.name,
        currentPassword: params.currentPassword,
        newPassword: params.newPassword,
      );
}
