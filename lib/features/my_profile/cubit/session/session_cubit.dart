import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sb_mobile/features/home_page/data/models/session_model.dart';
import 'package:sb_mobile/features/my_profile/data/models/session_detail_model.dart';
import 'package:sb_mobile/features/my_profile/data/source/sb_backend.dart';

part 'session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  SessionCubit() : super(SessionInitial());
  final SwimbookerApiProvider apiProvider = SwimbookerApiProvider();
  List<SessionModel>? sessions = [];
  Future<void> getSessions() async {
    emit(SessionLoading());
    sessions = await apiProvider.getSessions();

    if (sessions != null) {
      final Set<String> fisheryIds =
          sessions!.map((session) => session.fisheryId!).toSet();

      await Future.forEach(fisheryIds, (element) async {
        final String? imageUrl =
            await apiProvider.getFisheryImage(publicId: element);
        for (var e in sessions!) {
          if (e.fisheryId == element) {
            e.imageUrl = imageUrl;
          }
        }
      });
    }

    emit(SessionsList(sessions ?? []));
  }

  void filter(bool isNewestFirst) {
    emit(SessionLoading());
    final List<SessionModel> sortedSessions =
        List<SessionModel>.from(sessions!);

    sortedSessions.sort((a, b) {
      DateTime aTime = DateTime.parse(a.endTs!);
      DateTime bTime = DateTime.parse(b.endTs!);
      return isNewestFirst ? bTime.compareTo(aTime) : aTime.compareTo(bTime);
    });

    emit(SessionsList(sortedSessions));
  }

  void dateRangeFilter(DateTimeRange range) {
    emit(SessionLoading());
    final List<SessionModel> filteredSessions =
        List<SessionModel>.from(sessions!);

    filteredSessions.removeWhere((session) {
      final sessionTime = DateTime.parse(session.endTs!);
      return sessionTime.isBefore(range.start) ||
          sessionTime.isAfter(range.end.add(const Duration(days: 1)));
    });

    emit(SessionsList(filteredSessions));
  }

  void clearFilter() {
    emit(SessionLoading());
    emit(SessionsList(sessions!));
  }

  void updateNotes(SessionNotes sessionNotes) {
    apiProvider.updateNotes(sessionNotes: sessionNotes);
  }
}
