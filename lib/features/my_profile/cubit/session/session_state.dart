part of 'session_cubit.dart';

sealed class SessionState extends Equatable {
  const SessionState();

  @override
  List<Object> get props => [];
}

final class SessionInitial extends SessionState {}

final class SessionLoading extends SessionState {}

final class SessionsList extends SessionState {
  final List<SessionModel> sessions;

  const SessionsList(this.sessions);
}
