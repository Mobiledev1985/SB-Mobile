import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_images.dart';
import 'package:sb_mobile/core/constant/ui_constant.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';

class WalletWorkDialog extends StatelessWidget {
  const WalletWorkDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(defaultBorderRadius),
        side: const BorderSide(
          color: AppColors.blue,
          width: 5,
        ),
      ),
      child: IntrinsicHeight(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.topRight,
                child: CloseButton(),
              ),
              Text(
                'How does the wallet work?',
                textAlign: TextAlign.center,
                style: context.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SpaceVertical(24),
              SvgPicture.asset(
                AppImages.wallet,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
              const SpaceVertical(24),
              RichText(
                text: TextSpan(
                  text: 'As a ',
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    TextSpan(
                      text: 'swimbooker+ member',
                      style: context.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.blue,
                      ),
                    ),
                    TextSpan(
                      text:
                          ' , you receive credit back on every purchase made via swimbooker. This includes fishing bookings, tackle and bait purchases!',
                      style: context.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SpaceVertical(16),
              const Divider(
                color: AppColors.blue,
                indent: 130,
                endIndent: 130,
                thickness: 1.5,
              ),
              const SpaceVertical(16),
              RichText(
                text: TextSpan(
                  text: 'To spend your credit, simply select ',
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    TextSpan(
                      text: '‘Use Credit’',
                      style: context.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.green,
                      ),
                    ),
                    TextSpan(
                      text:
                          'at checkout when booking your fishing online or in-app.',
                      style: context.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SpaceVertical(18),
            ],
          ),
        ),
      ),
    );
  }
}
