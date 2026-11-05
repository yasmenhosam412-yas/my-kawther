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
    final data =
        json['data'] is Map<String, dynamic>
            ? json['data'] as Map<String, dynamic>
            : json['original'] is Map<String, dynamic>
            ? json['original'] as Map<String, dynamic>
            : json;
    final token = data['token'];
    if (token is! String || token.trim().isEmpty) {
      throw const FormatException('Login response does not contain a token');
    }

    final user =
        data['user'] is Map<String, dynamic>
            ? data['user'] as Map<String, dynamic>
            : <String, dynamic>{};
    return LoginResponse(
      token: token,
      userId: (user['id'] as num?)?.toInt(),
      userName: user['name'] as String?,
      email: user['email'] as String?,
      phone: user['phone'] as String?,
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
