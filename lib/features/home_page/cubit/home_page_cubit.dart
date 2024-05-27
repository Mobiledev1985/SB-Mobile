import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sb_mobile/core/config/authenticator.dart';
import 'package:sb_mobile/features/authentication/data/models/angler_profile_details_model.dart';
import 'package:sb_mobile/features/fishery_property_details/data/models/catch_report_model.dart';
import 'package:sb_mobile/features/home_page/data/models/articles_api_response.dart';
import 'package:sb_mobile/features/home_page/data/models/fisheries_model.dart';
import 'package:sb_mobile/features/home_page/data/models/home_model.dart';
import 'package:sb_mobile/features/home_page/data/models/notification_model.dart';
import 'package:sb_mobile/features/home_page/data/models/user_statistics.dart';
import 'package:sb_mobile/features/home_page/data/sources/api/sb_backend.dart';
import 'package:sb_mobile/features/my_profile/data/models/achivement_model.dart';
import 'package:sb_mobile/features/user_bookings/data/models/api_response.dart';

part 'home_page_state.dart';

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit() : super(HomePageInitial());

  SwimbookerApiProvider apiProvider = SwimbookerApiProvider();

  Future<void> loadHomePage([bool needToLoad = false]) async {
    if (needToLoad) {
      emit(HomePageInitial());
    }

    bool response = await auth.login(aggresive: true, notify: false);

    AnglerProfile? anglerProfile;
    SavedFisheriesApiResponse? savedFisheries;
    String? subscriptionLevel;
    UserStatistics? userStatistics;
    List<NotificationModel>? notifications;
    AchievementModel? achievementModel;

    if (response) {
      final response = await apiProvider.fetchAnglerProfile();
      anglerProfile = response?.profile;
      subscriptionLevel = await apiProvider.getSubscriptionLevel();
      userStatistics = await apiProvider.getUserStatistics();
      notifications = await apiProvider.getNotifications();
      achievementModel = await apiProvider.getAchivements();

      if (subscriptionLevel != null &&
          (subscriptionLevel.toLowerCase().contains('pro') ||
              subscriptionLevel.toLowerCase().contains('plus'))) {
        userStatistics?.catchReport?.userSubscriptionLevel = subscriptionLevel;
        final walletModel = await apiProvider.getWallet();

        if (walletModel != null && walletModel.balanceInPence != null) {
          anglerProfile?.walletAmount = walletModel.balanceInPence!.toDouble();
        }
      }
    }
    final (
      List<FisheriesModel>? bookableVenues,
      List<CatchReport>? catchReports
    ) = await apiProvider.getHomeData();

    SocialArticlesResponse articles = await apiProvider.fetchAllStories();
    if (response) {
      savedFisheries = await apiProvider.getSavedFisheries();

      if (savedFisheries?.results != null) {
        final savedFisheryIds =
            savedFisheries?.results!.fisheries.map((e) => e.id).toSet();

        for (var element in bookableVenues ?? []) {
          element.isFavourite = savedFisheryIds?.contains(element.id);
        }
      }
    }
    final homeModel = HomeModel(
      exclusive: exclusiveMediaList(),
      articles: articles.results?.articles,
      bookableVenues: bookableVenues,
      liveCatchReport: catchReports,
    );

    emit(
      HomePageLoaded(
        isLoggedIn: response,
        homeModel: homeModel,
        profile: anglerProfile,
        subscriptionLevel: subscriptionLevel,
        userStatistics: userStatistics,
        notifications: notifications,
        achievementModel: achievementModel,
      ),
    );
  }

  Future<void> refresh(bool isLoggedIn) async {
    emit(HomePageDummy());
    AnglerProfile? anglerProfile;
    SavedFisheriesApiResponse? savedFisheries;
    String? subscriptionLevel;
    UserStatistics? userStatistics;
    List<NotificationModel>? notifications;
    AchievementModel? achievementModel;

    if (!isLoggedIn) {
      await auth.login(aggresive: true, notify: false);
      // isLoggedIn = response;
      final anglerProfileApiResponse = await apiProvider.fetchAnglerProfile();
      anglerProfile = anglerProfileApiResponse?.profile;
      subscriptionLevel = await apiProvider.getSubscriptionLevel();
      userStatistics = await apiProvider.getUserStatistics();
      notifications = await apiProvider.getNotifications();
      achievementModel = await apiProvider.getAchivements();

      if (subscriptionLevel != null &&
          (subscriptionLevel.toLowerCase().contains('pro') ||
              subscriptionLevel.toLowerCase().contains('plus'))) {
        final walletModel = await apiProvider.getWallet();

        if (walletModel != null && walletModel.balanceInPence != null) {
          anglerProfile?.walletAmount = walletModel.balanceInPence!.toDouble();
        }
      }
    }

    final (
      List<FisheriesModel>? bookableVenues,
      List<CatchReport>? catchReports
    ) = await apiProvider.getHomeData();

    SocialArticlesResponse articles = await apiProvider.fetchAllStories();
    if (!isLoggedIn) {
      savedFisheries = await apiProvider.getSavedFisheries();

      if (savedFisheries?.results != null) {
        final savedFisheryIds =
            savedFisheries?.results!.fisheries.map((e) => e.id).toSet();

        for (var element in bookableVenues ?? []) {
          element.isFavourite = savedFisheryIds?.contains(element.id);
        }
      }
    }

    final homeModel = HomeModel(
      exclusive: exclusiveMediaList(),
      articles: articles.results?.articles,
      bookableVenues: bookableVenues,
      liveCatchReport: catchReports,
    );

    emit(
      HomePageLoaded(
        isLoggedIn: anglerProfile != null,
        homeModel: homeModel,
        profile: anglerProfile,
        subscriptionLevel: subscriptionLevel,
        userStatistics: userStatistics,
        notifications: notifications,
        achievementModel: achievementModel,
      ),
    );
  }

  Future<void> refreshNotification() async {
    final HomePageLoaded homePageLoaded = state as HomePageLoaded;
    final List<NotificationModel>? notifications =
        await apiProvider.getNotifications();
    if (notifications != null && notifications.isNotEmpty) {
      emit(HomePageDummy());
      emit(
        homePageLoaded.copyWith(notifications: notifications),
      );
    }
  }

  Future<bool> logout() async {
    return await apiProvider.logout();
  }

  Future<void> onFavorite({required String fisheryId}) async {
    final currentState = state as HomePageLoaded;
    final updatedBookableVenues =
        List<FisheriesModel>.from(currentState.homeModel.bookableVenues ?? []);

    final targetFisheryIndex = updatedBookableVenues.indexWhere(
      (element) => element.id == fisheryId,
    );

    if (targetFisheryIndex != -1) {
      final targetFishery = updatedBookableVenues[targetFisheryIndex];
      targetFishery.isFavourite = !targetFishery.isFavourite!;

      final updatedHomeModel = currentState.homeModel.copyWith(
        bookableVenues: updatedBookableVenues,
      );

      emit(currentState.copyWith(homeModel: updatedHomeModel));

      final bool isFavorite = await apiProvider.updateUserFavourite(
        fisheryId: fisheryId,
      );

      if (!isFavorite) {
        targetFishery.isFavourite = !targetFishery.isFavourite!;
        final updatedHomeModel = currentState.homeModel.copyWith(
          bookableVenues: updatedBookableVenues,
        );

        emit(currentState.copyWith(homeModel: updatedHomeModel));
      }
    }
  }

  List<NotificationModel> getNotification(bool isRead) {
    return (state as HomePageLoaded)
            .notifications
            ?.where((element) => element.isRead != null
                ? isRead
                    ? element.isRead!
                    : !element.isRead!
                : false)
            .toList() ??
        [];
  }

  Future<void> onReadNotification(List<String> notificationIds) async {
    final bool isMarkAsRead =
        await apiProvider.readNotifications(notificationIds);

    if (isMarkAsRead) {
      final List<NotificationModel> updatedNotifications =
          (state as HomePageLoaded).notifications!.map((e) {
        return notificationIds.contains(e.id)
            ? NotificationModel(
                id: e.id,
                body: e.body,
                createdAt: e.createdAt,
                data: e.data,
                title: e.title,
                userId: e.userId,
                isRead: true,
              )
            : e;
      }).toList();

      final HomePageLoaded homePageLoaded = (state as HomePageLoaded)
          .copyWith(notifications: updatedNotifications);

      emit(HomePageDummy());
      emit(homePageLoaded);
    }
  }

  List<Exclusive> exclusiveMediaList() {
    return [
      Exclusive(
          name: 'Flythroughs',
          icon: 'assets/icons/drone.svg',
          backgroundImage: 'assets/images/exclusive_1.png',
          apiEndpoint: apiProvider.api.sbFlythroughs),
      Exclusive(
          name: 'Virtual Tours',
          icon: 'assets/icons/360-degrees.svg',
          backgroundImage: 'assets/images/exclusive_2.png',
          apiEndpoint: apiProvider.api.sbVirtuals),
      Exclusive(
          name: 'SB Diaries',
          icon: 'assets/icons/fish.png',
          backgroundImage: 'assets/images/exclusive_3.png',
          apiEndpoint: apiProvider.api.sbDiaries),
      Exclusive(
        name: 'Angling Social',
        icon: 'assets/icons/notification.svg',
        backgroundImage: 'assets/images/exclusive_4.png',
      ),
    ];
  }
}
