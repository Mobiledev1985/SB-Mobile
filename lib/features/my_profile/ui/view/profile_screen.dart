import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:sb_mobile/core/config/authenticator.dart';
import 'package:sb_mobile/core/config/user_model.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_images.dart';
import 'package:sb_mobile/core/constant/app_strings.dart';
import 'package:sb_mobile/core/constant/ui_constant.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/widgets/space_horizontal.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';
import 'package:sb_mobile/features/home_page/cubit/home_page_cubit.dart';
import 'package:sb_mobile/features/home_page/ui/views/bottom_bar_provider.dart';
import 'package:sb_mobile/features/home_page/ui/views/bottom_bar_screen.dart';
import 'package:sb_mobile/features/home_page/ui/widgets/logout_confirmation_dialog.dart';
import 'package:sb_mobile/features/home_page/ui/widgets/sb_banner.dart';
import 'package:sb_mobile/features/home_page/ui/widgets/sb_promo_banner.dart';
import 'package:sb_mobile/features/my_profile/cubit/my_profile_cubit.dart';
import 'package:sb_mobile/features/my_profile/ui/view/bookings_screen.dart';
import 'package:sb_mobile/features/my_profile/ui/view/catches_screen.dart';
import 'package:sb_mobile/features/my_profile/ui/view/favorite_screen.dart';
import 'package:sb_mobile/features/my_profile/ui/view/in_session_wev_view.dart';
import 'package:sb_mobile/features/my_profile/ui/view/my_details_screen.dart';
import 'package:sb_mobile/features/my_profile/ui/view/my_memberships_screen.dart';
import 'package:sb_mobile/features/my_profile/ui/view/progress_screen.dart';
import 'package:sb_mobile/features/my_profile/ui/view/statistics_screen.dart';
import 'package:sb_mobile/features/my_profile/ui/widgets/card_item.dart';
import 'package:sb_mobile/features/my_profile/ui/widgets/first_time_journey_dialog.dart';
import 'package:sb_mobile/features/my_profile/ui/widgets/make_booking_order_dialog.dart';
import 'package:sb_mobile/features/my_profile/ui/widgets/profile_widget.dart';
import 'package:sb_mobile/features/my_profile/ui/widgets/states_widget.dart';
import 'package:sb_mobile/features/my_profile/ui/widgets/sbplus/wallet/money_widget.dart';
import 'package:sb_mobile/features/my_profile/ui/widgets/sbplus/wallet/sb_plus_section.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ScrollController scrollController = ScrollController();
  final ValueNotifier<bool> isLoadingLogout = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300)).then(
      (value) {
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
      },
    );

    context.read<MyProfileCubit>().fetchAnglerProfile(true).then((value) async {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      final bool isFirstTime =
          preferences.getBool(isFirstAnglerJourney) ?? true;
      if (isFirstTime) {
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) => const FirstTimeAgnlerJourneyDialog(),
        ).then(
          (value) {
            preferences.setBool(isFirstAnglerJourney, false);
          },
        );
      }
    });
  }

  @override
  void dispose() {
    isLoadingLogout.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<MyProfileCubit, MyProfileState>(
      builder: (context, state) {
        if (state is MyProfileLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.blue,
            ),
          );
        } else if (state is MyProfileFailed) {
          return const Center(
            child: Text("Server Failed to respond, try again later."),
          );
        } else if (state is MyProfileLoaded) {
          return Stack(
            textDirection: TextDirection.ltr,
            children: [
              BackgroundImage(
                backgroundImage: state.backgroundImage,
              ),
              SingleChildScrollView(
                controller: scrollController,
                padding: EdgeInsets.zero,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: context.width * 0.90,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SpaceVertical(MediaQuery.paddingOf(context).top + 8),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: state.isInSessionButtonVisible
                                  ? () async {
                                      try {
                                        final authBox =
                                            await Hive.openBox<UserCredentials>(
                                                authBoxName);
                                        UserCredentials? credentials =
                                            authBox.get(authBoxKey);
                                        // ignore: use_build_context_synchronously
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => InSessionWebView(
                                              token: credentials!.token,
                                            ),
                                          ),
                                        );
                                      } catch (e) {
                                        //
                                      }
                                    }
                                  : () {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (_) => state.isPlusMember
                                            ? const MakeBookingOrderDialog()
                                            : SBPromoBanner(
                                                isFromInSession: true,
                                                email:
                                                    state.profile?.email ?? '',
                                              ),
                                      );
                                      // showAlert(
                                      //     "You don't have any upcoming sessions!, Make a booking to get started!");
                                    },
                              child: Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18.0,
                                    vertical: 5,
                                  ),
                                  child: Opacity(
                                    opacity: state.isInSessionButtonVisible
                                        ? 1
                                        : 0.25,
                                    child: RichText(
                                      text: TextSpan(
                                        text: 'In',
                                        style: context.textTheme.bodyLarge
                                            ?.copyWith(
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w900,
                                          color: AppColors.blue,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: 'Session',
                                            style: context.textTheme.bodyLarge
                                                ?.copyWith(
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w900,
                                              color: AppColors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            Visibility(
                              visible: state.isPlusMember,
                              child: Hero(
                                tag: 'coin',
                                child: Material(
                                  type: MaterialType.transparency,
                                  child: CoinWidget(
                                    value: state.profile != null
                                        ? state.profile!.walletAmount
                                        : 0.00,
                                    fontSize: 16,
                                    profile: state.profile,
                                    isFromWallet: null,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Material(
                          type: MaterialType.transparency,
                          child: SingleChildScrollView(
                            primary: false,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: ProfileWidget(profile: state.profile!),
                                ),
                                const SpaceVertical(24),
                                Text(
                                  AppStrings.welcome,
                                  textAlign: TextAlign.center,
                                  style: textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.white,
                                    shadows: [
                                      const BoxShadow(
                                        offset: Offset(0, 1.5),
                                        blurRadius: 9,
                                        color: AppColors.textBoxShadowColor,
                                      )
                                    ],
                                  ),
                                ),
                                const SpaceVertical(4),
                                Hero(
                                  tag: 'Name',
                                  child: Material(
                                    color: Colors.transparent,
                                    child: Text(
                                      '${state.profile?.firstName} ${state.profile?.lastName}',
                                      textAlign: TextAlign.center,
                                      style: textTheme.displayLarge?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.white,
                                        fontSize: 32,
                                        shadows: [
                                          const BoxShadow(
                                            offset: Offset(0, 1.5),
                                            blurRadius: 9,
                                            color: AppColors.textBoxShadowColor,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SpaceVertical(18),
                              ],
                            ),
                          ),
                        ),
                        Text(
                          AppStrings.yourStats,
                          style: textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                            shadows: [
                              const BoxShadow(
                                offset: Offset(0, 1.5),
                                blurRadius: 9,
                                color: AppColors.textBoxShadowColor,
                              )
                            ],
                          ),
                        ),
                        const Hero(
                          tag: 'stats',
                          child: SingleChildScrollView(
                            child: Material(
                              type: MaterialType.transparency,
                              child: StatesWidget(),
                            ),
                          ),
                        ),
                        const SpaceVertical(8),
                        if (state.isPlusMember)
                          SBPlusSection(profile: state.profile)
                        else
                          SbBanner(
                            profile: state.profile,
                            isFromProfile: true,
                          ),
                        const SpaceVertical(8),
                        Card(
                          color: AppColors.white.withOpacity(0.50),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(defaultBorderRadius),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 14),
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 24,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: AppColors.blue,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: const Color(0xffDDDDDD),
                                    ),
                                  ),
                                  child: Text(
                                    'swimbooker',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.white,
                                        ),
                                  ),
                                ),
                                const SpaceVertical(8),
                                Hero(
                                  tag: 'Progress',
                                  child: IntrinsicHeight(
                                    child: Card(
                                      elevation: 5,
                                      color: AppColors.darkBlue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: InkWell(
                                        onTap: () => ProgressScreen.navigateTo(
                                          context,
                                          (
                                            achievementModel:
                                                state.achievementModel!,
                                            profile: state.profile
                                          ),
                                        ),
                                        customBorder: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SvgPicture.asset(
                                                      AppImages.progress,
                                                      width: 50,
                                                      height: 50,
                                                    ),
                                                    const SpaceVertical(6),
                                                    Flexible(
                                                      child: Text(
                                                        AppStrings.progress,
                                                        style: textTheme
                                                            .headlineMedium
                                                            ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              AppColors.white,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      '${AppStrings.level} ${state.achievementModel?.currentTier?.level}',
                                                      style: textTheme
                                                          .headlineMedium
                                                          ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: AppColors.white,
                                                      ),
                                                    ),
                                                    const SpaceVertical(6),
                                                    Text(
                                                      '${state.achievementModel?.currentTier?.name}',
                                                      style: textTheme
                                                          .bodyMedium
                                                          ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: AppColors.white,
                                                      ),
                                                    ),
                                                    // Text(
                                                    //   'Coming Soon',
                                                    //   style: textTheme
                                                    //       .headlineMedium
                                                    //       ?.copyWith(
                                                    //     fontWeight: FontWeight.bold,
                                                    //     color: AppColors.white,
                                                    //   ),
                                                    // ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: SizedBox(
                                    height: 104,
                                    child: Row(
                                      children: [
                                        CardItem(
                                          imagePath: AppImages.catches,
                                          title: AppStrings.catches,
                                          onTap: () {
                                            scrollController.jumpTo(0);
                                            CatchesScreen.navigateTo(
                                                context, state.profile);
                                          },
                                        ),
                                        const SpaceHorizontal(4),
                                        CardItem(
                                          imagePath: AppImages.statistics,
                                          title: AppStrings.statistics,
                                          onTap: () {
                                            scrollController.jumpTo(0);
                                            StatisticsScreen.navigateTo(
                                                context, state.userStatistics!);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 104,
                                  child: Card(
                                    elevation: 5,
                                    color: AppColors.darkBlue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        scrollController.jumpTo(0);
                                        MyDetailsScreen.navigateTo(context, (
                                          profile: state.profile!,
                                          onSave: () {
                                            setState(() {});
                                          }
                                        ));
                                      },
                                      customBorder: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            AppImages.myDetails,
                                            width: 46,
                                            height: 46,
                                          ),
                                          const SpaceHorizontal(30),
                                          Text(
                                            AppStrings.myDetails,
                                            style: textTheme.displayLarge
                                                ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: SizedBox(
                                    height: 104,
                                    child: Row(
                                      children: [
                                        CardItem(
                                          imagePath: AppImages.bookings,
                                          title: AppStrings.bookings,
                                          onTap: () {
                                            scrollController.jumpTo(0);
                                            BookingsScreen.navigateTo(
                                              context,
                                              state.profile,
                                            );
                                          },
                                        ),
                                        const SpaceHorizontal(4),
                                        CardItem(
                                          imagePath: AppImages.favourite,
                                          title: AppStrings.favourites,
                                          onTap: () {
                                            scrollController.jumpTo(0);
                                            FavoriteScreen.navigateTo(
                                                context, state.profile);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 104,
                                  child: Card(
                                    elevation: 5,
                                    color: AppColors.darkBlue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        scrollController.jumpTo(0);
                                        MyMembershipsScreen.navigateTo(
                                          context,
                                          state.profile,
                                        );
                                      },
                                      customBorder: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            AppImages.myMemberships,
                                            width: 64,
                                            height: 64,
                                          ),
                                          const SpaceHorizontal(30),
                                          Text(
                                            AppStrings.myMembership,
                                            textAlign: TextAlign.center,
                                            style: textTheme.displayLarge
                                                ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SpaceVertical(8),
                                ValueListenableBuilder(
                                  valueListenable: isLoadingLogout,
                                  builder: (context, loading, _) {
                                    return ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.red),
                                      onPressed: () async {
                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              LogoutConfirmationDialog(
                                            isLoading: loading,
                                            onTap: () {
                                              deleteAuthBox();
                                              isLoadingLogout.value = true;
                                              context
                                                  .read<HomePageCubit>()
                                                  .logout()
                                                  .then(
                                                (isLogout) {
                                                  if (isLogout) {
                                                    Navigator.pop(context);
                                                    BottomBarProvider.of(
                                                            context)
                                                        .selectedBottomBarItem
                                                        .value = 0;

                                                    Navigator
                                                        .pushAndRemoveUntil(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const BottomBarScreen(),
                                                      ),
                                                      (route) => false,
                                                    );

                                                    Future.microtask(
                                                      () {
                                                        context
                                                            .read<
                                                                HomePageCubit>()
                                                            .loadHomePage(true);
                                                      },
                                                    );
                                                    if (Platform.isAndroid) {
                                                      SystemChrome
                                                          .setSystemUIOverlayStyle(
                                                        const SystemUiOverlayStyle(
                                                            statusBarColor:
                                                                Colors.white,
                                                            statusBarIconBrightness:
                                                                Brightness
                                                                    .dark),
                                                      );
                                                    } else {
                                                      FlutterStatusbarcolor
                                                          .setStatusBarWhiteForeground(
                                                              false);
                                                      FlutterStatusbarcolor
                                                          .setStatusBarColor(
                                                              Colors.white);
                                                    }
                                                    isLoadingLogout.value =
                                                        false;
                                                  }
                                                },
                                              ).catchError(
                                                (error) {
                                                  isLoadingLogout.value = false;
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
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

class BackgroundImage extends StatelessWidget {
  final String? backgroundImage;
  const BackgroundImage({super.key, this.backgroundImage});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'Background',
      child: Material(
        child: Builder(
          builder: (context) {
            if (backgroundImage != null && backgroundImage!.isNotEmpty) {
              return Image.network(
                backgroundImage!.replaceAll('https', 'http'),
                key: ValueKey(backgroundImage),
                width: double.infinity,
                height: 372 + MediaQuery.paddingOf(context).top,
                fit: BoxFit.cover,
                errorBuilder: (context, url, error) => Image.asset(
                  'assets/images/bg_gradiated.jpg',
                  width: double.infinity,
                  height: 372 + MediaQuery.paddingOf(context).top,
                  fit: BoxFit.cover,
                ),
              );
            } else {
              return Image.asset(
                'assets/images/bg_gradiated.jpg',
                width: double.infinity,
                height: 372 + MediaQuery.paddingOf(context).top,
                fit: BoxFit.cover,
              );
            }
          },
        ),
      ),
    );
  }
}
