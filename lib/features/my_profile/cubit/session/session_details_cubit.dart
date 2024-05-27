import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sb_mobile/features/my_profile/data/models/session_detail_model.dart';
import 'package:sb_mobile/features/my_profile/data/source/sb_backend.dart';

part 'session_details_state.dart';

class SessionDetailsCubit extends Cubit<SessionDetailsState> {
  SessionDetailsCubit() : super(SessionDetailsInitial());

  final SwimbookerApiProvider apiProvider = SwimbookerApiProvider();

  Future<void> getSessionDetails(String sessionId) async {
    emit(SessionDetailsLoading());
    final SessionDetailModel? sessionDetail =
        await apiProvider.getSessionDetail(sessionId: sessionId);
    if (sessionDetail != null) {
      emit(SessionDetailsSuccess(sessionDetail));
    } else {
      emit(SessionDetailsFailed());
    }
  }
}
