import 'package:json_annotation/json_annotation.dart';
import 'package:canteen_mangement/features/auth/domain/entities/user_entity.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  @JsonKey(name: '_id')
  final String? id;
  final String name;
  final String phone;
  final DateTime? createdAt;

  const UserModel({this.id, required this.name, required this.phone, this.createdAt});

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserEntity toEntity() => UserEntity(id: id, name: name, phone: phone, createdAt: createdAt);
}
