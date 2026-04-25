import 'package:json_annotation/json_annotation.dart';
import 'package:canteen_mangement/features/auth/domain/entities/auth_result_entity.dart';
import 'user_model.dart';

part 'auth_response_model.g.dart';

@JsonSerializable()
class AuthResponseModel {
  final String token;
  final UserModel user;

  const AuthResponseModel({required this.token, required this.user});

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$AuthResponseModelToJson(this);

  AuthResultEntity toEntity() =>
      AuthResultEntity(token: token, user: user.toEntity());
}
