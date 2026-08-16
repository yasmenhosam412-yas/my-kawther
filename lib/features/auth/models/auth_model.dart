import 'package:elkawther/core/utils/user_type.dart';

class AuthModel {
  final String? name;
  final String? token;
  final int? userId;
  final UserType status;

  AuthModel({this.name, this.token, this.userId, required this.status});
}
