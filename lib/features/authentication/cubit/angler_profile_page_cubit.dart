import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sb_mobile/features/authentication/data/models/angler_profile_details_model.dart';
import 'package:sb_mobile/features/authentication/data/sources/api/sb_backend.dart';

part 'angler_profile_page_state.dart';

class AnglerProfilePageCubit extends Cubit<AnglerProfilePageState> {
  AnglerProfilePageCubit({required this.apiProvider})
      : super(AnglerProfilePageInitial());

  final SwimbookerApiProvider apiProvider;

  Future<void> fetchAnglerProfile() async {
    final response = await apiProvider.fetchAnglerProfile();
    if (response != null) {
      if (response.profile != null) {
        // emit(AnglerProfileDummy());
        emit(AnglerProfileLoaded(profile: response.profile!));
      }
    } else {
      emit(const AnglerProfileFailed(message: "API Failure"));
    }
  }

  Future<void> logout() async {
    await apiProvider.logout();
  }

  Future<void> resetPassword() async {
    await apiProvider.resetPassword();
  }

  Future<void> updateUserDetails({required AnglerProfile profile}) async {
    await apiProvider.updateUserDetails(profile: profile);
  }
}
