class UserEntity {
  final String? id;
  final String name;
  final String phone;
  final DateTime? createdAt;

  const UserEntity({
    this.id,
    required this.name,
    required this.phone,
    this.createdAt,
  });
}
