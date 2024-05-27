import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_images.dart';
import 'package:sb_mobile/core/constant/ui_constant.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/widgets/space_horizontal.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';
import 'package:sb_mobile/features/authentication/ui/views/sb_plus_purchase_screen.dart';

typedef Feature = ({String image, String title});

class SBPromoBanner extends StatelessWidget {
  const SBPromoBanner(
      {super.key, required this.isFromInSession, required this.email});

  final bool isFromInSession;

  final String email;

  @override
  Widget build(BuildContext context) {
    final List<Feature> fetures = [
      (image: AppImages.wallet, title: 'Cashback on fishing & products'),
      (image: AppImages.shopIcon, title: 'swimbooker+ Discounted Store'),
      (image: AppImages.perks, title: 'Unique Perks & Promotions'),
      (image: AppImages.insurance, title: 'Angling Insurance'),
      (image: AppImages.sessionIcon, title: 'Access to InSession'),
      (image: AppImages.giveawaysIcon, title: 'Weekly Giveaways!'),
    ];
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: IntrinsicHeight(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SpaceVertical(32),
              !isFromInSession
                  ? RichText(
                      text: TextSpan(
                        text: 'Angler!',
                        style: context.textTheme.headlineMedium?.copyWith(
                          color: const Color(0xff174A73),
                          fontWeight: FontWeight.w700,
                          height: 1.4,
                        ),
                        children: [
                          TextSpan(
                            text: ' Want to learn more about',
                            style: context.textTheme.headlineMedium?.copyWith(
                              color: const Color(0xff174A73),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: ' swimbooker+?',
                            style: context.textTheme.headlineMedium?.copyWith(
                              color: const Color(0xff174A73),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    )
                  : RichText(
                      text: TextSpan(
                        text: 'InSession ',
                        style: context.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          fontFamily: mfontFamily,
                          color: AppColors.darkTextColor,
                        ),
                        children: [
                          TextSpan(
                            text: 'is a swimbooker+ feature!',
                            style: context.textTheme.headlineMedium?.copyWith(
                              color: const Color(0xff174A73),
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
              const SpaceVertical(20),
              Text(
                'Our Pro & Plus members enjoy a host of exciting benefits:',
                style: context.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkTextColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SpaceVertical(20),
              ...fetures
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 25,
                            height: 25,
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: SvgPicture.asset(
                                e.image,
                              ),
                            ),
                          ),
                          const SpaceHorizontal(16),
                          if (e.title == 'Access to InSession')
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  text: 'Access to ',
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    color: const Color(0xff062640),
                                    fontWeight: FontWeight.w600,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'InSession',
                                      style: context.textTheme.bodyMedium
                                          ?.copyWith(
                                        fontWeight: FontWeight.w900,
                                        fontFamily: mfontFamily,
                                      ),
                                    )
                                  ],
                                ),
                                maxLines: 2,
                              ),
                            )
                          else
                            Expanded(
                              child: Text(
                                e.title,
                                style: context.textTheme.bodyMedium?.copyWith(
                                  color: const Color(0xff062640),
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 2,
                              ),
                            ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              const SpaceVertical(18),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff1F5B8C),
                  side: const BorderSide(
                    color: Color(0xffAAD2F2),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  SbPlusPurchaseScreen.navigateTo(
                    context,
                    (email: email, isLoggedIn: true),
                  ).then(
                    (value) {
                      if (isFromInSession) {
                        Future.delayed(const Duration(milliseconds: 500)).then(
                          (value) {
                            if (Platform.isAndroid) {
                              SystemChrome.setSystemUIOverlayStyle(
                                const SystemUiOverlayStyle(
                                    statusBarColor: Colors.transparent,
                                    statusBarIconBrightness: Brightness.light),
                              );
                            } else {
                              FlutterStatusbarcolor.setStatusBarWhiteForeground(
                                  true);
                              FlutterStatusbarcolor.setStatusBarColor(
                                  Colors.transparent);
                            }
                          },
                        );
                      }
                    },
                  );
                },
                child: Text(
                  'I’m Interested! Learn More',
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
                    color: Color(0xffDCE1E5),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Not Right Now',
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xffA1AAB2),
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
