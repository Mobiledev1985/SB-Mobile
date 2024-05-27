import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sb_mobile/features/authentication/data/sources/api/sb_backend.dart';

part 'authentication_status_state.dart';

class AuthenticationStatusCubit extends Cubit<AuthenticationStatusState> {
  AuthenticationStatusCubit({required this.apiProvider})
      : super(AuthenticationStatusInitial());

  final SwimbookerApiProvider apiProvider;

  Future<void> reload() async {
    emit(AuthenticationStatusInitial());
  }

  Future<void> fetchAuthStatus() async {
    final response = await apiProvider.verifyAuthentication();

    emit(AuthenticationStatusLoading());

    if (response.isLoggedIn) {
      emit(const AuthenticationStatusIdentified(isAuthenticated: true));
    } else {
      emit(const AuthenticationStatusIdentified(isAuthenticated: false));
    }
  }

  void onLogoutStateChange() {
    emit(const AuthenticationStatusIdentified(isAuthenticated: false));
  }
}
