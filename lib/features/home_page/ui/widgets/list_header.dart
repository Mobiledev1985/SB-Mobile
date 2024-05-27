import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_images.dart';
import 'package:sb_mobile/core/widgets/space_horizontal.dart';

class ListHeader extends StatelessWidget {
  final String icon;
  final String title;
  final String trailing;
  final VoidCallback? onPressed;

  const ListHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.trailing,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 10),
      child: Row(
        children: [
          SvgPicture.asset(
            icon,
            width: 20,
            height: 20,
            colorFilter: const ColorFilter.mode(
              AppColors.secondaryBlue,
              BlendMode.srcIn,
            ),
          ),
          const SpaceHorizontal(3),
          Text(
            title,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: onPressed,
            child: Row(
              children: [
                Text(
                  trailing,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SpaceHorizontal(4),
                SvgPicture.asset(
                  AppImages.rightArrow,
                  width: 12,
                  height: 12,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
