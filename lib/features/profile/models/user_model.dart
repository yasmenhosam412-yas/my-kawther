class UserModel {
  final int id;
  final String name;
  final String phone;
  final String email;
  final String? password;
  final String? socialId;
  final String? socialProvider;
  final bool isVerified;
  final String? otpCode;
  final String? otpExpiresAt;
  final String createdAt;
  final String updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.password,
    this.socialId,
    this.socialProvider,
    required this.isVerified,
    this.otpCode,
    this.otpExpiresAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      password: json['password'],
      socialId: json['social_id'],
      socialProvider: json['social_provider'],
      isVerified: json['is_verified'],
      otpCode: json['otp_code'],
      otpExpiresAt: json['otp_expires_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'password': password,
      'social_id': socialId,
      'social_provider': socialProvider,
      'is_verified': isVerified,
      'otp_code': otpCode,
      'otp_expires_at': otpExpiresAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
