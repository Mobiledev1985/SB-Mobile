import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sb_mobile/features/authentication/data/sources/api/sb_backend.dart';

part 'auth_helper_state.dart';

class AuthHelperCubit extends Cubit<AuthHelperState> {
  AuthHelperCubit() : super(const AuthHelperState());

  final SwimbookerApiProvider apiProvider = SwimbookerApiProvider();

  Future<void> fetchAuthStatus() async {
    try {
      final response = await apiProvider.verifyAuthentication();

      if (response.isLoggedIn) {
        emit(state.copyWith(status: () => AuthHelperStatus.authenticated));
      } else {
        emit(state.copyWith(status: () => AuthHelperStatus.notAuthenticated));
      }
    } catch (e) {
      // print(e);
      emit(state.copyWith(status: () => AuthHelperStatus.initial));
    }
  }
}
