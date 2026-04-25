class UpdateProfileRequestModel {
  final String? name;
  final String? currentPassword;
  final String? newPassword;

  const UpdateProfileRequestModel({this.name, this.currentPassword, this.newPassword});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (name != null) map['name'] = name;
    if (currentPassword != null) map['currentPassword'] = currentPassword;
    if (newPassword != null) map['newPassword'] = newPassword;
    return map;
  }
}
