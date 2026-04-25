import 'package:json_annotation/json_annotation.dart';
import 'package:canteen_mangement/features/menu/domain/entities/menu_item_entity.dart';

part 'menu_item_model.g.dart';

@JsonSerializable()
class MenuItemModel {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final double price;
  final String? description;
  final String? category;
  final String? imageUrl;
  final bool? isAvailable;
  final int? timeTaken;

  const MenuItemModel({
    required this.id,
    required this.name,
    required this.price,
    this.description,
    this.category,
    this.imageUrl,
    this.isAvailable,
    this.timeTaken,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) =>
      _$MenuItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$MenuItemModelToJson(this);

  MenuItemEntity toEntity() => MenuItemEntity(
        id: id,
        name: name,
        price: price,
        description: description,
        category: category,
        imageUrl: imageUrl,
        isAvailable: isAvailable,
        timeTaken: timeTaken,
      );
}
