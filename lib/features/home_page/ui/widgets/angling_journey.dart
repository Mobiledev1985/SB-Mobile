import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sb_mobile/core/config/authenticator.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_images.dart';
import 'package:sb_mobile/core/constant/app_strings.dart';
import 'package:sb_mobile/core/constant/ui_constant.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/widgets/space_horizontal.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';
import 'package:sb_mobile/features/authentication/data/models/angler_profile_details_model.dart';
import 'package:sb_mobile/features/home_page/ui/views/bottom_bar_provider.dart';
import 'package:sb_mobile/features/my_profile/data/models/achivement_model.dart';
import 'package:sb_mobile/features/my_profile/ui/view/progress_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AgnlingJourney extends StatefulWidget {
  const AgnlingJourney({
    super.key,
    required this.isLoggendIn,
    required this.achievementModel,
    required this.profile,
  });

  final bool isLoggendIn;

  final AchievementModel? achievementModel;

  final AnglerProfile? profile;

  @override
  State<AgnlingJourney> createState() => _AgnlingJourneyState();
}

class _AgnlingJourneyState extends State<AgnlingJourney> {
  late SharedPreferences? preferences;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              ColoredBox(
                color: AppColors.blue,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SpaceVertical(16),
                    if (widget.isLoggendIn) ...[
                      Text(
                        '${AppStrings.level} ${widget.achievementModel?.currentTier?.level}',
                        textAlign: TextAlign.center,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SpaceVertical(6),
                      CachedNetworkImage(
                        imageUrl:
                            '${widget.achievementModel?.currentTier?.image}',
                        width: 70,
                        height: 70,
                        fit: BoxFit.contain,
                      ),
                      const SpaceVertical(8),
                      Text(
                        '${widget.achievementModel?.currentTier?.name}',
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ] else ...[
                      SvgPicture.asset(
                        AppImages.progress,
                        width: 46,
                        height: 46,
                      ),
                      const SpaceVertical(6),
                      Text(
                        'Login to track your\nangling progress!',
                        style: context.textTheme.headlineSmall?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w900,
                          fontFamily: mfontFamily,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SpaceVertical(8),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: SizedBox(
                        width: 300,
                        child: Column(
                          children: [
                            Builder(
                              builder: (context) {
                                final int currentPoints =
                                    widget.achievementModel?.currentPoints ?? 0;
                                final int maxPoints = widget.achievementModel
                                        ?.currentTier!.maxPoint ??
                                    0;

                                final int minPoints = widget.achievementModel
                                        ?.currentTier!.minPoint ??
                                    0;
                                double fillOutPercentage =
                                    currentPoints - minPoints != 0 &&
                                            maxPoints - minPoints != 0
                                        ? (currentPoints - minPoints) /
                                            (maxPoints - minPoints)
                                        : 0.0;

                                return ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  child: LinearProgressIndicator(
                                    value: widget.isLoggendIn
                                        ? fillOutPercentage
                                        : 0.0,
                                    backgroundColor: AppColors.white,
                                    color: AppColors.green,
                                    minHeight: 10,
                                  ),
                                );
                              },
                            ),
                            const SpaceVertical(6),
                            Row(
                              children: [
                                Text(
                                  widget.isLoggendIn
                                      ? '${widget.achievementModel?.currentTier?.minPoint}'
                                      : '0',
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  widget.isLoggendIn
                                      ? '${widget.achievementModel?.currentTier?.maxPoint}'
                                      : '1100',
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SpaceVertical(20),
                  ],
                ),
              ),
              Positioned(
                top: 20,
                right: 20,
                child: FutureBuilder<SharedPreferences>(
                  future: SharedPreferences.getInstance(),
                  builder: (context, sp) {
                    preferences = sp.data;

                    return Visibility(
                      visible: sp.hasData &&
                          (preferences?.getBool(isFirstHomeScreen) ?? true),
                      child: Transform.rotate(
                        angle: 3.14 / 20.0,
                        child: Card(
                          color: const Color(0xffD95757),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            child: Text(
                              'NEW!',
                              style: context.textTheme.displaySmall?.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
          ColoredBox(
            color: const Color(0xff0D3759),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 22.0, vertical: 4),
              child: Row(
                children: [
                  Text(
                    'My Angling Journey',
                    style: context.textTheme.headlineSmall?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      if (widget.isLoggendIn) {
                        ProgressScreen.navigateTo(
                          context,
                          (
                            achievementModel: widget.achievementModel!,
                            profile: widget.profile
                          ),
                        ).then((value) {
                          if (Platform.isAndroid) {
                            SystemChrome.setSystemUIOverlayStyle(
                              const SystemUiOverlayStyle(
                                statusBarColor: Colors.white,
                                statusBarIconBrightness: Brightness.dark,
                              ),
                            );
                          } else {
                            FlutterStatusbarcolor.setStatusBarWhiteForeground(
                              false,
                            );
                            FlutterStatusbarcolor.setStatusBarColor(
                              Colors.white,
                            );
                          }
                        });
                      } else {
                        BottomBarProvider.of(context)
                            .selectedBottomBarItem
                            .value = 2;
                      }
                    },
                    child: Row(
                      children: [
                        Text(
                          widget.isLoggendIn ? 'View progress' : 'Login',
                          style: context.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w400,
                            color: AppColors.white,
                          ),
                        ),
                        const SpaceHorizontal(6),
                        SvgPicture.asset(
                          AppImages.rightArrow,
                          width: 20,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    preferences?.setBool(isFirstHomeScreen, false);
    super.dispose();
  }
}
