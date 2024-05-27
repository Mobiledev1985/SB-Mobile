part of 'my_membership_cubit.dart';

sealed class MyMembershipState extends Equatable {
  const MyMembershipState();

  @override
  List<Object> get props => [];
}

final class MyMembershipInitial extends MyMembershipState {}

final class MyMembershipsLoading extends MyMembershipState {}

final class MyMembershipsFailed extends MyMembershipState {}

final class MyMembershipsLoaded extends MyMembershipState {
  const MyMembershipsLoaded({
    required this.memberships,
    required this.seasonTickets,
  });

  final List<MembershipAndSeasonTicketModel> memberships;
  final List<MembershipAndSeasonTicketModel> seasonTickets;
}
