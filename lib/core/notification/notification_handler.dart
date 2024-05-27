import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart'
    show BuildContext, Colors, MaterialPageRoute, Navigator;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:sb_mobile/core/config/server_config.dart';
import 'package:sb_mobile/core/notification/web_view_screen.dart';
import 'package:sb_mobile/features/authentication/data/models/angler_profile_details_model.dart';
import 'package:sb_mobile/features/exclusiveMedia/ui/view/exclusive_media_common_screen.dart';
import 'package:sb_mobile/features/home_page/cubit/home_page_cubit.dart';
import 'package:sb_mobile/features/home_page/data/models/user_statistics.dart';
import 'package:sb_mobile/features/home_page/ui/views/bottom_bar_provider.dart';
import 'package:sb_mobile/features/home_page/ui/views/bottom_bar_screen.dart';
import 'package:sb_mobile/features/my_profile/cubit/my_profile_cubit.dart';
import 'package:sb_mobile/features/my_profile/ui/view/bookings_screen.dart';
import 'package:sb_mobile/features/my_profile/ui/view/catches_screen.dart';
import 'package:sb_mobile/features/my_profile/ui/view/favorite_screen.dart';
import 'package:sb_mobile/features/my_profile/ui/view/my_details_screen.dart';
import 'package:sb_mobile/features/my_profile/ui/view/statistics_screen.dart';
import 'package:sb_mobile/features/my_profile/ui/view/subscription/giveaways/giveaways_screen.dart';
import 'package:sb_mobile/features/my_profile/ui/view/subscription/insurance/insurance_screen.dart';
import 'package:sb_mobile/features/my_profile/ui/view/subscription/offer/offer_screen.dart';
import 'package:sb_mobile/features/my_profile/ui/view/subscription/session/session_screen.dart';
import 'package:sb_mobile/features/my_profile/ui/view/subscription/wallet/wallet_screen.dart';

class NotificationHandler {
  NotificationHandler._();

  factory NotificationHandler.getInstance() {
    return _instance;
  }
  static final NotificationHandler _instance = NotificationHandler._();

  List<String> bottomBarItems = [
    "home",
    "search",
    "my_sb",
    "social",
    "360",
  ];
  List<String> homeNavigationItems = [
    "flythroughs",
    "sb_diaries",
  ];

  List<String> mySBNavigationItems = [
    "catches",
    "statistics",
    "my_details",
    "bookings",
    "favourites",
  ];

  List<String> sbPlusNavigation = [
    "wallet",
    "shop",
    "perks",
    "insurance",
    "sessions",
    "giveaways",
  ];

  void handleNotification<T extends StateStreamableSource<Object?>, V>(
      BuildContext context, Function(V) onSuccess) {
    StreamSubscription<Object?>? streamSubscription;

    streamSubscription = BlocProvider.of<T>(context).stream.listen(
      (event) {
        if (event is V) {
          onSuccess.call(event); // Pass the actual event, not its runtime type
          streamSubscription?.cancel();
        }
      },
    );
  }

  Future<void> homeScreenExtendedScreenNavigation(
      BuildContext context, String section) async {
    if (context.read<HomePageCubit>().state is HomePageLoaded) {
      if (section == 'flythroughs') {
        await ExclusiveMediaCommonScreen.navigateTo(
          context,
          (
            text: 'Flythroughs',
            image: 'assets/icons/drone.svg',
            apiEndPoint: ApiServerConfig().sbFlythroughs,
            profile:
                (context.read<HomePageCubit>().state as HomePageLoaded).profile,
            isFromHomeScreen: false
          ),
        );
      } else {
        await ExclusiveMediaCommonScreen.navigateTo(
          context,
          (
            text: 'SB Diaries',
            image: 'assets/icons/fish.png',
            apiEndPoint: ApiServerConfig().sbDiaries,
            profile:
                (context.read<HomePageCubit>().state as HomePageLoaded).profile,
            isFromHomeScreen: false
          ),
        );
      }
    }
  }

  void mySbNavigation(BuildContext context, String section,
      AnglerProfile? profile, UserStatistics? userStatistics) {
    if (section == 'catches') {
      CatchesScreen.navigateTo(context, profile);
    } else if (section == 'statistics' && userStatistics != null) {
      StatisticsScreen.navigateTo(context, userStatistics);
    } else if (section == 'my_details') {
      MyDetailsScreen.navigateTo(context, (profile: profile!, onSave: () {}));
    } else if (section == 'bookings') {
      BookingsScreen.navigateTo(
        context,
        profile,
      );
    } else if (section == 'favourites') {
      FavoriteScreen.navigateTo(context, profile);
    }
  }

  Future<void> mySbNotificationHandler(
      BuildContext context, String section) async {
    if (context.read<MyProfileCubit>().state is MyProfileLoaded) {
      final state = context.read<MyProfileCubit>().state as MyProfileLoaded;
      mySbNavigation(context, section, state.profile, state.userStatistics);
    } else {
      final state = context.read<HomePageCubit>().state as HomePageLoaded;
      mySbNavigation(context, section, state.profile, state.userStatistics);
    }
  }

  void bottomBarNotificationHandler(BuildContext context, String section) {
    SystemUiOverlayStyle androidStyle;
    Color statusBarColor;

    switch (section) {
      case 'home':
        androidStyle = const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
        );
        statusBarColor = Colors.white;
        BottomBarProvider.of(context).selectedBottomBarItem.value = 0;
        break;
      case 'search':
      case 'my_sb':
      case 'social':
        androidStyle = const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        );
        statusBarColor = Colors.transparent;
        BottomBarProvider.of(context).selectedBottomBarItem.value =
            section == 'search' ? 1 : (section == 'my_sb' ? 2 : 3);

        break;
      case '360':
        androidStyle = const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
        );
        statusBarColor = Colors.white;
        BottomBarProvider.of(context).selectedBottomBarItem.value = 4;
        break;
      default:
        return;
    }

    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(androidStyle);
    } else {
      FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
      FlutterStatusbarcolor.setStatusBarColor(statusBarColor);
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const BottomBarScreen(),
      ),
      (route) => false,
    );
  }

  Future<void> sbPlusNotificationHandler(
      BuildContext context, String section) async {
    final state = context.read<HomePageCubit>().state as HomePageLoaded;
    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light),
      );
    } else {
      FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
      FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    }
    if (section == "wallet") {
      await WalletScreen.navigateTo(context, state.profile);
    } else if (section == 'shop') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const WebViewScreen(
            url: '',
            isGoBackToHomeScreen: false,
            title: 'Shop',
          ),
        ),
      );
    } else if (section == "perks") {
      await OfferScreen.navigateTo(context, state.profile);
    } else if (section == "insurance") {
      await InsuranceScreen.navigateTo(context,
          (profile: state.profile, subscriptionLevel: state.subscriptionLevel));
    } else if (section == "sessions") {
      await SessionScreen.navigateTo(context, state.profile);
    } else if (section == "giveaways") {
      await GiveawaysScreen.navigateTo(context, state.profile);
    }
  }
}
