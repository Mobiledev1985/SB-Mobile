import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 1)
class UserCredentials {
  @HiveField(0)
  final String email;

  @HiveField(1)
  final String password;

  @HiveField(2)
  final String token;

  UserCredentials({
    required this.email,
    required this.password,
    required this.token
  });


  @override
  String toString() => email;
}
