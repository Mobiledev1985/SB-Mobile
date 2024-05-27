part of 'home_page_cubit.dart';

abstract class HomePageState extends Equatable {
  const HomePageState();
}

class HomePageInitial extends HomePageState {
  @override
  List<Object> get props => [];
}

class HomePageDummy extends HomePageState {
  @override
  List<Object> get props => [];
}

class HomePageLoaded extends HomePageState {
  final bool isLoggedIn;
  // final FeaturedFisheriesModel featured;
  // final SocialsArticles articles;
  final HomeModel homeModel;
  final AnglerProfile? profile;
  final String? subscriptionLevel;
  final UserStatistics? userStatistics;
  final List<NotificationModel>? notifications;
  final AchievementModel? achievementModel;
  const HomePageLoaded({
    required this.isLoggedIn,
    // required this.featured,
    // required this.articles,
    required this.homeModel,
    required this.profile,
    required this.subscriptionLevel,
    required this.userStatistics,
    required this.notifications,
    required this.achievementModel,
  });

  @override
  List<Object> get props => [isLoggedIn, homeModel];

  HomePageLoaded copyWith(
      {bool? isLoggedIn,
      // FeaturedFisheriesModel? featured,
      // SocialsArticles? articles,
      HomeModel? homeModel,
      AnglerProfile? profile,
      String? subscriptionLevel,
      UserStatistics? userStatistics,
      List<NotificationModel>? notifications,
      AchievementModel? achievementModel}) {
    return HomePageLoaded(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      // featured: featured ?? this.featured,
      // articles: articles ?? this.articles,
      homeModel: homeModel ?? this.homeModel,
      profile: profile ?? this.profile,
      subscriptionLevel: subscriptionLevel ?? this.subscriptionLevel,
      userStatistics: userStatistics ?? this.userStatistics,
      notifications: notifications ?? this.notifications,
      achievementModel: achievementModel ?? this.achievementModel,
    );
  }
}
