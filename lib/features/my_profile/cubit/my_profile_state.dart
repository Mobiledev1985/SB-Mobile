part of 'my_profile_cubit.dart';

sealed class MyProfileState extends Equatable {
  const MyProfileState();

  @override
  List<Object?> get props => [];
}

final class MyProfileInitial extends MyProfileState {}

final class MyProfileLoading extends MyProfileState {}

final class MyProfileLoaded extends MyProfileState {
  final AnglerProfile? profile;
  final String? profileImage;
  final String? backgroundImage;
  final UserStatistics? userStatistics;
  final bool isInSessionButtonVisible;
  final bool isPlusMember;
  final WalletModel? wallet;
  final AchievementModel? achievementModel;
  const MyProfileLoaded({
    required this.profileImage,
    required this.backgroundImage,
    required this.profile,
    required this.userStatistics,
    required this.isInSessionButtonVisible,
    required this.isPlusMember,
    required this.wallet,
    required this.achievementModel,
  });

  MyProfileLoaded copyWith({
    AnglerProfile? profile,
    String? profileImage,
    String? backgroundImage,
    UserStatistics? userStatistics,
    bool? isInSessionButtonVisible,
    bool? isPlusMember,
    WalletModel? wallet,
    AchievementModel? achievementModel,
  }) {
    return MyProfileLoaded(
      profile: profile ?? this.profile,
      profileImage: profileImage ?? this.profileImage,
      backgroundImage: backgroundImage ?? this.backgroundImage,
      userStatistics: userStatistics ?? this.userStatistics,
      isInSessionButtonVisible:
          isInSessionButtonVisible ?? this.isInSessionButtonVisible,
      isPlusMember: isPlusMember ?? this.isPlusMember,
      wallet: wallet ?? this.wallet,
      achievementModel: achievementModel ?? this.achievementModel,
    );
  }

  @override
  List<Object?> get props => [
        profile,
        profileImage,
        backgroundImage,
        userStatistics,
      ];
}

// final class SelectedImageState extends MyProfileState {
//   final File? profileImage;
//   final File? backgroundImage;

//   const SelectedImageState({
//     required this.profileImage,
//     required this.backgroundImage,
//   });

//   SelectedImageState copyWith({
//     File? profileImage,
//     File? backgroundImage,
//   }) {
//     return SelectedImageState(
//       profileImage: profileImage ?? this.profileImage,
//       backgroundImage: backgroundImage ?? this.backgroundImage,
//     );
//   }

//   @override
//   List<Object?> get props => [profileImage, backgroundImage];
// }

final class MyProfileFailed extends MyProfileState {
  final String message;

  const MyProfileFailed({required this.message});

  @override
  List<Object> get props => [message];
}
