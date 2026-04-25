// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MenuItemModel _$MenuItemModelFromJson(Map<String, dynamic> json) =>
    MenuItemModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String?,
      category: json['category'] as String?,
      imageUrl: json['imageUrl'] as String?,
      isAvailable: json['isAvailable'] as bool?,
      timeTaken: (json['timeTaken'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MenuItemModelToJson(MenuItemModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'description': instance.description,
      'category': instance.category,
      'imageUrl': instance.imageUrl,
      'isAvailable': instance.isAvailable,
      'timeTaken': instance.timeTaken,
    };
