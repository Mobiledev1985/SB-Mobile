import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_strings.dart';
import 'package:sb_mobile/core/constant/ui_constant.dart';
import 'package:sb_mobile/core/routes/route_paths.dart';
import 'package:sb_mobile/core/widgets/back_button.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';
import 'package:sb_mobile/features/authentication/data/models/angler_profile_details_model.dart';
import 'package:sb_mobile/features/my_profile/data/models/achivement_model.dart';
import 'package:sb_mobile/features/my_profile/ui/widgets/achievement_detail_dialog.dart';
import 'package:sb_mobile/features/my_profile/ui/widgets/angler_journey_dialog.dart';
import 'package:sb_mobile/features/my_profile/ui/widgets/angler_tiers_dialog.dart';
import 'package:sb_mobile/features/my_profile/ui/widgets/profile_bar.dart';
import 'package:sb_mobile/features/my_profile/ui/widgets/require_fishery_approval_dialog.dart';
import 'package:sb_mobile/features/my_profile/ui/widgets/unlock_achievements_dialog.dart';

typedef ProgressScreenData = ({
  AchievementModel achievementModel,
  AnglerProfile? profile
});

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key, required this.progressScreenData});

  final ProgressScreenData progressScreenData;

  static PageRouteBuilder<dynamic> buildRouter(
      ProgressScreenData progressScreenData) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          ProgressScreen(progressScreenData: progressScreenData),
      settings: const RouteSettings(name: RoutePaths.progressScreen),
      transitionsBuilder: (_, animation, __, child) {
        final tween = Tween<double>(begin: 0.0, end: 1.0).chain(
          CurveTween(curve: Curves.ease), // Replace with your desired curve
        );
        return FadeTransition(
          opacity: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
    );
  }

  static Future<void> navigateTo(
      BuildContext context, ProgressScreenData progressScreenData) async {
    await Navigator.pushNamed(
      context,
      RoutePaths.progressScreen,
      arguments: progressScreenData,
    );
  }

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
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
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Column(
        children: [
          ProfileBar(
            profile: widget.progressScreenData.profile,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 34),
                        child: Hero(
                          tag: 'Progress',
                          child: Material(
                            child: SizedBox(
                              width: double.infinity,
                              child: ColoredBox(
                                color: AppColors.darkBlue,
                                child: ListView(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: [
                                    const SpaceVertical(20),
                                    SizedBox(
                                      height: 80,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        fit: StackFit.expand,
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl: widget
                                                    .progressScreenData
                                                    .achievementModel
                                                    .currentTier
                                                    ?.image ??
                                                '',
                                            fit: BoxFit.scaleDown,
                                          ),
                                          const Positioned(
                                            left: defaultSidePadding,
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: BackButtonWidget(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SpaceVertical(14),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          AppStrings.progress,
                                          textAlign: TextAlign.center,
                                          style: textTheme.bodyLarge?.copyWith(
                                            fontSize: 30,
                                            color: AppColors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        ClipOval(
                                          child: Material(
                                            type: MaterialType.transparency,
                                            child: IconButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      const AgnlerTiersDialog(),
                                                );
                                              },
                                              color: AppColors.white,
                                              icon: const Icon(Icons.info),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SpaceVertical(16),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: SizedBox(
                                        width: 300,
                                        child: Column(
                                          children: [
                                            Builder(builder: (context) {
                                              final int currentPoints = widget
                                                      .progressScreenData
                                                      .achievementModel
                                                      .currentPoints ??
                                                  0;
                                              final int maxPoints = widget
                                                      .progressScreenData
                                                      .achievementModel
                                                      .currentTier!
                                                      .maxPoint ??
                                                  0;

                                              final int minPoints = widget
                                                      .progressScreenData
                                                      .achievementModel
                                                      .currentTier!
                                                      .minPoint ??
                                                  0;
                                              double fillOutPercentage =
                                                  currentPoints - minPoints !=
                                                              0 &&
                                                          maxPoints -
                                                                  minPoints !=
                                                              0
                                                      ? (currentPoints -
                                                              minPoints) /
                                                          (maxPoints -
                                                              minPoints)
                                                      : 0.0;
                                              return ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                                child: LinearProgressIndicator(
                                                  value: fillOutPercentage,
                                                  backgroundColor:
                                                      AppColors.white,
                                                  color: AppColors.green,
                                                  minHeight: 10,
                                                ),
                                              );
                                            }),
                                            const SpaceVertical(6),
                                            Row(
                                              children: [
                                                Text(
                                                  widget
                                                      .progressScreenData
                                                      .achievementModel
                                                      .currentTier!
                                                      .minPoint
                                                      .toString(),
                                                  style: textTheme.bodyMedium
                                                      ?.copyWith(
                                                    color: AppColors.white,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const Spacer(),
                                                Text(
                                                  widget
                                                              .progressScreenData
                                                              .achievementModel
                                                              .currentTier !=
                                                          null
                                                      ? widget
                                                          .progressScreenData
                                                          .achievementModel
                                                          .currentTier!
                                                          .maxPoint
                                                          .toString()
                                                      : '',
                                                  style: textTheme.bodyMedium
                                                      ?.copyWith(
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
                                    Text(
                                      '${widget.progressScreenData.achievementModel.currentTier?.name}',
                                      textAlign: TextAlign.center,
                                      style: textTheme.headlineMedium?.copyWith(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SpaceVertical(6),
                                    Text(
                                      '${AppStrings.level} ${widget.progressScreenData.achievementModel.currentTier?.level}',
                                      textAlign: TextAlign.center,
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SpaceVertical(34),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 17,
                        child: Material(
                          type: MaterialType.transparency,
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    const AgnlerJourneyDialog(),
                              );
                            },
                            customBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Ink(
                              height: 34,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                  color: AppColors.dividerColor,
                                ),
                              ),
                              child: Material(
                                type: MaterialType.transparency,
                                child: Center(
                                  child: Text(
                                    AppStrings.howToProgress,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.darkGreen,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SpaceVertical(8),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: defaultSidePadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.achievements,
                          style: textTheme.bodyLarge?.copyWith(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SpaceVertical(8),
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  const UnloackAchievementsDialog(),
                            );
                          },
                          child: Text(
                            AppStrings.howDoIUnlock,
                            style: textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.blue,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                        const SpaceVertical(24),
                        if (widget.progressScreenData.achievementModel
                                .achievements !=
                            null) ...[
                          ...widget
                              .progressScreenData.achievementModel.achievements!
                              .map(
                                (e) => Visibility(
                                  visible:
                                      e.badges != null && e.badges!.isNotEmpty,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 18.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              e.section ?? '',
                                              style: textTheme.headlineMedium
                                                  ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Visibility(
                                              visible: (e.section != null) &&
                                                  (e.section ==
                                                          'Catch Reports' ||
                                                      e.section == 'Species'),
                                              child: ClipOval(
                                                child: Material(
                                                  type:
                                                      MaterialType.transparency,
                                                  child: IconButton(
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            const RequireFisheryApproval(),
                                                      );
                                                    },
                                                    color: AppColors
                                                        .bottomBarIconGreyColor,
                                                    icon:
                                                        const Icon(Icons.info),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        const SpaceVertical(16),
                                        GridView.builder(
                                          shrinkWrap: true,
                                          itemCount: e.badges?.length,
                                          padding: EdgeInsets.zero,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            mainAxisExtent: 150,
                                          ),
                                          itemBuilder: (context, index) =>
                                              InkWell(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AchievementDetailDialog(
                                                  badges: e.badges![index],
                                                ),
                                              );
                                            },
                                            child: Material(
                                              type: MaterialType.transparency,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Opacity(
                                                    opacity: !e.badges![index]
                                                            .awarded!
                                                        ? 0.45
                                                        : 1,
                                                    child: CachedNetworkImage(
                                                      imageUrl: e.badges?[index]
                                                              .icon ??
                                                          '',
                                                      width: 74,
                                                      height: 74,
                                                    ),
                                                  ),
                                                  const SpaceVertical(16),
                                                  Text(
                                                    e.badges?[index].name ?? '',
                                                    textAlign: TextAlign.center,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: textTheme.bodyLarge
                                                        ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: !e.badges![index]
                                                              .awarded!
                                                          ? AppColors.darkBlue
                                                              .withOpacity(0.45)
                                                          : AppColors.darkBlue,
                                                    ),
                                                  ),
                                                  const SpaceVertical(2),
                                                  Text(
                                                    '${e.badges?[index].points} pts',
                                                    style: textTheme.bodySmall
                                                        ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: !e.badges![index]
                                                              .awarded!
                                                          ? AppColors.darkBlue
                                                              .withOpacity(0.45)
                                                          : AppColors.darkBlue,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ],
                      ],
                    ),
                  ),
                  const SpaceVertical(30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
