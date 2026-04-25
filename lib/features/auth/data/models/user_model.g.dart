// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: json['_id'] as String?,
  name: json['name'] as String,
  phone: json['phone'] as String,
  createdAt:
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  '_id': instance.id,
  'name': instance.name,
  'phone': instance.phone,
  'createdAt': instance.createdAt?.toIso8601String(),
};
