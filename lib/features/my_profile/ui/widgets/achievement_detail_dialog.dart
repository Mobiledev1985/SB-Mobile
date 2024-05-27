import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_strings.dart';
import 'package:sb_mobile/core/constant/ui_constant.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/widgets/back_button.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';
import 'package:sb_mobile/features/my_profile/data/models/achivement_model.dart';

class AchievementDetailDialog extends StatelessWidget {
  const AchievementDetailDialog({super.key, required this.badges});

  final Badges badges;

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
      backgroundColor: const Color(0xffF5F5F5),
      child: IntrinsicHeight(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Align(
                alignment: Alignment.topLeft,
                child: BackButtonWidget(isCloseIcon: true),
              ),
              Column(
                children: [
                  CachedNetworkImage(
                    imageUrl: badges.icon ?? '',
                    width: 120,
                    height: 120,
                  ),
                  const SpaceVertical(6),
                  Text(
                    badges.name ?? '',
                    style: context.textTheme.displaySmall?.copyWith(
                      color: AppColors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SpaceVertical(6),
                  Text(
                    '${badges.points} pts',
                    style: context.textTheme.bodyLarge?.copyWith(),
                  ),
                ],
              ),
              const SpaceVertical(24),
              Text(
                '${badges.description}',
                textAlign: TextAlign.center,
                style: context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SpaceVertical(24),
              if (badges.awardedDate != null && badges.awardedDate!.isNotEmpty)
                Text(
                  '${AppStrings.unlockDate}: ${DateFormat('d/MM/yyyy').format(DateTime.parse(badges.awardedDate!))}',
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodyMedium?.copyWith(),
                ),
              const SpaceVertical(32),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(defaultBorderRadius),
                    side: const BorderSide(
                      color: Color(0xffE0E0E0),
                    ),
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
