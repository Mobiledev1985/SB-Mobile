import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:jovial_svg/jovial_svg.dart';
import 'package:sb_mobile/core/config/authenticator.dart';
import 'package:sb_mobile/core/config/server_config.dart';
import 'package:sb_mobile/core/config/user_model.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_images.dart';
import 'package:sb_mobile/core/widgets/alert.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';
import 'package:sb_mobile/features/authentication/cubit/auth_helper_cubit.dart';
import 'package:sb_mobile/features/authentication/ui/views/login_screen.dart';
import 'package:sb_mobile/features/bookings/ui/widgets/booking_webview.dart';
import 'package:sb_mobile/features/fishery_profile/cubit/fishery_profile_cubit.dart';
import 'package:sb_mobile/features/fishery_profile/view/widgets.dart/fishery_profile_write_review.dart';
import 'package:sb_mobile/features/fishery_profile/view/widgets.dart/fishery_rating.dart';
import 'package:sb_mobile/features/fishery_profile/view/widgets.dart/fullscreen_slider.dart';
import 'package:sb_mobile/features/fishery_profile/view/widgets.dart/lake_slider.dart';
import 'package:sb_mobile/features/fishery_profile/view/widgets.dart/sb_back_button.dart';
import 'package:sb_mobile/features/fishery_property_details/data/models/fishery_details.dart';
import 'package:sb_mobile/features/fishery_property_details/ui/views/how_to_book_webview.dart';
import 'package:sb_mobile/features/fishery_property_details/ui/views/livewebview.dart';
import 'package:sb_mobile/features/fishery_property_details/ui/views/media_webview.dart';
import 'package:sb_mobile/features/fishery_property_details/ui/widgets/base_headline.dart';
import 'package:sb_mobile/features/fishery_property_details/ui/widgets/fishery_contact_details.dart';
import 'package:sb_mobile/features/fishery_property_details/ui/widgets/fishery_comments.dart';
import 'package:sb_mobile/features/fishery_property_details/ui/widgets/fishery_location_map.dart';
import 'package:sb_mobile/features/fishery_property_details/ui/widgets/fishery_show_all_comments.dart';
import 'package:sb_mobile/features/fishery_property_details/ui/widgets/how_to_book.dart';
import 'package:sb_mobile/features/fishery_property_details/ui/widgets/location_overview_page.dart';
import 'package:sb_mobile/features/fishery_property_details/ui/widgets/location_rules_page.dart';
import 'package:sb_mobile/features/fishery_property_details/ui/widgets/location_site_map.dart';
import 'package:sb_mobile/features/home_page/ui/widgets/live_catch_reports_widget.dart';
import 'package:sb_mobile/features/search/data/models/selected_item_model.dart';
import 'package:sb_mobile/features/submit_catch_report/ui/views/submit_catch_report_screen.dart';
import 'package:url_launcher/url_launcher.dart';

typedef FisheryQuickFactsAndFacilities = ({
  List<SelectableItemModel> quickFacts,
  List<SelectableItemModel> facilities
});

class FisheryProfilePage extends StatelessWidget {
  const FisheryProfilePage(
      {Key? key,
      required this.id,
      required this.publicId,
      this.fisheryQuickFactsAndFacilities})
      : super(key: key);

  final String id;
  final int publicId;

  final FisheryQuickFactsAndFacilities? fisheryQuickFactsAndFacilities;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FisheryProfileCubit>(
      create: (_) {
        context.read<AuthHelperCubit>().fetchAuthStatus();
        return FisheryProfileCubit(
            publicId: publicId,
            fisheryQuickFactsAndFacilities: fisheryQuickFactsAndFacilities)
          ..fetchFishery();
      },
      child: _FisheryView(
        publicId: publicId,
        fisheryQuickFactsAndFacilities: fisheryQuickFactsAndFacilities,
      ),
    );
  }
}

class _FisheryView extends StatefulWidget {
  final int publicId;

  final FisheryQuickFactsAndFacilities? fisheryQuickFactsAndFacilities;

  const _FisheryView({
    Key? key,
    required this.publicId,
    required this.fisheryQuickFactsAndFacilities,
  }) : super(key: key);

  @override
  State<_FisheryView> createState() => _FisheryViewState();
}

class _FisheryViewState extends State<_FisheryView> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      );
    } else {
      FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
      FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    }
  }

  @override
  void dispose() {
    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark),
      );
    } else {
      FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final CarouselController controller = CarouselController();
    // QuickFactsIconMapping quickFactsMapping = QuickFactsIconMapping();
    // FacilitiesIconMapping facilitiesIconMapping = FacilitiesIconMapping();
    final authState = context.watch<AuthHelperCubit>().state.status;

    // final navState = context.watch<NavBarCubit>().state.hideNavBar;
    TextStyle h1 = TextStyle(
      fontFamily: appStyles.fontGilroy,
      color: appStyles.sbBlue,
      fontSize: 20,
      wordSpacing: 2.0,
      fontWeight: FontWeight.w500,
    );

    TextStyle h2 = TextStyle(
        fontFamily: appStyles.fontGilroy,
        color: appStyles.sbBlue,
        fontSize: 20,
        wordSpacing: 2.0,
        fontWeight: FontWeight.w500,
        height: 2);

    TextStyle para = TextStyle(
        fontFamily: appStyles.fontGilroy,
        color: Colors.black,
        fontSize: 16,
        wordSpacing: 3.0,
        height: 2.0);

    return BlocBuilder<FisheryProfileCubit, FisheryProfileState>(
        builder: (context, state) {
      // print(context.read<AuthHelperCubit>().state.status);
      if (state.status == FisheryProfileStatus.success) {
        // querySelector(selectors)
        final fishery = state.fishery!;
        return Scaffold(
          backgroundColor: const Color(0xffFAFAFA),
          body: Stack(
            alignment: Alignment.center,
            children: [
              ListView(
                padding: EdgeInsets.zero,
                children: [
                  Stack(
                    children: [
                      FisheryProfileImageSlider(
                        images: state.allImages,
                        // controller: _controller,
                      ),
                      const SbBackButton(),
                      authState == AuthHelperStatus.authenticated
                          ? SbFavoriteButton(fishery: fishery, state: state)
                          : const SizedBox()
                    ],
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                  FisheryPropertyMetaData(fishery: fishery),
                  const SpaceVertical(20),
                  fishery.isBookable
                      ? _WebViewLink(
                          icon: AppImages.liveAvailibility,
                          title: 'Live Availability',
                          onTap: () async =>
                              await navigateToLiveAvailabilityWebView(
                                  context,
                                  fishery.publicId.toString(),
                                  fishery.venueName),
                        )
                      : const SizedBox(),
                  fishery.rules.isNotEmpty
                      ? _WebViewLink(
                          icon: AppImages.venueRules,
                          title: 'Venue Rules',
                          onTap: () async => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LocationRulesPage(
                                text: fishery.rules,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  fishery.isBookable
                      ? _WebViewLink(
                          icon: AppImages.howToBook,
                          title: 'How To Book',
                          onTap: () {
                            HowToBook.navigateTo(context, fishery.publicId);
                          },
                          // onTap: () => navigateToHowToBookWebView(
                          //     context, fishery.publicId),
                        )
                      : const SizedBox(),
                  fishery.isBookable
                      ? _WebViewLink(
                          icon: AppImages.locationSiteMap,
                          title: 'Location Site Map',
                          onTap: () {
                            LocationSiteMap.navigateTo(
                                context, fishery.images.sitemap);
                          },
                          // onTap: () => navigateToSiteMapWebView(
                          //   context,
                          //   fishery.publicId,
                          // ),
                        )
                      : const SizedBox(),
                  _WebViewLink(
                    icon: AppImages.localWeather,
                    title: 'Local Weather',
                    onTap: () => navigateToLocalWeatherWebView(
                        context, fishery.publicId),
                  ),
                  const Divider(),
                  fishery.quickFacts.isNotEmpty
                      ? Padding(
                          padding: EdgeInsets.only(
                              top: 20.0.h,
                              bottom: 20.h,
                              left: 20.w,
                              right: 10.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const _Headline(
                                    title: 'Quick Facts',
                                    bottomPadding: 20,
                                  ),
                                  !fishery.isBookable
                                      ? Padding(
                                          padding: EdgeInsets.only(
                                              left: 20.w, bottom: 20.0.h),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: appStyles.sbGreen,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(5.r),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20.0.w,
                                                  vertical: 4.h),
                                              child: Text(
                                                'Directory',
                                                style: TextStyle(
                                                    color: appStyles.sbWhite,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12.sp),
                                              ),
                                            ),
                                          ),
                                        )
                                      : const SizedBox()
                                ],
                              ),
                              GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 20.h,
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 14.w,
                                  childAspectRatio: 175.w / 42.h,
                                ),
                                itemCount: state.fisheryQuickFactsAndFacilities
                                    .quickFacts.length,
                                itemBuilder: (context, index) {
                                  final quickFact = state
                                      .fisheryQuickFactsAndFacilities
                                      .quickFacts[index];
                                  return Row(
                                    children: [
                                      Container(
                                        height: 50.h,
                                        width: 50.w,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 6.w,
                                          vertical: 6.h,
                                        ),
                                        child: FittedBox(
                                          fit: BoxFit.cover,
                                          child:
                                              ScalableImageWidget.fromSISource(
                                            si: ScalableImageSource
                                                .fromSvgHttpUrl(
                                              Uri.parse(quickFact.icon ?? ''),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10.w),
                                      Expanded(
                                        child: Text(
                                          quickFact.title,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              )
                            ],
                          ),
                        )
                      : const SizedBox(),
                  fishery.lakes.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.0.w, vertical: 8.h),
                              child: _Headline(
                                title: 'What Can I Book?',
                                bottomPadding: 0.h,
                              ),
                            ),

                            Builder(
                              builder: (context) {
                                if (fishery.venueName ==
                                    'Exotic Fishing Thailand') {
                                  fishery.lakes.removeWhere(
                                    (element) =>
                                        element.name == 'The Fishing Lake' ||
                                        element.name == 'Suite Management',
                                  );
                                }
                                return LakeSlider(fishery: fishery);
                              },
                            )
                            // _LakeSiderItem(appStyles: appStyles),
                          ],
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 22,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 22,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Headline(
                          title: 'Location Overview',
                          bottomPadding: 10.h,
                        ),
                        MarkdownBody(
                          data: fishery.overview.length > 450
                              ? '${fishery.overview.substring(0, 450)}...'
                              : fishery.overview,
                          onTapLink: (text, href, title) {
                            // ignore: deprecated_member_use
                            href != null ? launch(href) : null;
                          },
                          styleSheet:
                              MarkdownStyleSheet.fromTheme(Theme.of(context))
                                  .copyWith(
                            p: para,
                            textAlign: WrapAlignment.start,
                            h1Align: WrapAlignment.start,
                            h1: h1,
                            h2: h2,
                          ),
                        ),
                        const SizedBox(height: 30),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LocationOverviewPage(
                                  text: fishery.overview,
                                ),
                              ),
                            );
                          },
                          child: const Row(
                            children: [
                              Text(
                                'Read more',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                              Icon(
                                Icons.chevron_right,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        // fishery.rules.isNotEmpty
                        //     ? GestureDetector(
                        //         onTap: () {
                        //           Navigator.push(
                        //             context,
                        //             MaterialPageRoute(
                        //               builder: (context) => LocationRulesPage(
                        //                 text: fishery.rules,
                        //               ),
                        //             ),
                        //           );
                        //         },
                        //         child: const Row(
                        //           children: [
                        //             Text(
                        //               'Check location rules',
                        //               style: TextStyle(
                        //                   fontSize: 15,
                        //                   fontWeight: FontWeight.w600),
                        //             ),
                        //             Icon(
                        //               Icons.chevron_right,
                        //               size: 18,
                        //             ),
                        //           ],
                        //         ),
                        //       )
                        //     : const SizedBox(),
                        fishery.rules.isNotEmpty
                            ? const SizedBox(height: 20)
                            : const SizedBox(),
                        const Divider(),
                        const SizedBox(height: 20),
                        if (fishery.sbMedia.virtualExperience.isNotEmpty ||
                            fishery.sbMedia.sbFlythrough.isNotEmpty ||
                            fishery.sbMedia.sbDiaries.isNotEmpty ||
                            fishery.lakes.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Headline(title: 'SB Media'),
                              const SizedBox(height: 20),
                              fishery.lakes.isNotEmpty
                                  ? _Swimview(
                                      fishery: fishery,
                                    )
                                  : const SizedBox(),
                              fishery.sbMedia.virtualExperience.isNotEmpty
                                  ? const SizedBox(height: 50)
                                  : const SizedBox(),
                              fishery.sbMedia.virtualExperience.isNotEmpty
                                  ? _VirtualExperience(fishery: fishery)
                                  : const SizedBox(),
                              fishery.sbMedia.sbFlythrough.isNotEmpty
                                  ? const SizedBox(height: 50)
                                  : const SizedBox(),
                              fishery.sbMedia.sbFlythrough.isNotEmpty
                                  ? _SbFlythrough(
                                      fishery: fishery,
                                    )
                                  : const SizedBox(),
                              fishery.sbMedia.sbDiaries.isNotEmpty
                                  ? const SizedBox(height: 50)
                                  : const SizedBox(),
                              fishery.sbMedia.sbDiaries.isNotEmpty
                                  ? _SbDiaries(fishery: fishery)
                                  : const SizedBox(),
                            ],
                          ),
                      ],
                    ),
                  ),
                  const Divider(),
                  const SpaceVertical(20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                    child: const Headline(title: 'Verified Catch Reports'),
                  ),
                  Visibility(
                    visible: state.catchReports.isNotEmpty,
                    child: CatchReportListView(
                      catchReports: state.catchReports,
                      isFromHomeScreen: false,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.sizeOf(context).width * 0.15,
                        vertical: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        if (context.read<AuthHelperCubit>().state.status ==
                            AuthHelperStatus.authenticated) {
                          SubmitCatchReportScreen.navigateTo(context);
                        } else {
                          showAlert('Please login to Submit Catch Report');
                        }
                      },
                      child: const Text("+ Submit Catch Report"),
                    ),
                  ),
                  if (fishery.sbMedia.virtualExperience.isNotEmpty ||
                      fishery.sbMedia.sbFlythrough.isNotEmpty ||
                      fishery.sbMedia.sbDiaries.isNotEmpty ||
                      fishery.lakes.isNotEmpty)
                    if (fishery.sbMedia.virtualExperience.isNotEmpty ||
                        fishery.sbMedia.sbFlythrough.isNotEmpty ||
                        fishery.sbMedia.sbDiaries.isNotEmpty ||
                        fishery.lakes.isNotEmpty)
                      const Divider(),
                  SizedBox(height: 20.h),
                  fishery.facilities.isNotEmpty
                      ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Headline(title: 'Facilities'),
                              GridView.builder(
                                padding: EdgeInsets.zero,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 20.h,
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 14.w,
                                  childAspectRatio: 175.w / 42.h,
                                ),
                                itemCount: state.fisheryQuickFactsAndFacilities
                                    .facilities.length,
                                itemBuilder: (context, index) {
                                  final facility = state
                                      .fisheryQuickFactsAndFacilities
                                      .facilities[index];
                                  return Row(
                                    children: [
                                      Container(
                                        height: 50.h,
                                        width: 50.w,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 6.w,
                                          vertical: 6.h,
                                        ),
                                        child: FittedBox(
                                            fit: BoxFit.cover,
                                            child: ScalableImageWidget
                                                .fromSISource(
                                              si: ScalableImageSource
                                                  .fromSvgHttpUrl(
                                                Uri.parse(facility.icon ?? ''),
                                              ),
                                            )),
                                      ),
                                      SizedBox(width: 10.w),
                                      Expanded(
                                        child: Text(
                                          facility.title,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              )
                            ],
                          ),
                        )
                      : const SizedBox(),
                  fishery.facilities.isNotEmpty
                      ? SizedBox(height: 20.h)
                      : const SizedBox(),
                  fishery.facilities.isNotEmpty
                      ? const Divider()
                      : const SizedBox(),
                  fishery.facilities.isNotEmpty
                      ? SizedBox(height: 20.h)
                      : const SizedBox(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Headline(title: 'General Details'),
                        FisheryLocationMap(fishery: fishery),
                        SizedBox(
                          height: 20.h,
                        ),
                        FisheryContactDetails(fishery: fishery),
                        SizedBox(height: 20.h),
                        const Divider(),
                        SizedBox(height: 20.h),
                        const Headline(title: 'Reviews'),
                        Column(
                          children: [
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FisheryRatings(fishery: fishery).build(context),
                                SizedBox(width: 8.w),
                                Text(
                                  "${fishery.rating.score}/5",
                                  style: TextStyle(
                                    fontSize: 16.0.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    fontFamily: appStyles.fontGilroy,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  "${fishery.comments.length} reviews",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                    color: appStyles.sbBlue,
                                    fontFamily: appStyles.fontGilroy,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // FisheryRatingWidget(fishery: fishery),
                        fishery.comments.isNotEmpty
                            ? FisheryComments(fishery: fishery)
                            : SizedBox(height: 16.h),
                        SizedBox(
                          height: 16.h,
                        ),
                        GestureDetector(
                          onTap: () {
                            // PropertyDetailsCubit cubit =
                            //     context.read<PropertyDetailsCubit>();
                            final FisheryProfileCubit cubit =
                                context.read<FisheryProfileCubit>();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return FisheryProfileWriteReview(
                                  cubit: cubit,
                                  fishery: fishery,
                                );
                              }),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: appStyles.sbGreen,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 15.0),
                              child: Center(
                                child: Text(
                                  'Leave a review',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: appStyles.sbWhite),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FisheryAllComments(
                                  fishery: fishery,
                                ),
                              ),
                            );
                          },
                          child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: appStyles.sbBlue,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.r),
                                ),
                              ),
                              child: fishery.comments.isNotEmpty
                                  ? Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 15.0.h),
                                      child: Center(
                                        child: Text(
                                          'Show all reviews',
                                          style: TextStyle(
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.w600,
                                              color: appStyles.sbWhite),
                                        ),
                                      ),
                                    )
                                  : const SizedBox()),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 180.h,
                  ),
                ],
              ),
              authState == AuthHelperStatus.notAuthenticated
                  ? NotAuthenticatedDisplay(
                      publicId: widget.publicId,
                    )
                  : fishery.isBookable
                      ? BookNowDisplay(fishery: fishery)
                      // ? BookNowButton(fishery: fishery)
                      : ClaimFisheryDisplay(fishery: fishery)
              // : ClaimFisheryButton(fishery: fishery)
            ],
          ),
        );
      } else if (state.status == FisheryProfileStatus.failure) {
        return Scaffold(
          body: RefreshIndicator(
            onRefresh: () async {},
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    foregroundColor: appStyles.sbWhite,
                    backgroundColor: appStyles.sbBlue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    textStyle:
                        const TextStyle(color: Colors.black, fontSize: 15)),
                child: const AutoSizeText(
                  "Error Fetching Profile, Tap to try again !",
                  maxLines: 1,
                ),
                onPressed: () {
                  context.read<FisheryProfileCubit>().fetchFishery();
                  // reload(context: context, publicId: publicId);
                },
              ),
            ),
          ),
        );
      } else {
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(
              color: appStyles.sbBlue,
            ),
          ),
        );
      }
    });
  }
}

class FisheryProfileImageSlider extends StatefulWidget {
  const FisheryProfileImageSlider({
    Key? key,
    required this.images,
  }) : super(key: key);

  final List<String> images;

  @override
  State<FisheryProfileImageSlider> createState() =>
      _FisheryProfileImageSliderState();
}

class _FisheryProfileImageSliderState extends State<FisheryProfileImageSlider> {
  final CarouselController _controller = CarouselController();
  final int _current = 0;
  // void _openFullScreenImage(BuildContext context, NetworkImage imageUrl) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => FullScreenImage(imageUrl: imageUrl),
  //     ),
  //   );
  // }

  late final FisheryProfileCubit cubit;
  @override
  void initState() {
    cubit = context.read<FisheryProfileCubit>();
    super.initState();
  }

  void openFullScreenSlider(BuildContext context) {
    final FisheryProfileCubit c = context.read<FisheryProfileCubit>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: c,
          child: FullScreenSlider(
            prevPageController: _controller,
            index: _current,
            images: widget.images,
            // controller: _controller,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FisheryProfileCubit, FisheryProfileState>(
      builder: (context, state) => Stack(
        alignment: Alignment.center,
        children: [
          GestureDetector(
            onTap: () =>
                // _openFullScreenImage(context, widget.images[state.sliderIndex]),
                openFullScreenSlider(context),
            child: SizedBox(
              width: double.infinity,
              height: 280.h,
              child: CarouselSlider(
                items: widget.images
                    .map(
                      (e) => CachedNetworkImage(
                        imageUrl: e,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorWidget: (context, _, __) {
                          // Show a default image asset if the network image fails to load
                          return Center(
                            child: Column(
                              children: [
                                SizedBox(
                                  // color: Colors.white,
                                  height: 280.h,
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    )
                    .toList(),
                carouselController: _controller,
                options: CarouselOptions(
                    onPageChanged: (index, reason) {
                      context
                          .read<FisheryProfileCubit>()
                          .updateSliderIndex(index);
                      // setState(() {
                      //   _current = index;
                      // });
                    },
                    viewportFraction: 1,
                    enlargeCenterPage: false,
                    enableInfiniteScroll: false,
                    aspectRatio: 2 / 3),
              ),
            ),
          ),
          Positioned(
            bottom: 11.h,
            right: 11.w,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.7),
                  borderRadius: BorderRadius.all(Radius.circular(4.r))),
              child: Row(
                children: [
                  Text(
                    '${state.sliderIndex + 1} / ${widget.images.length}',
                    // '${state.sliderIndex + 1} / ${widget.images.length}',
                    style: TextStyle(
                        fontFamily: appStyles.fontGilroy,
                        color: appStyles.sbWhite,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SbFavoriteButton extends StatelessWidget {
  const SbFavoriteButton({
    Key? key,
    required this.fishery,
    required this.state,
  }) : super(key: key);
  final FisheryPropertyDetails fishery;
  final FisheryProfileState state;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        right: 16,
        top: 38,
        child: GestureDetector(
          onTap: () async {
            await context.read<FisheryProfileCubit>().setFav(!state.isFavorite);
          },
          child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: appStyles.sbWhite, shape: BoxShape.circle),
              child: state.isFavorite
                  ? const Icon(Icons.favorite, color: Colors.red)
                  : const Icon(Icons.favorite_outline)),
        ));
  }
}

class _Headline extends StatelessWidget {
  const _Headline({
    Key? key,
    required this.title,
    required this.bottomPadding,
  }) : super(key: key);

  final double bottomPadding;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 28.0,
          fontWeight: FontWeight.w600,
          fontFamily: appStyles.fontGilroy,
        ),
      ),
    );
  }
}

class _WebViewLink extends StatelessWidget {
  const _WebViewLink({
    Key? key,
    required this.title,
    required this.icon,
    // required this.color,
    required this.onTap,
  }) : super(key: key);

  final String title;
  final String icon;
  // final Color color;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 22.0,
          vertical: 3,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 14.0,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: const Color(0xffFFFFFF),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              width: 24,
            ),
            const SizedBox(width: 22),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xff1F5B8C),
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.chevron_right,
              size: 28,
              color: Colors.black,
            )
          ],
        ),
      ),
    );
  }
}

// class _RectangularIcon extends StatelessWidget {
//   const _RectangularIcon({
//     Key? key,
//     required this.icon,
//   }) : super(key: key);

//   final IconData icon;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: appStyles.sbBlue,
//         borderRadius: const BorderRadius.all(
//           Radius.circular(10),
//         ),
//       ),
//       child: Icon(
//         icon,
//         color: Colors.white,
//       ),
//     );
//   }
// }

class FisheryPropertyMetaData extends StatelessWidget {
  const FisheryPropertyMetaData({Key? key, required this.fishery})
      : super(key: key);

  final FisheryPropertyDetails fishery;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fishery.venueName,
            style: TextStyle(
              fontSize: 24.0,
              color: AppColors.darkTextColor,
              fontWeight: FontWeight.w600,
              fontFamily: appStyles.fontGilroy,
            ),
          ),
          SizedBox(
            height: 5.0.h,
          ),
          Text(
            "${fishery.address.city}, ${fishery.address.postcode}",
            style: TextStyle(
              fontSize: 16.0,
              color: const Color(0xff45494D),
              fontWeight: FontWeight.w500,
              fontFamily: appStyles.fontGilroy,
            ),
          ),
          const SpaceVertical(18),
          Text(
            "${fishery.rating.totalReviews} Ratings | ${fishery.comments.length} Reviews",
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              color: const Color(0xff737A80),
              fontFamily: appStyles.fontGilroy,
            ),
          ),
          // Row(
          //   // mainAxisAlignment: MainAxisAlignment.,
          //   children: [

          //     //FisheryRatings(fishery: fishery).build(context),
          //     Text(
          //       "${fishery.rating.totalReviews} reviews",
          //       style: TextStyle(
          //         fontSize: 16.0.sp,
          //         fontWeight: FontWeight.w600,
          //         color: Colors.black,
          //         fontFamily: appStyles.fontGilroy,
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}

class ClaimFisheryButton extends StatelessWidget {
  const ClaimFisheryButton({Key? key, required this.fishery}) : super(key: key);

  final FisheryPropertyDetails fishery;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 30.h,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CustomWebView(
                subUrl: '',
                fisheryId: fishery.publicId.toString(),
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 9.0),
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0XFF676767),
              borderRadius: BorderRadius.all(
                Radius.circular(40),
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 22.0, vertical: 15),
              child: Text(
                'Claim Fishery',
                style: TextStyle(
                    color: appStyles.sbWhite,
                    fontWeight: FontWeight.w600,
                    fontSize: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BookNowButton extends StatelessWidget {
  const BookNowButton({Key? key, required this.fishery}) : super(key: key);

  final FisheryPropertyDetails fishery;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 30.h,
      child: GestureDetector(
        onTap: () {
          navigateToBookingWebView(
              context, fishery.publicId.toString(), fishery.venueName);
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 9.0),
          child: Container(
            decoration: BoxDecoration(
              color: appStyles.sbGreen,
              borderRadius: const BorderRadius.all(
                Radius.circular(40),
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 22.0, vertical: 15),
              child: Text(
                'sdBook Now',
                style: TextStyle(
                    color: appStyles.sbWhite,
                    fontWeight: FontWeight.w600,
                    fontSize: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ClaimFisheryDisplay extends StatelessWidget {
  const ClaimFisheryDisplay({
    Key? key,
    required this.fishery,
  }) : super(key: key);

  final FisheryPropertyDetails fishery;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0.h,
      child: Column(
        children: [
          Container(
            height: 1,
            color: appStyles.sbGrey,
            width: MediaQuery.of(context).size.width,
          ),
          Container(
            height: 100.h,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomWebView(
                    subUrl: '',
                    fisheryId: fishery.publicId.toString(),
                  ),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: 24.0.w,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Own this fishery?',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        const Text(
                          'Get in touch with us!',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        right: 24.0.r,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0XFF676767),
                          borderRadius: BorderRadius.all(
                            Radius.circular(30.r),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 25.0.w,
                            vertical: 15.h,
                          ),
                          child: Text(
                            'Claim Fishery',
                            style: TextStyle(
                                color: appStyles.sbWhite,
                                fontWeight: FontWeight.w600,
                                fontSize: 18.sp),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BookNowDisplay extends StatelessWidget {
  const BookNowDisplay({
    Key? key,
    required this.fishery,
  }) : super(key: key);

  final FisheryPropertyDetails fishery;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0.h,
      child: Column(
        children: [
          Container(
            height: 1,
            color: appStyles.sbGrey,
            width: MediaQuery.of(context).size.width,
          ),
          Container(
            height: 100.h,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: GestureDetector(
              onTap: () {
                navigateToBookingWebView(
                    context, fishery.publicId.toString(), fishery.venueName);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 22.0.w,
                  vertical: 22.h,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: appStyles.sbGreen,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.r),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Book Now',
                      style: TextStyle(
                          color: appStyles.sbWhite,
                          fontWeight: FontWeight.w600,
                          fontSize: 21.sp),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NotAuthenticatedDisplay extends StatelessWidget {
  final int publicId;
  const NotAuthenticatedDisplay({
    Key? key,
    required this.publicId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0.h,
      child: Column(
        children: [
          Container(
            height: 1,
            color: appStyles.sbGrey,
            width: MediaQuery.of(context).size.width,
          ),
          Container(
              height: 100.h,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: GestureDetector(
                onTap: () {
                  // Navigator.of(context).pushNamed('/angler/login');
                  // pageController.jumpToTab(4);
                },
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 24.0.w,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Want to book this fishery?',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Text.rich(
                            TextSpan(
                              text: 'Sign in or ',
                              style: const TextStyle(fontSize: 16),
                              children: [
                                TextSpan(
                                  text: 'create an account',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Colors.blue),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      LoginScreen.navigateTo(context, true);
                                      // Navigator.of(context).pushNamed(
                                      //     '/angler/signup',
                                      //     arguments: false);
                                    },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          right: 24.0.r,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed('/angler/login', arguments: true)
                                .then((value) {
                              if (value != null) {
                                context
                                    .read<AuthHelperCubit>()
                                    .fetchAuthStatus();
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: appStyles.sbBlue,
                              borderRadius: BorderRadius.all(
                                Radius.circular(30.r),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 25.0.w,
                                vertical: 13.h,
                              ),
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                  color: appStyles.sbWhite,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18.sp,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

void navigateToSiteMapWebView(BuildContext context, int fisheryId) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CustomWebView(
        subUrl: 'sitemap',
        fisheryId: fisheryId.toString(),
      ),
    ),
  );
}

void navigateToSwimViewWebView(BuildContext context, int fisheryId) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CustomWebView(
        subUrl: 'swimview',
        fisheryId: fisheryId.toString(),
      ),
    ),
  );
}

void navigateToLocalWeatherWebView(BuildContext context, int fisheryId) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CustomWebView(
        subUrl: 'weather',
        fisheryId: fisheryId.toString(),
      ),
    ),
  );
}

void navigateToHowToBookWebView(BuildContext context, int fisheryId) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CustomWebView(
        subUrl: 'how-to-book',
        fisheryId: fisheryId.toString(),
      ),
    ),
  );
}

Future<void> navigateToLiveAvailabilityWebView(
    BuildContext context, String fisheryId, String fisheryName) async {
  final authBox = await Hive.openBox<UserCredentials>(authBoxName);
  UserCredentials? credentials = authBox.get(authBoxKey);

  // Encryption encryption = Encryption();

  if (credentials != null) {
    // String userNamePass = '${credentials.email}:${credentials.password}';

    // String userNamePassEnc = encryption.encryptData(userNamePass);

    var formData = FormData.fromMap({
      'username': credentials.email,
      'password': credentials.password,
      'is_mobile': true,
    });

    final api = ApiServerConfig();
    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    final Dio sbDio = Dio();
    sbDio.options.headers = headers;
    String url = "${api.baseUrl}${api.loginUrl}";
    Response response = await sbDio.post(url, data: formData);

    // var encodeemail = Uri.encodeComponent(userNamePassEnc);
    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => LiveAvailabilityWebview(
                fisheryId: fisheryId,
                fisheryName: fisheryName,
                token: response.data['token'],
              )),
    );
  } else {
    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CustomWebView(
                fisheryId: fisheryId,
                subUrl: 'live-availability',
                name: fisheryName,
              )),
    );
  }
}

Future<void> navigateToBookingWebView(
    BuildContext context, String fisheryId, String fisheryName) async {
  final authBox = await Hive.openBox<UserCredentials>(authBoxName);
  UserCredentials? credentials = authBox.get(authBoxKey);

  // Encryption encryption = Encryption();

  // String userNamePass = '${credentials!.email}:${credentials.password}';

  // String userNamePassEnc = encryption.encryptData(userNamePass);

  final api = ApiServerConfig();
  Map<String, String> headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
  };

  var formData = FormData.fromMap({
    'username': credentials!.email,
    'password': credentials.password,
    'is_mobile': true,
  });

  final Dio sbDio = Dio();
  sbDio.options.headers = headers;
  String url = "${api.baseUrl}${api.loginUrl}";
  Response response = await sbDio.post(url, data: formData);

  // ignore: use_build_context_synchronously
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => BookingWebView(
        token: response.data['token'],
        fisheryId: fisheryId,
        fisheryName: fisheryName,
      ),
    ),
  );
}

class _Swimview extends StatelessWidget {
  const _Swimview({
    Key? key,
    required this.fishery,
  }) : super(key: key);

  final FisheryPropertyDetails fishery;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: fishery.venueName == 'Exotic Fishing Thailand'
                    ? 'room'
                    : 'swim',
                style: TextStyle(
                  fontFamily: appStyles.fontGilroy,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),
              TextSpan(
                text: 'view',
                style: TextStyle(
                  fontFamily: appStyles.fontGilroy,
                  color: appStyles.sbBlue,
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                ),
              ),
              TextSpan(
                text: '™',
                style: TextStyle(
                  fontFamily: appStyles.fontGilroy,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        const Padding(
          padding: EdgeInsets.only(right: 8.0),
          child: Text(
            'Plan your trip ahead. Take a look at every swim on the complex via our SwimView™ gallery.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 25),
        GestureDetector(
          onTap: () {
            navigateToSwimViewWebView(context, fishery.publicId);
          },
          child: const Row(
            children: [
              Text(
                'Check it out here',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
              Icon(
                Icons.chevron_right,
                size: 18,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _VirtualExperience extends StatelessWidget {
  const _VirtualExperience({
    Key? key,
    required this.fishery,
  }) : super(key: key);
  final FisheryPropertyDetails fishery;
  @override
  Widget build(BuildContext context) {
    // print(fishery.sbMedia.virtualExperience);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Virtual Experience',
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: appStyles.sbGreen),
        ),
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.only(right: 8.0),
          child: Text(
            'Step inside our industry first Virtual Tour. Walk around and get a sense for what the venue has to offer.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 25),
        GestureDetector(
          onTap: () {
            navigateToVirtualExperienceWebView(context,
                url: fishery.sbMedia.virtualExperience);
            // navigateToSwimViewWebView(fishery.publicId);
          },
          child: const Row(
            children: [
              Text(
                'Check it out here',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
              Icon(
                Icons.chevron_right,
                size: 18,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

void navigateToVirtualExperienceWebView(
  BuildContext context, {
  required String url,
}) {
  // context.read<NavBarCubit>().setHideNavBar(true);
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => MediaWebView(
        url: url,
      ),
    ),
  );
}

void navigateToMediaWebView(
  BuildContext context, {
  required int fisheryId,
  required String url,
}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CustomWebView(
        subUrl: 'swimview',
        fisheryId: fisheryId.toString(),
      ),
    ),
  );
}

class _SbFlythrough extends StatelessWidget {
  const _SbFlythrough({
    Key? key,
    required this.fishery,
  }) : super(key: key);
  final FisheryPropertyDetails fishery;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SB Flythrough',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 8,
        ),
        const Padding(
          padding: EdgeInsets.only(right: 8.0),
          child: Text(
            'A brand new vantage point giving you the opportunity to see your favourite venues from the skies!',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 25),
        GestureDetector(
          onTap: () {
            // navigateToSwimViewWebView(fishery.publicId);
            _launchUrl(fishery.sbMedia.sbFlythrough);
          },
          child: const Row(
            children: [
              Text(
                'Check it out here',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
              Icon(
                Icons.chevron_right,
                size: 18,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SbDiaries extends StatelessWidget {
  const _SbDiaries({
    Key? key,
    required this.fishery,
  }) : super(key: key);
  final FisheryPropertyDetails fishery;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SB Diaries',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 8,
        ),
        const Padding(
          padding: EdgeInsets.only(right: 8.0),
          child: Text(
            'A video series dedicated to showing anglers all about a fishery; including facts and facilities.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 25),
        GestureDetector(
          onTap: () {
            _launchUrl(fishery.sbMedia.sbDiaries);
          },
          child: const Row(
            children: [
              Text(
                'Check it out here',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
              Icon(
                Icons.chevron_right,
                size: 18,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Future<void> _launchUrl(String url) async {
  if (!url.startsWith('http://') && !url.startsWith('https://')) {
    url = 'http://$url';
  }
  final Uri uri = Uri.parse(url);
  try {
    if (await launchUrl(uri)) {
    } else {
      throw Exception('Could not launch $url');
    }
  } catch (e) {
    // print('Error launching URL: $e');
  }
}
