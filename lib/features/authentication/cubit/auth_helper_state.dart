part of 'auth_helper_cubit.dart';

enum AuthHelperStatus { initial, authenticated, notAuthenticated }

class AuthHelperState extends Equatable {
  const AuthHelperState({
    this.status = AuthHelperStatus.initial,
  });

  final AuthHelperStatus status;

  AuthHelperState copyWith({
    AuthHelperStatus Function()? status,
  }) {
    return AuthHelperState(
      status: status != null ? status() : this.status,
    );
  }

  @override
  List<Object?> get props => [status];
}
