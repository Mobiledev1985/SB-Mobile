import 'package:flutter/material.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_images.dart';
import 'package:sb_mobile/core/constant/app_strings.dart';
import 'package:sb_mobile/core/constant/ui_constant.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/widgets/back_button.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';

class UnloackAchievementsDialog extends StatelessWidget {
  const UnloackAchievementsDialog({super.key});

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
                AppStrings.howToUnlock,
                textAlign: TextAlign.center,
                style: context.textTheme.displaySmall?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SpaceVertical(14),
              Text(
                AppStrings.unlockAchievementsBy,
                textAlign: TextAlign.center,
                style: context.textTheme.headlineSmall?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SpaceVertical(28),
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
              const SpaceVertical(16),
              Text(
                AppStrings.make,
                textAlign: TextAlign.center,
                style: context.textTheme.headlineSmall?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SpaceVertical(30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text.rich(
                  TextSpan(
                    text: AppStrings.tips,
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: ' ${AppStrings.clickOnIcon}',
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: AppColors.white,
                        ),
                      )
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SpaceVertical(20),
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
