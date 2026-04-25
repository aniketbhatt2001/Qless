import 'package:canteen_mangement/core/usecases/usecase.dart';
import '../entities/auth_result_entity.dart';
import '../repositories/auth_repository.dart';

class LoginParams {
  final String phone;
  final String password;
  const LoginParams({required this.phone, required this.password});
}

class LoginUseCase implements UseCase<AuthResultEntity, LoginParams> {
  final AuthRepository _repository;
  LoginUseCase(this._repository);

  @override
  Future<AuthResultEntity> call(LoginParams params) =>
      _repository.login(params.phone, params.password);
}
