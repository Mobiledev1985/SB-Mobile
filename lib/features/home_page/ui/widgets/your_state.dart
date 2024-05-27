import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_images.dart';
import 'package:sb_mobile/core/constant/ui_constant.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/widgets/space_horizontal.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';
import 'package:sb_mobile/features/authentication/data/models/angler_profile_details_model.dart';
import 'package:sb_mobile/features/home_page/data/models/user_statistics.dart';
import 'package:sb_mobile/features/home_page/ui/views/bottom_bar_provider.dart';

class YourState extends StatelessWidget {
  const YourState(
      {super.key, required this.anglerProfile, required this.userStatistics});

  final AnglerProfile? anglerProfile;

  final UserStatistics? userStatistics;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(defaultBorderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SpaceVertical(14),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SvgPicture.asset(
                  AppImages.fishPlus,
                  width: 22,
                  height: 10,
                ),
                const SpaceHorizontal(10),
                Text(
                  'Digital Angler ID',
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkTextColor,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${anglerProfile?.firstName} ${anglerProfile?.lastName}",
                        style: context.textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkTextColor),
                      ),
                      Text(
                        '${anglerProfile?.publicId}',
                        style: context.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff45494D),
                        ),
                      ),
                      const SpaceVertical(10),
                      Row(
                        children: [
                          StateItem(
                            title: 'Catches',
                            value: '${userStatistics?.fishCaught}',
                          ),
                          const SpaceHorizontal(6),
                          StateItem(
                            title: 'Sessions',
                            value: '${userStatistics?.sessionsBooked ?? ''}',
                          ),
                          const SpaceHorizontal(6),
                          StateItem(
                            title: 'Reviews',
                            value: '${userStatistics?.fisheryReviews ?? ''}',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 44,
                  backgroundColor: const Color(0xffF2F6FA),
                  child: ClipOval(
                    child: Image.network(
                      anglerProfile?.profileImage ?? '',
                      fit: BoxFit.cover,
                      width: 85,
                      height: 85,
                      errorBuilder: (context, error, stackTrace) => ClipOval(
                        child: SvgPicture.asset(
                          'assets/images/user.svg',
                          width: 85,
                          height: 85,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                BottomBarProvider.of(context).selectedBottomBarItem.value = 2;
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'View ',
                      style: context.textTheme.bodyLarge?.copyWith(
                        color: AppColors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                      children: [
                        TextSpan(
                          text: 'MySB',
                          style: context.textTheme.bodyLarge?.copyWith(
                            color: AppColors.blue,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      ],
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
            const SpaceVertical(16),
          ],
        ),
      ),
    );
  }
}

class StateItem extends StatelessWidget {
  const StateItem({super.key, required this.title, required this.value});

  final String title;

  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: const Color(0xffF2F6FA),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 4.0,
        ),
        child: Column(
          children: [
            Text(
              title,
              style: context.textTheme.bodySmall?.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: const Color(0xff45494D),
              ),
            ),
            const SpaceVertical(2),
            Text(
              value,
              style: context.textTheme.displayMedium?.copyWith(
                color: AppColors.darkTextColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
