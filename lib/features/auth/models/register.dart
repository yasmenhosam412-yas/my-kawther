class RegisterRequest {
  String name;
  String email;
  String phone;

  String password;
  String? passwordConfirmation;

  RegisterRequest({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    this.passwordConfirmation,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'phone': phone,
    'password': password,
    'confirm_password': passwordConfirmation,
  };
}
