part of 'angler_profile_page_cubit.dart';

abstract class AnglerProfilePageState extends Equatable {
  @override
  List<Object> get props => [];
  const AnglerProfilePageState();
}

class AnglerProfilePageInitial extends AnglerProfilePageState {}

class AnglerLogout extends AnglerProfilePageState {}

class AnglerProfileLoaded extends AnglerProfilePageState {
  final AnglerProfile profile;

  const AnglerProfileLoaded({required this.profile});

  @override
  List<Object> get props => [profile.firstName, profile.lastName];
}

class AnglerProfileDummy extends AnglerProfilePageState {}

class AnglerProfileFailed extends AnglerProfilePageState {
  final String message;

  const AnglerProfileFailed({required this.message});

  @override
  List<Object> get props => [message];
}
