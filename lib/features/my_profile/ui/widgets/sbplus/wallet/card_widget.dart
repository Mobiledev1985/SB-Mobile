import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_images.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';
import 'package:sb_mobile/features/authentication/data/models/angler_profile_details_model.dart';

class CardWidget extends StatelessWidget {
  final AnglerProfile? profile;

  const CardWidget({super.key, this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 24,
      ),
      decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff6EBEFF),
              AppColors.blue,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                'Digital Wallet',
                style: context.textTheme.headlineSmall?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(),
              SvgPicture.asset(
                AppImages.fish,
                width: 40,
                height: 18,
                colorFilter: const ColorFilter.mode(
                  AppColors.white,
                  BlendMode.srcIn,
                ),
              )
            ],
          ),
          const SpaceVertical(110),
          Text(
            'ID: ${profile?.publicId}',
            style: context.textTheme.bodyMedium?.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SpaceVertical(4),
          Material(
            type: MaterialType.transparency,
            child: Text(
              '${profile?.firstName} ${profile?.lastName}',
              style: context.textTheme.displaySmall?.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
