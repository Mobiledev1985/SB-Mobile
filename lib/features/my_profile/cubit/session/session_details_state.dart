part of 'session_details_cubit.dart';

sealed class SessionDetailsState extends Equatable {
  const SessionDetailsState();

  @override
  List<Object> get props => [];
}

final class SessionDetailsInitial extends SessionDetailsState {}

final class SessionDetailsLoading extends SessionDetailsState {}

final class SessionDetailsSuccess extends SessionDetailsState {
  final SessionDetailModel sessionDetail;

  const SessionDetailsSuccess(this.sessionDetail);
}

final class SessionDetailsFailed extends SessionDetailsState {}
