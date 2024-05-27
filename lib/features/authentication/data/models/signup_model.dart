import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class SignupRecord extends Equatable {
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  bool? isNewsSubscribed;
  @override
  List<Object?> get props => [firstName, lastName];

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": password,
      "first_name": firstName,
      "last_name": lastName,
      "is_news_subscribed": isNewsSubscribed
    };
  }
}
