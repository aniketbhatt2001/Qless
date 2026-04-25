class RegisterRequestModel {
  final String name;
  final String phone;
  final String password;

  const RegisterRequestModel({
    required this.name,
    required this.phone,
    required this.password,
  });

  Map<String, dynamic> toJson() => {'name': name, 'phone': phone, 'password': password};
}
