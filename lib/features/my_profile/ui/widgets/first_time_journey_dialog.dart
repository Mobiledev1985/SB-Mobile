import 'package:flutter/material.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_images.dart';
import 'package:sb_mobile/core/constant/app_strings.dart';
import 'package:sb_mobile/core/constant/ui_constant.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/widgets/back_button.dart';
import 'package:sb_mobile/core/widgets/space_horizontal.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';

class FirstTimeAgnlerJourneyDialog extends StatefulWidget {
  const FirstTimeAgnlerJourneyDialog({super.key});

  @override
  State<FirstTimeAgnlerJourneyDialog> createState() =>
      _FirstTimeAgnlerJourneyDialogState();
}

class _FirstTimeAgnlerJourneyDialogState
    extends State<FirstTimeAgnlerJourneyDialog> {
  @override
  Widget build(BuildContext context) {
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
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 45,
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
                'NEW! Introducing\nThe Angling Journey',
                textAlign: TextAlign.center,
                style: context.textTheme.displaySmall?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SpaceVertical(14),
              Text(
                'Unlock achievements and become the ultimate angler!',
                textAlign: TextAlign.center,
                style: context.textTheme.headlineSmall?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SpaceVertical(28),
              Text(
                AppStrings.howEarnPoints,
                style: context.textTheme.headlineSmall?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                ),
              ),
              const SpaceVertical(16),
              IntrinsicWidth(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xff1BA76B),
                    border: Border.all(
                      color: AppColors.white,
                    ),
                    borderRadius: BorderRadius.circular(
                      defaultBorderRadius,
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 18.0,
                      vertical: 12,
                    ),
                    child: Column(
                      children: [
                        _EarnPoints(text: AppStrings.bookings, points: '50'),
                        SpaceVertical(8),
                        _EarnPoints(text: AppStrings.catches, points: '50'),
                        SpaceVertical(8),
                        _EarnPoints(text: AppStrings.reviews, points: '50'),
                      ],
                    ),
                  ),
                ),
              ),
              const SpaceVertical(16),
              Text(
                AppStrings.or,
                style: context.textTheme.headlineSmall?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SpaceVertical(12),
              Text(
                AppStrings.unlockAchievements,
                style: context.textTheme.headlineSmall?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SpaceVertical(16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Image.asset(
                        AppImages.teamSB,
                        width: 72,
                        height: 72,
                      ),
                      const SpaceVertical(6),
                      Text(
                        '#TeamSB',
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '100 pts',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                  const Flexible(child: SpaceHorizontal(100)),
                  Column(
                    children: [
                      Image.asset(
                        AppImages.onYourWay,
                        width: 72,
                        height: 72,
                      ),
                      const SpaceVertical(6),
                      Text(
                        'On Your Way',
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '100 pts',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SpaceVertical(16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  'GREAT NEWS! All of your bookings, catches and reviews have been backdated and will count towards your level!',
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SpaceVertical(24),
              Text(
                "${AppStrings.tightlines}!",
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

class _EarnPoints extends StatelessWidget {
  final String text;
  final String points;
  const _EarnPoints({required this.text, required this.points});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text,
          style: context.textTheme.headlineSmall?.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Expanded(child: SpaceHorizontal(64)),
        Text(
          '${points}pts',
          style: context.textTheme.headlineSmall?.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
