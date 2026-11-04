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
    final id = json['id'];
    final verified = json['is_verified'];

    return UserModel(
      id: id is num ? id.toInt() : int.tryParse('$id') ?? 0,
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      password: json['password']?.toString(),
      socialId: json['social_id']?.toString(),
      socialProvider: json['social_provider']?.toString(),
      isVerified:
          verified == true || verified == 1 || verified?.toString() == '1',
      otpCode: json['otp_code']?.toString(),
      otpExpiresAt: json['otp_expires_at']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
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
