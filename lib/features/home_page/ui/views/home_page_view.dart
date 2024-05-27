import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_images.dart';
import 'package:sb_mobile/core/constant/app_strings.dart';
import 'package:sb_mobile/core/constant/ui_constant.dart';
import 'package:sb_mobile/core/utility/styles/app_styles.dart';
import 'package:sb_mobile/core/widgets/alert.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';
import 'package:sb_mobile/features/home_page/cubit/home_page_cubit.dart';
import 'package:sb_mobile/features/home_page/ui/views/catch_report_listing_screen.dart';
import 'package:sb_mobile/features/home_page/ui/widgets/angling_journey.dart';
import 'package:sb_mobile/features/home_page/ui/widgets/angling_social_widget.dart';
import 'package:sb_mobile/features/home_page/ui/widgets/bookable_venues.dart';
import 'package:sb_mobile/features/home_page/ui/widgets/exclusive_media.dart';
import 'package:sb_mobile/features/home_page/ui/widgets/list_header.dart';
import 'package:sb_mobile/features/home_page/ui/widgets/live_catch_reports_widget.dart';
import 'package:sb_mobile/features/home_page/ui/widgets/pb_widget.dart';
import 'package:sb_mobile/features/home_page/ui/widgets/sb_banner.dart';
import 'package:sb_mobile/features/home_page/ui/widgets/submit_catch_report_widget.dart';
import 'package:sb_mobile/features/home_page/ui/widgets/home_app_bar.dart';
import 'package:sb_mobile/features/home_page/ui/widgets/invite_widget.dart';
import 'package:sb_mobile/features/home_page/ui/widgets/map_widget.dart';
import 'package:sb_mobile/features/home_page/ui/widgets/search_widget.dart';
import 'package:sb_mobile/features/home_page/ui/widgets/your_state.dart';
import 'bottom_bar_provider.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  Center get buildCenterLoading =>
      Center(child: CircularProgressIndicator(color: appStyles.sbBlue));

  final AppStyles styles = AppStyles();

  void fetchHomePageWidgets({required BuildContext context}) {
    Future.microtask(() {
      context.read<HomePageCubit>().loadHomePage();
    });
  }

  Future<void> refresh(
      {required BuildContext context, required bool isLoggedIn}) async {
    Future.microtask(() {
      context.read<HomePageCubit>().refresh(isLoggedIn);
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedBottomBarItem =
        BottomBarProvider.of(context).selectedBottomBarItem;
    return BlocConsumer<HomePageCubit, HomePageState>(
      listener: (context, state) {},
      builder: (context, state) {
        switch (state.runtimeType) {
          case HomePageInitial:
            fetchHomePageWidgets(context: context);
            return buildCenterLoading;

          case HomePageLoaded:
            var newState = state as HomePageLoaded;
            return Column(
              children: [
                HomeAppBar(
                  profile: state.profile,
                  isExclusiveMediaScreen: false,
                  isFromBottomBar360: false,
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      refresh(context: context, isLoggedIn: !state.isLoggedIn);
                    },
                    child: Transform(
                      transform: Matrix4.translationValues(0, 0, 0),
                      child: SingleChildScrollView(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        child: Column(
                          children: [
                            SearchWidget(
                              onTap: () {
                                if (Platform.isAndroid) {
                                  SystemChrome.setSystemUIOverlayStyle(
                                    const SystemUiOverlayStyle(
                                        statusBarColor: Colors.transparent,
                                        statusBarIconBrightness:
                                            Brightness.dark),
                                  );
                                } else {
                                  FlutterStatusbarcolor
                                      .setStatusBarWhiteForeground(false);
                                  FlutterStatusbarcolor.setStatusBarColor(
                                      Colors.transparent);
                                }
                                selectedBottomBarItem.value = 1;
                              },
                            ),
                            if (state.isLoggedIn) ...[
                              YourState(
                                anglerProfile: state.profile,
                                userStatistics: state.userStatistics,
                              ),
                              const SpaceVertical(6),
                              if (state.userStatistics?.catchReport !=
                                  null) ...[
                                PBWidget(
                                  userStatistics: state.userStatistics,
                                ),
                                const SpaceVertical(6),
                              ],
                            ],
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(defaultBorderRadius),
                              ),
                              child: Column(
                                children: [
                                  const SpaceVertical(10),
                                  ExclusiveMedia(
                                    exclusiveList:
                                        newState.homeModel.exclusive!,
                                    profile: newState.profile,
                                  ),
                                  const SpaceVertical(15),
                                  SbBanner(
                                    profile: newState.profile,
                                    isFromProfile: false,
                                  ),
                                  BookableVenuesWidget(
                                    bookableVenues:
                                        newState.homeModel.bookableVenues ?? [],
                                    isLoggedIn: newState.isLoggedIn,
                                  ),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: MapWidget(
                                      selectedBottomBarItem:
                                          selectedBottomBarItem,
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 10.0),
                                    child: Divider(
                                      indent: 124,
                                      endIndent: 124,
                                      thickness: 1,
                                      height: 0,
                                      color: AppColors.dividerColor,
                                    ),
                                  ),
                                  ListHeader(
                                    icon: AppImages.dateIcon,
                                    title: AppStrings.liveCatchReports,
                                    trailing: 'View all',
                                    onPressed: () {
                                      CatchReportListingScreen.navigateTo(
                                        context,
                                      );
                                    },
                                  ),
                                  CatchReportListView(
                                    catchReports:
                                        newState.homeModel.liveCatchReport ??
                                            [],
                                    isFromHomeScreen: true,
                                  ),
                                  SubmitCatchReportWidget(
                                    isLoggedInUser: newState.isLoggedIn,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 16.0),
                                    child: Divider(
                                      indent: 124,
                                      endIndent: 124,
                                      thickness: 1,
                                      height: 0,
                                      color: AppColors.dividerColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AnglingSocialWidget(
                              articles: newState.homeModel.articles ?? [],
                            ),
                            AgnlingJourney(
                              isLoggendIn: state.isLoggedIn &&
                                  state.achievementModel != null,
                              achievementModel: state.achievementModel,
                              profile: state.profile,
                            ),
                            const SpaceVertical(6),
                            const InviteWidget(),
                            const SpaceVertical(6),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );

          default:
            return buildCenterLoading;
        }
      },
    );
  }
}
