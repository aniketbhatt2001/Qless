import 'package:canteen_mangement/core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class LogoutUseCase implements UseCase<void, NoParams> {
  final AuthRepository _repository;
  LogoutUseCase(this._repository);

  @override
  Future<void> call(NoParams params) => _repository.logout();
}
