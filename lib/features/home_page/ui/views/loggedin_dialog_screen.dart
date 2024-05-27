import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:flutter_svg/svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sb_mobile/core/config/authenticator.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_images.dart';
import 'package:sb_mobile/core/constant/app_strings.dart';
import 'package:sb_mobile/core/constant/ui_constant.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';
import 'package:sb_mobile/features/authentication/data/models/angler_profile_details_model.dart';
import 'package:sb_mobile/features/home_page/cubit/home_page_cubit.dart';
import 'package:sb_mobile/features/home_page/ui/views/bottom_bar_provider.dart';
import 'package:sb_mobile/features/home_page/ui/views/notification_list_screen.dart';
import 'package:sb_mobile/features/home_page/ui/widgets/common_bar.dart';
import 'package:sb_mobile/features/home_page/ui/widgets/dialog_item.dart';
import 'package:sb_mobile/features/home_page/ui/widgets/logout_confirmation_dialog.dart';
import 'package:sb_mobile/features/my_profile/ui/view/bookings_screen.dart';
import 'package:sb_mobile/features/my_profile/ui/view/catches_screen.dart';
import 'package:sb_mobile/features/my_profile/ui/view/favorite_screen.dart';
import 'package:sb_mobile/features/submit_catch_report/ui/views/submit_catch_report_screen.dart';

class LoggedDialogScreen extends StatefulWidget {
  final double topPadding;
  final AnglerProfile anglerProfile;
  final bool isExclusiveMediaScreen;
  final bool isFromBottomBar360;
  const LoggedDialogScreen({
    super.key,
    required this.topPadding,
    required this.anglerProfile,
    required this.isExclusiveMediaScreen,
    required this.isFromBottomBar360,
  });

  @override
  State<LoggedDialogScreen> createState() => _LoggedDialogScreenState();
}

class _LoggedDialogScreenState extends State<LoggedDialogScreen> {
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  @override
  void dispose() {
    super.dispose();
    isLoading.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedBottomBarIndex =
        BottomBarProvider.of(context).selectedBottomBarItem;
    final textTheme = Theme.of(context).textTheme;
    return Transform(
      transform: Matrix4.translationValues(
          0, Platform.isIOS ? -widget.topPadding : 0, 0),
      child: Dialog(
        alignment: Alignment.topLeft,
        insetPadding: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(defaultBorderRadius),
            bottomRight: Radius.circular(defaultBorderRadius),
          ),
        ),
        child: IntrinsicHeight(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (Platform.isIOS) SpaceVertical(widget.topPadding),
                CommonBar(
                  topPadding: 0,
                  isFromDialog: true,
                  anglerProfile: widget.anglerProfile,
                  isExclusiveMediaScreen: widget.isExclusiveMediaScreen,
                  isFromBottomBar360: widget.isFromBottomBar360,
                ),
                const Divider(
                  height: 0,
                  color: Color(0xffEFEFEF),
                ),
                const SpaceVertical(14),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hi ${widget.anglerProfile.firstName}',
                        style: textTheme.displayMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SpaceVertical(5),
                      Text(
                        AppStrings.welcomeBack,
                        style: textTheme.bodyLarge
                            ?.copyWith(fontWeight: FontWeight.w400),
                      ),
                      const SpaceVertical(24),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DialogItem(
                            icon: AppImages.searchIcon,
                            text: AppStrings.findFisheries,
                            onTap: () {
                              if (Platform.isAndroid) {
                                SystemChrome.setSystemUIOverlayStyle(
                                  const SystemUiOverlayStyle(
                                      statusBarColor: Colors.transparent,
                                      statusBarIconBrightness: Brightness.dark),
                                );
                              } else {
                                FlutterStatusbarcolor
                                    .setStatusBarWhiteForeground(false);
                                FlutterStatusbarcolor.setStatusBarColor(
                                    Colors.transparent);
                              }
                              Navigator.pop(context);

                              if (!widget.isFromBottomBar360 &&
                                  widget.isExclusiveMediaScreen) {
                                Navigator.pop(context);
                              }
                              selectedBottomBarIndex.value = 1;
                            },
                          ),
                          DialogItem(
                            icon: AppImages.dateIcon,
                            text: AppStrings.myBooking,
                            onTap: () {
                              BookingsScreen.navigateTo(
                                  context, widget.anglerProfile);
                            },
                          ),
                          DialogItem(
                            icon: AppImages.addIcon,
                            text: AppStrings.addCatchReport,
                            onTap: () {
                              SubmitCatchReportScreen.navigateTo(context);
                            },
                          ),
                          DialogItem(
                            icon: AppImages.fish,
                            text: 'My SB',
                            onTap: () {
                              Navigator.pop(context);
                              if (!widget.isFromBottomBar360 &&
                                  widget.isExclusiveMediaScreen) {
                                Navigator.pop(context);
                              }
                              selectedBottomBarIndex.value = 2;
                            },
                          ),
                        ],
                      ),
                      const SpaceVertical(20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DialogItem(
                            icon: AppImages.favouriteIcon,
                            text: AppStrings.favourites,
                            onTap: () {
                              FavoriteScreen.navigateTo(
                                  context, widget.anglerProfile);
                            },
                          ),
                          DialogItem(
                            icon: AppImages.captureIcon,
                            text: 'My Catches',
                            onTap: () {
                              CatchesScreen.navigateTo(
                                  context, widget.anglerProfile);
                            },
                          ),
                          DialogItem(
                            icon: AppImages.socialIcon,
                            text: AppStrings.anglingSocial,
                            onTap: () {
                              Navigator.pop(context);
                              if (!widget.isFromBottomBar360 &&
                                  widget.isExclusiveMediaScreen) {
                                Navigator.pop(context);
                              }
                              selectedBottomBarIndex.value = 3;
                            },
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      NotificationListScreen.navigateTo(context)
                                          .then(
                                        (value) async {
                                          await Future.delayed(
                                            Durations.short1,
                                          );
                                          if (Platform.isAndroid) {
                                            SystemChrome
                                                .setSystemUIOverlayStyle(
                                              const SystemUiOverlayStyle(
                                                statusBarIconBrightness:
                                                    Brightness.dark,
                                                statusBarColor: Colors.white,
                                              ),
                                            );
                                          } else {
                                            FlutterStatusbarcolor
                                                .setStatusBarWhiteForeground(
                                                    false);
                                            FlutterStatusbarcolor
                                                .setStatusBarColor(
                                                    Colors.white);
                                          }
                                        },
                                      );
                                    },
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        color: AppColors.blue,
                                        borderRadius: BorderRadius.circular(
                                            defaultButtonRadius),
                                      ),
                                      height: 66,
                                      width: 80,
                                      child: Stack(
                                        children: [
                                          Center(
                                            child: SvgPicture.asset(
                                              AppImages.notificationIcon,
                                              height: 46,
                                              width: 46,
                                              fit: BoxFit.contain,
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                AppColors.white,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 8,
                                            right: 8,
                                            child: BlocBuilder<HomePageCubit,
                                                HomePageState>(
                                              builder: (context, state) {
                                                return Visibility(
                                                  visible: (state
                                                          is HomePageLoaded) &&
                                                      context
                                                          .read<HomePageCubit>()
                                                          .getNotification(
                                                              false)
                                                          .isNotEmpty,
                                                  child: CircleAvatar(
                                                    radius: 10,
                                                    backgroundColor:
                                                        const Color(0xffD95757),
                                                    child: Text(
                                                      context
                                                          .read<HomePageCubit>()
                                                          .getNotification(
                                                              false)
                                                          .length
                                                          .toString(),
                                                      style: context
                                                          .textTheme.bodyMedium
                                                          ?.copyWith(
                                                        color: AppColors.white,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SpaceVertical(4),
                                  Text(
                                    'Notifications',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SpaceVertical(20),
                      ValueListenableBuilder(
                        valueListenable: isLoading,
                        builder: (context, loading, _) {
                          return loading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.blue,
                                  ),
                                )
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.red),
                                  onPressed: () async {
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          LogoutConfirmationDialog(
                                        onTap: () {
                                          deleteAuthBox();
                                          isLoading.value = true;
                                          context
                                              .read<HomePageCubit>()
                                              .logout()
                                              .then(
                                            (isLogout) {
                                              isLoading.value = false;
                                              if (isLogout) {
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                                context
                                                    .read<HomePageCubit>()
                                                    .refresh(true);
                                              }
                                            },
                                          ).catchError(
                                            (error) {
                                              isLoading.value = false;
                                            },
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  child: const Text(AppStrings.logOut),
                                );
                        },
                      ),
                      const SpaceVertical(8),
                      FutureBuilder(
                        future: PackageInfo.fromPlatform(),
                        builder: (context, sp) {
                          return Center(
                            child: Text(
                              'Version : ${sp.data?.version}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          );
                        },
                      ),
                      const SpaceVertical(8),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
