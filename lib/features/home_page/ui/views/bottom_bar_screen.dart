import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_images.dart';
import 'package:sb_mobile/core/constant/app_strings.dart';
import 'package:sb_mobile/core/notification/firebase_notification_service.dart';
import 'package:sb_mobile/core/notification/local_notification_service.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';
import 'package:sb_mobile/features/authentication/ui/views/authentication_view.dart';
import 'package:sb_mobile/features/exclusiveMedia/ui/view/exclusive_media_common_screen.dart';
import 'package:sb_mobile/features/home_page/cubit/home_page_cubit.dart';
import 'package:sb_mobile/features/home_page/ui/views/home_page_view.dart';
import 'package:sb_mobile/features/home_page/ui/views/bottom_bar_provider.dart';
import 'package:sb_mobile/features/search/ui/views/google_maps_view.dart';
import 'package:sb_mobile/features/social/ui/views/social_view.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({super.key});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  late final List<Widget> screens;
  bool isFirstTime = true;
  late ValueNotifier<int> selectedBottomBarItem;
  final List<BottomBarModel> bottomBarItems = [
    // Define the list of BottomBarModel items for the bottom bar
    BottomBarModel(
      title: AppStrings.home,
      image: AppImages.home,
    ),
    BottomBarModel(
      title: AppStrings.search,
      image: AppImages.searchIcon,
    ),
    BottomBarModel(
      title: 'My SB',
      image: AppImages.fish,
    ),
    BottomBarModel(
      title: AppStrings.social,
      image: AppImages.chat,
    ),
    BottomBarModel(
      title: '360°',
      image: AppImages.degrees,
    ),
  ];

  notificationInitialization() async {
    Future.wait([
      LocalNotificationService.initialize(context),
      FirebaseNotificationService.firebaseMessagingInitialization(context),
    ]);
  }

  @override
  void initState() {
    super.initState();
    notificationInitialization();

    screens = [
      const HomePageView(),
      const ClusterPointsView(),
      const ProfileHomePage(),
      const SocialArticlesView(tabIndex: 0),
      const ExclusiveMediaCommonScreen(
        exclusiveScreenItem: (
          text: 'Virtual Tours',
          image: 'assets/icons/360-degrees.svg',
          apiEndPoint: '/api/v1/sb_virtuals/mobile',
          profile: null,
          isFromHomeScreen: true
        ),
      ),
    ];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isFirstTime) {
      selectedBottomBarItem =
          BottomBarProvider.of(context).selectedBottomBarItem;
    }
    isFirstTime = false;
  }

  bool isPlusMember(BuildContext context) {
    final String? subscriptionLevel =
        (context.read<HomePageCubit>().state as HomePageLoaded)
            .subscriptionLevel;

    return subscriptionLevel?.toLowerCase().contains('plus') == true ||
        subscriptionLevel?.toLowerCase().contains('pro') == true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundColor,
      body: ValueListenableBuilder(
        valueListenable: selectedBottomBarItem,
        builder: (context, value, _) {
          return screens[value];
        },
      ),
      bottomNavigationBar: IntrinsicHeight(
        child: ColoredBox(
          color: AppColors.white,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.paddingOf(context).bottom == 0 ||
                      MediaQuery.paddingOf(context).bottom < 10
                  ? 16
                  : MediaQuery.paddingOf(context).bottom - 10,
              left: 10,
              right: 10,
            ),
            child: Row(
              children: bottomBarItems.indexed
                  .map(
                    (e) => Expanded(
                      child: Material(
                        color: AppColors.white,
                        child: InkWell(
                          onTap: () {
                            if (e.$1 == 0 || e.$1 == 4) {
                              if (Platform.isAndroid) {
                                SystemChrome.setSystemUIOverlayStyle(
                                  const SystemUiOverlayStyle(
                                      statusBarColor: Colors.white,
                                      statusBarIconBrightness: Brightness.dark),
                                );
                              } else {
                                FlutterStatusbarcolor
                                    .setStatusBarWhiteForeground(false);
                                FlutterStatusbarcolor.setStatusBarColor(
                                    Colors.white);
                              }
                            } else {
                              if (Platform.isAndroid) {
                                SystemChrome.setSystemUIOverlayStyle(
                                  SystemUiOverlayStyle(
                                    statusBarColor: Colors.transparent,
                                    statusBarIconBrightness: e.$1 == 1
                                        ? Brightness.dark
                                        : Brightness.light,
                                  ),
                                );
                              } else {
                                FlutterStatusbarcolor
                                    .setStatusBarWhiteForeground(false);
                                FlutterStatusbarcolor.setStatusBarColor(
                                    Colors.transparent);
                              }
                            }
                            selectedBottomBarItem.value = e.$1;
                          },
                          child: ValueListenableBuilder(
                            valueListenable: selectedBottomBarItem,
                            builder: (context, selectedIndex, _) {
                              return AbsorbPointer(
                                child:
                                    BlocBuilder<HomePageCubit, HomePageState>(
                                  builder: (context, state) {
                                    final bool isLoaded =
                                        state is HomePageLoaded;
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: e.$1 == selectedIndex
                                              ? double.infinity
                                              : 0,
                                          height: 3,
                                          child: const ColoredBox(
                                              color: AppColors.blue),
                                        ),
                                        const SpaceVertical(10),
                                        SizedBox(
                                          width: e.$1 == 2 ? 34 : 26,
                                          height: 26,
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: SvgPicture.asset(
                                              (isLoaded &&
                                                      isPlusMember(context) &&
                                                      e.$1 == 2)
                                                  ? AppImages.fishPlus
                                                  : e.$2.image,
                                              width: 26,
                                              height: 26,
                                              colorFilter: (isLoaded &&
                                                      isPlusMember(context) &&
                                                      e.$1 == 2 &&
                                                      selectedIndex == 2)
                                                  ? null
                                                  : ColorFilter.mode(
                                                      e.$1 == selectedIndex
                                                          ? AppColors.blue
                                                          : AppColors
                                                              .bottomBarIconGreyColor,
                                                      BlendMode.srcIn,
                                                    ),
                                            ),
                                          ),
                                        ),
                                        const SpaceVertical(8),
                                        Text(
                                          (isLoaded &&
                                                  isPlusMember(context) &&
                                                  e.$1 == 2)
                                              ? 'My SB+'
                                              : e.$2.title,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  fontWeight:
                                                      e.$1 == selectedIndex
                                                          ? FontWeight.w600
                                                          : FontWeight.w400),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class BottomBarModel {
  String title;
  String image;

  BottomBarModel({
    required this.title,
    required this.image,
  });
}
