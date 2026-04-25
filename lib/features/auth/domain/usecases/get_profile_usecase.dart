import 'package:canteen_mangement/core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class GetProfileUseCase implements UseCase<UserEntity, NoParams> {
  final AuthRepository _repository;
  GetProfileUseCase(this._repository);

  @override
  Future<UserEntity> call(NoParams params) => _repository.getProfile();
}
