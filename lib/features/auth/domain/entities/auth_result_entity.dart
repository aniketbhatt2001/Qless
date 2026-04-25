import 'user_entity.dart';

class AuthResultEntity {
  final String token;
  final UserEntity user;

  const AuthResultEntity({required this.token, required this.user});
}
