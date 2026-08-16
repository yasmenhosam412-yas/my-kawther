class LoginResponse {
  final String token;
  final int? userId;
  final String? userName;
  final String? email;
  final String? phone;

  LoginResponse({
    required this.token,
    this.userId,
    this.userName,
    this.email,
    this.phone,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final original = json['original'];
    return LoginResponse(
      token: original['token'],
      userId: original['user']?['id'],
      userName: original['user']?['name'],
      email: original['user']?['email'],
      phone: original['user']?['phone'],
    );
  }
}

class RegisterResponse {
  final String? token;
  final int? userId;
  final String? userName;
  final String? email;
  final String? phone;

  RegisterResponse({
    this.token,
    this.userId,
    this.userName,
    this.email,
    this.phone,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return RegisterResponse(
      token: data['token'],
      userId: data['id'] as int?,
      userName: data['name'] as String?,
      email: data['email'] as String?,
      phone: data['phone'] as String?,
    );
  }
}
