import 'package:flutter/material.dart';

import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_strings.dart';
import 'package:sb_mobile/core/constant/ui_constant.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/widgets/back_button.dart';
import 'package:sb_mobile/core/widgets/space_horizontal.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';

class TierSection {
  final String tierName;
  final List<Tier> tier;
  TierSection({
    required this.tierName,
    required this.tier,
  });
}

class Tier {
  final String name;
  final int level;
  Tier({
    required this.name,
    required this.level,
  });
}

class AgnlerTiersDialog extends StatelessWidget {
  const AgnlerTiersDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final List<TierSection> tierItems = [
      TierSection(
        tierName: 'Basic Tiers',
        tier: [
          Tier(name: 'Bivvy Beginner', level: 1),
          Tier(name: 'Angling Amateur', level: 2),
          Tier(name: 'Rod Rookie', level: 3),
          Tier(name: 'Casting Cadet', level: 4),
          Tier(name: 'Open Water Officer', level: 5),
        ],
      ),
      TierSection(
        tierName: 'Intermediate Tiers',
        tier: [
          Tier(name: 'Casting Corporal', level: 6),
          Tier(name: 'Swim Sniper', level: 7),
          Tier(name: 'Outdoors Specialist', level: 8),
          Tier(name: 'Session Smasher', level: 9),
          Tier(name: 'Watercraft Warrior', level: 10),
          Tier(name: 'Swivel Sergeant', level: 11),
          Tier(name: 'Casting Captain', level: 12),
          Tier(name: 'Margin Major', level: 13),
          Tier(name: 'Baiting Brigadier', level: 14),
          Tier(name: 'Marine Master', level: 15),
        ],
      ),
      TierSection(
        tierName: 'Expert Tiers',
        tier: [
          Tier(name: 'Lieutenant Land’Em', level: 16),
          Tier(name: 'Ground-Bait General', level: 17),
          Tier(name: 'Lake Legend', level: 18),
          Tier(name: 'Mainline Marshal', level: 19),
          Tier(name: 'Angling Admiral', level: 20),
        ],
      ),
    ];
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(defaultBorderRadius),
        side: const BorderSide(
          color: AppColors.dividerGreyColor,
          width: 1,
        ),
      ),
      backgroundColor: AppColors.dialogBlue,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 46,
                child: Stack(
                  alignment: Alignment.center,
                  fit: StackFit.expand,
                  children: [
                    const Positioned(
                      left: 0,
                      // top: 0,
                      child: BackButtonWidget(isCloseIcon: true),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Image.asset(
                        'assets/icons/fish.png',
                        width: 45,
                        height: 30,
                      ),
                    ),
                  ],
                ),
              ),
              const SpaceVertical(10),
              Text(
                AppStrings.anglerTiers,
                textAlign: TextAlign.center,
                style: context.textTheme.displaySmall?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SpaceVertical(14),
              Text(
                AppStrings.gainpoints,
                textAlign: TextAlign.center,
                style: context.textTheme.headlineSmall?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SpaceVertical(24),
              ...tierItems
                  .map(
                    (e) => Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RotatedBox(
                              quarterTurns: 3,
                              child: Text(
                                e.tierName,
                                style:
                                    context.textTheme.headlineMedium?.copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SpaceHorizontal(40),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: e.tier
                                    .map(
                                      (element) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 6.0),
                                        child: Row(
                                          children: [
                                            // SvgPicture.asset(
                                            //   AppImages.progress,
                                            //   width: 45,
                                            //   height: 48,
                                            // ),
                                            const SpaceHorizontal(16),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  element.name,
                                                  style: context
                                                      .textTheme.bodyLarge
                                                      ?.copyWith(
                                                          color:
                                                              AppColors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                                const SpaceVertical(4),
                                                Text(
                                                  '${AppStrings.level} ${element.level}',
                                                  style: context
                                                      .textTheme.bodySmall
                                                      ?.copyWith(
                                                    color: AppColors.white,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList())
                          ],
                        ),
                        Visibility(
                          visible: e.tierName != 'Expert Tiers',
                          child: const Divider(
                            color: AppColors.white,
                            thickness: 3,
                            height: 45,
                            indent: 40,
                            endIndent: 40,
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
              const SpaceVertical(10),
              Text(
                AppStrings.tightlines,
                style: context.textTheme.headlineMedium?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SpaceVertical(10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(defaultBorderRadius),
                  ),
                ),
                child: Text(
                  'Back',
                  style: context.textTheme.headlineMedium?.copyWith(
                    color: AppColors.blue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
