import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sb_mobile/core/constant/app_images.dart';
import 'package:sb_mobile/core/constant/app_strings.dart';
import 'package:sb_mobile/core/constant/ui_constant.dart';
import 'package:sb_mobile/core/widgets/space_horizontal.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';
import 'package:share_plus/share_plus.dart';

class InviteWidget extends StatelessWidget {
  const InviteWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () async {
        await Share.shareWithResult(
          Platform.isIOS
              ? 'https://apps.apple.com/gb/app/swimbooker/id1586855906'
              : 'https://play.google.com/store/apps/details?id=com.app.swimbookerapp',
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(defaultBorderRadius),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 24),
          child: Row(
            children: [
              const SpaceHorizontal(20),
              SvgPicture.asset(
                AppImages.invite,
                width: 70,
                height: 70,
              ),
              const SpaceHorizontal(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.inviteyour,
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SpaceVertical(5),
                    Text(
                      AppStrings.enjoy,
                      style: textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),

        //  Column(
        //   children: [
        //     const SpaceVertical(34),
        //     SvgPicture.asset(
        //       AppImages.invite,
        //       width: 70,
        //       height: 70,
        //     ),
        //     const SpaceVertical(20),
        //     Text(
        //       AppStrings.inviteyour,
        //       style: textTheme.headlineMedium?.copyWith(
        //         fontWeight: FontWeight.w600,
        //       ),
        //     ),
        //     const SpaceVertical(5),
        //     Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: 28.0),
        //       child: Text(
        //         AppStrings.enjoy,
        //         style: textTheme.bodyLarge?.copyWith(
        //           fontWeight: FontWeight.w500,
        //           color: const Color(0xff787878),
        //         ),
        //         textAlign: TextAlign.center,
        //       ),
        //     ),
        //     const SpaceVertical(40),
        //     Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: 32.0),
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           Visibility(
        //             visible: Platform.isIOS,
        //             child: const AppShareLinkItem(
        //               platformText: AppStrings.shareAppleAppStoreLink,
        //               link:
        //                   'https://apps.apple.com/gb/app/swimbooker/id1586855906',
        //             ),
        //           ),
        //           const SpaceVertical(20),
        //           Visibility(
        //             visible: Platform.isAndroid,
        //             child: const AppShareLinkItem(
        //               platformText: AppStrings.shareGooglePlayStoreLink,
        //               link:
        //                   'https://play.google.com/store/apps/details?id=com.app.swimbookerapp',
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //     const SpaceVertical(50),
        //   ],
        // ),
      ),
    );
  }
}
