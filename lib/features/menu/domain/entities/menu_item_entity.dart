class MenuItemEntity {
  final String id;
  final String name;
  final double price;
  final String? description;
  final String? category;
  final String? imageUrl;
  final bool? isAvailable;
  final int? timeTaken;

  const MenuItemEntity({
    required this.id,
    required this.name,
    required this.price,
    this.description,
    this.category,
    this.imageUrl,
    this.isAvailable,
    this.timeTaken,
  });
}
