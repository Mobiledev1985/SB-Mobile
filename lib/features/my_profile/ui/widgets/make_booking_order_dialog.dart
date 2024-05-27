import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_images.dart';
import 'package:sb_mobile/core/constant/ui_constant.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/widgets/space_horizontal.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';
import 'package:sb_mobile/features/home_page/ui/views/bottom_bar_provider.dart';
import 'package:sb_mobile/features/home_page/ui/views/bottom_bar_screen.dart';

class MakeBookingOrderDialog extends StatelessWidget {
  const MakeBookingOrderDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final TextStyle? normalStyle = context.textTheme.bodyLarge?.copyWith(
      fontWeight: FontWeight.w600,
      color: AppColors.white,
    );
    final TextStyle? boldStyle = context.textTheme.bodyLarge?.copyWith(
      fontWeight: FontWeight.w700,
      color: AppColors.white,
    );
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      backgroundColor: AppColors.blue,
      child: IntrinsicHeight(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SpaceVertical(32),
              RichText(
                text: TextSpan(
                  text: 'Make a booking in order to go ',
                  style: context.textTheme.headlineMedium?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                  children: [
                    TextSpan(
                      text: 'InSession!',
                      style: context.textTheme.headlineMedium?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w900,
                        fontFamily: mfontFamily,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SpaceVertical(20),
              FeatureItem(
                titleWidget: RichText(
                  text: TextSpan(
                    text: 'Keep track of detailed ',
                    style: normalStyle,
                    children: [
                      TextSpan(
                        text: 'session notes',
                        style: boldStyle,
                      )
                    ],
                  ),
                ),
                imageUrl: AppImages.notes,
                needDecoration: false,
              ),
              FeatureItem(
                titleWidget: RichText(
                  text: TextSpan(
                    text: 'Upload ',
                    style: normalStyle,
                    children: [
                      TextSpan(
                        text: 'catch reports',
                        style: boldStyle,
                      ),
                      TextSpan(
                        text: ' during your session',
                        style: normalStyle,
                      )
                    ],
                  ),
                ),
                imageUrl: AppImages.gallery,
                needDecoration: false,
              ),
              FeatureItem(
                titleWidget: RichText(
                  text: TextSpan(
                    text: 'Keep track of ',
                    style: normalStyle,
                    children: [
                      TextSpan(
                        text: 'session statistics',
                        style: boldStyle,
                      )
                    ],
                  ),
                ),
                imageUrl: AppImages.fishingStats,
                needDecoration: false,
              ),
              FeatureItem(
                titleWidget: RichText(
                  text: TextSpan(
                    text: 'Access ',
                    style: normalStyle,
                    children: [
                      TextSpan(
                        text: 'Pro Weather',
                        style: boldStyle,
                      ),
                      TextSpan(
                        text: ' in your local area! ',
                        style: normalStyle,
                      )
                    ],
                  ),
                ),
                imageUrl: AppImages.localWeather,
                needDecoration: true,
              ),
              FeatureItem(
                titleWidget: RichText(
                  text: TextSpan(
                    text: 'Find local food',
                    style: boldStyle,
                    children: [
                      TextSpan(
                        text: ' in your area from popular delivery apps',
                        style: normalStyle,
                      )
                    ],
                  ),
                ),
                imageUrl: AppImages.food,
                needDecoration: true,
              ),
              const SpaceVertical(20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0D3759),
                  side: const BorderSide(
                    color: Color(0xffAAD2F2),
                  ),
                ),
                onPressed: () {
                  BottomBarProvider.of(context).selectedBottomBarItem.value = 1;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BottomBarScreen(),
                    ),
                    (route) => false,
                  );
                },
                child: Text(
                  'Start Searching',
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
              ),
              const SpaceVertical(8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  side: const BorderSide(
                    color: Color(0xffD9EEFF),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Close',
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xffD9EEFF),
                  ),
                ),
              ),
              const SpaceVertical(28),
            ],
          ),
        ),
      ),
    );
  }
}

class FeatureItem extends StatelessWidget {
  const FeatureItem(
      {super.key,
      required this.titleWidget,
      required this.imageUrl,
      required this.needDecoration});

  final Widget titleWidget;

  final String imageUrl;

  final bool needDecoration;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Container(
            padding: needDecoration ? const EdgeInsets.all(2) : null,
            decoration: needDecoration
                ? BoxDecoration(
                    color: const Color(0xffE6E6E6),
                    borderRadius: BorderRadius.circular(5),
                  )
                : null,
            child: SvgPicture.asset(
              imageUrl,
              width: needDecoration ? 28 : 30,
              height: needDecoration ? 28 : 30,
            ),
          ),
          const SpaceHorizontal(14),
          Expanded(child: titleWidget),
        ],
      ),
    );
  }
}
