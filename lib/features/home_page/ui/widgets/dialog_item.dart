import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_images.dart';
import 'package:sb_mobile/core/constant/ui_constant.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';

class DialogItem extends StatelessWidget {
  final String icon;
  final String text;
  final VoidCallback onTap;
  const DialogItem(
      {super.key, required this.icon, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: Column(
          children: [
            InkWell(
              onTap: onTap,
              child: Ink(
                decoration: BoxDecoration(
                  color: AppColors.blue,
                  borderRadius: BorderRadius.circular(defaultButtonRadius),
                ),
                height: 66,
                width: 80,
                child: Center(
                  child: SvgPicture.asset(
                    icon,
                    height: icon == AppImages.fish ? 28 : 56,
                    width: icon == AppImages.fish ? 28 : 56,
                    fit: BoxFit.contain,
                    colorFilter: const ColorFilter.mode(
                      AppColors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
            const SpaceVertical(4),
            Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            )
          ],
        ),
      ),
    );
  }
}
