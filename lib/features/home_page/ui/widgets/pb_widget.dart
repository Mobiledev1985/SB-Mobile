import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_images.dart';
import 'package:sb_mobile/core/constant/ui_constant.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/widgets/space_horizontal.dart';
import 'package:sb_mobile/features/fishery_property_details/ui/views/catch_report_detail_screen.dart';
import 'package:sb_mobile/features/home_page/data/models/user_statistics.dart';

class PBWidget extends StatelessWidget {
  const PBWidget({super.key, required this.userStatistics});

  final UserStatistics? userStatistics;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(defaultBorderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 22),
        child: Row(
          children: [
            SvgPicture.asset(
              AppImages.trophy,
            ),
            const SpaceHorizontal(17),
            RichText(
              text: TextSpan(
                text: 'PB:',
                style: context.textTheme.headlineSmall?.copyWith(
                  color: AppColors.darkTextColor,
                  fontWeight: FontWeight.w700,
                ),
                children: [
                  TextSpan(
                    text:
                        ' ${userStatistics?.catchReport?.fishWeightLb}lb ${userStatistics?.catchReport?.fishWeightOz}oz',
                    style: context.textTheme.headlineSmall?.copyWith(
                      color: AppColors.darkTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Text(
                ' ${userStatistics?.catchReport?.fishSpecies}',
                style: context.textTheme.headlineSmall?.copyWith(
                  color: const Color(0xff5C6166),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            GestureDetector(
              onTap: () {
                CatchReportDetailScreen.navigateTo(
                  context,
                  (
                    isFromHomeScreen: true,
                    catchReport: userStatistics!.catchReport!,
                    isFromMySb: true,
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'View',
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: AppColors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SpaceHorizontal(8),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
