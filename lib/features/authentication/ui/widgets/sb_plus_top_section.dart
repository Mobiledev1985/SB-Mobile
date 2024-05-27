import 'package:flutter/material.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_images.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';

class SBPlusTopSection extends StatelessWidget {
  const SBPlusTopSection(
      {super.key, required this.onCompareFeature, required this.onJoinTheClub});

  final VoidCallback onCompareFeature;
  final VoidCallback onJoinTheClub;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Image.asset(
              AppImages.sbPlusBannerImage,
              width: double.infinity,
              height: 230,
            ),
            Positioned(
              top: 30,
              left: 20,
              child: GestureDetector(
                child: const CircleAvatar(
                  backgroundColor: AppColors.black,
                  child: Align(
                    alignment: Alignment(0.5, 0.0),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            )
          ],
        ),
        Image.asset(
          AppImages.sbPlusWhiteLogo,
          width: 180,
          height: 40,
        ),
        const SpaceVertical(20),
        Text(
          'The Membership For Anglers',
          style: context.textTheme.displayLarge?.copyWith(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: AppColors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SpaceVertical(20),
        Text(
          'Join today and gain instant\naccess to all club benefits!',
          style: context.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.greyColor,
          ),
          textAlign: TextAlign.center,
        ),
        const SpaceVertical(22),
        SizedBox(
          height: 46,
          width: MediaQuery.sizeOf(context).width * 0.75,
          child: ElevatedButton(
            onPressed: onJoinTheClub,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: Text(
              'Join the club',
              style: context.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SpaceVertical(16),
        SizedBox(
          height: 46,
          width: context.width * 0.75,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
                side: BorderSide(
                  color: AppColors.greyTextColor,
                ),
              ),
            ),
            onPressed: onCompareFeature,
            child: Text(
              'Compare features',
              style: context.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.greyTextColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SpaceVertical(18),
        Text(
          'Monthly & Annual package deals available to new\nsubscribers only. Terms and Conditions apply.',
          style: context.textTheme.bodySmall?.copyWith(
            color: const Color(0xffA1AAB2),
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SpaceVertical(56),
      ],
    );
  }
}
