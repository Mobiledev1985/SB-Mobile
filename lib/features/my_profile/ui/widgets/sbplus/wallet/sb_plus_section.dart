import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_images.dart';
import 'package:sb_mobile/core/constant/ui_constant.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/notification/web_view_screen.dart';
import 'package:sb_mobile/core/widgets/space_horizontal.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';
import 'package:sb_mobile/features/authentication/data/models/angler_profile_details_model.dart';
import 'package:sb_mobile/features/my_profile/cubit/my_profile_cubit.dart';
import 'package:sb_mobile/features/my_profile/ui/view/subscription/giveaways/giveaways_screen.dart';
import 'package:sb_mobile/features/my_profile/ui/view/subscription/insurance/insurance_screen.dart';
import 'package:sb_mobile/features/my_profile/ui/view/subscription/offer/offer_screen.dart';
import 'package:sb_mobile/features/my_profile/ui/view/subscription/session/session_screen.dart';
import 'package:sb_mobile/features/my_profile/ui/view/subscription/wallet/wallet_screen.dart';

class SBPlusSection extends StatelessWidget {
  const SBPlusSection({super.key, this.profile});

  final AnglerProfile? profile;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white.withOpacity(0.50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(defaultBorderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.blackColor,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: const Color(0xffDDDDDD),
                ),
              ),
              child: Text(
                'swimbooker+',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
              ),
            ),
            const SpaceVertical(8),
            SizedBox(
              height: 186,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        CommonItem(
                          title: 'Wallet',
                          imageName: AppImages.wallet,
                          onTap: () {
                            WalletScreen.navigateTo(context, profile);
                          },
                        ),
                        const SpaceVertical(8),
                        CommonItem(
                          title: 'Insurance',
                          imageName: AppImages.insurance,
                          onTap: () {
                            InsuranceScreen.navigateTo(
                              context,
                              (
                                profile: profile,
                                subscriptionLevel: context
                                    .read<MyProfileCubit>()
                                    .subscriptionLevel
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SpaceHorizontal(8),
                  Expanded(
                    child: Column(
                      children: [
                        CommonItem(
                          title: 'Shop',
                          imageName: AppImages.shopIcon,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const WebViewScreen(
                                  url: 'https://shop.swimbooker.com/',
                                  isGoBackToHomeScreen: false,
                                  title: 'Shop',
                                ),
                              ),
                            ).then((value) {
                              if (Platform.isAndroid) {
                                SystemChrome.setSystemUIOverlayStyle(
                                  const SystemUiOverlayStyle(
                                      statusBarColor: Colors.transparent,
                                      statusBarIconBrightness:
                                          Brightness.light),
                                );
                              } else {
                                FlutterStatusbarcolor
                                    .setStatusBarWhiteForeground(true);
                                FlutterStatusbarcolor.setStatusBarColor(
                                    Colors.transparent);
                              }
                            });
                          },
                        ),
                        const SpaceVertical(8),
                        CommonItem(
                          title: 'Sessions',
                          imageName: AppImages.sessionIcon,
                          onTap: () {
                            SessionScreen.navigateTo(context, profile);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SpaceHorizontal(8),
                  Expanded(
                    child: Column(
                      children: [
                        CommonItem(
                          title: 'Perks',
                          imageName: AppImages.perks,
                          onTap: () {
                            OfferScreen.navigateTo(context, profile);
                          },
                        ),
                        const SpaceVertical(8),
                        CommonItem(
                          title: 'Giveaways',
                          imageName: AppImages.giveawaysIcon,
                          onTap: () {
                            GiveawaysScreen.navigateTo(context, profile);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CommonItem extends StatelessWidget {
  const CommonItem(
      {super.key,
      required this.title,
      required this.imageName,
      required this.onTap});

  final String title;
  final String imageName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Ink(
          width: double.infinity,
          height: 88,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            gradient: const LinearGradient(
              colors: [
                Color(0xff191919),
                Color(0xff404040),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                imageName,
                width: 44,
                height: 44,
              ),
              const SpaceVertical(10),
              Text(
                title,
                style: context.textTheme.bodySmall?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w900,
                  fontFamily: mfontFamily,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
