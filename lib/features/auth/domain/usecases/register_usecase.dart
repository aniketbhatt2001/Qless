import 'package:canteen_mangement/core/usecases/usecase.dart';
import '../entities/auth_result_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterParams {
  final String name;
  final String phone;
  final String password;
  const RegisterParams({
    required this.name,
    required this.phone,
    required this.password,
  });
}

class RegisterUseCase implements UseCase<AuthResultEntity, RegisterParams> {
  final AuthRepository _repository;
  RegisterUseCase(this._repository);

  @override
  Future<AuthResultEntity> call(RegisterParams params) =>
      _repository.register(params.name, params.phone, params.password);
}
