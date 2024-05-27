part of 'giveaway_cubit.dart';

sealed class GiveawayState extends Equatable {
  const GiveawayState();

  @override
  List<Object> get props => [];
}

final class GiveawayInitial extends GiveawayState {}

final class GiveawayLoading extends GiveawayState {}

final class GiveawayFailed extends GiveawayState {
  final String message;

  const GiveawayFailed(this.message);
}

final class GiveawaySuccess extends GiveawayState {
  final List<GiveawayQuizModel> giveawayQuizzes;

  const GiveawaySuccess(
    this.giveawayQuizzes,
  );
}
