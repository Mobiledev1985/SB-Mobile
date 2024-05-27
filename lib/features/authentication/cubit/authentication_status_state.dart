part of 'authentication_status_cubit.dart';



abstract class AuthenticationStatusState extends Equatable {
  const AuthenticationStatusState();
}

class AuthenticationStatusInitial extends AuthenticationStatusState {
  @override
  List<Object> get props => [];
}

class AuthenticationStatusLoading extends AuthenticationStatusState {
  @override
  List<Object> get props => [];
}

class AuthenticationStatusIdentified extends AuthenticationStatusState {
  final bool isAuthenticated ;

  const AuthenticationStatusIdentified({required this.isAuthenticated});

  @override
  List<Object> get props => [isAuthenticated];
}

class AuthenticationStatusFailed extends AuthenticationStatusState {
  final String message ;

  const AuthenticationStatusFailed({required this.message});

  @override
  List<Object> get props => [message];
}


