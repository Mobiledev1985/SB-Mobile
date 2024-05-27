import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_images.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/utility/utils/utils.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';
import 'package:sb_mobile/features/authentication/ui/widgets/dotted_divider.dart';

typedef Benefits = ({String title, String sbPro, String sbPlus});

class WhatYouGet extends StatelessWidget {
  const WhatYouGet({super.key});

  @override
  Widget build(BuildContext context) {
    const String fontFamily = 'Montserrat';
    final List<Benefits> subscriptionBenefits = [
      (title: "Live Weekly Giveaway", sbPro: "check", sbPlus: "check"),
      (title: "Discounted SB Shop", sbPro: "check", sbPlus: "check"),
      (title: "SB Wallet", sbPro: "check", sbPlus: "check"),
      (title: "Unlimited Perks & Offers", sbPro: "check", sbPlus: "check"),
      (title: "Cashback On Bookings", sbPro: "Global", sbPlus: "UK"),
      (title: "Cashback On Purchases", sbPro: "2%", sbPlus: "1%"),
      (title: "Personal Injury Insurance", sbPro: "Max", sbPlus: "Partial"),
      (title: "Equipment Insurance", sbPro: "£1K", sbPlus: "£350"),
      (title: "Turbo-Charged Points", sbPro: "check", sbPlus: "uncheck"),
      (title: "Unique Achievement Badges", sbPro: "check", sbPlus: "uncheck"),
    ];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(30),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            Color.fromRGBO(255, 255, 255, 0.0),
          ],
        ),
      ),
      child: Column(
        children: [
          const SpaceVertical(26),
          Row(
            children: [
              Expanded(
                flex: 5,
                child: Text(
                  'What you get:',
                  style: context.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w900, fontFamily: fontFamily),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'SB+ PRO',
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w900, fontFamily: fontFamily),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'SB+',
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w900, fontFamily: fontFamily),
                ),
              ),
            ],
          ),
          const SpaceVertical(26),
          Expanded(
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: RichText(
                            text: TextSpan(
                              text: 'Early ',
                              style: context.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                fontFamily: fontFamily,
                              ),
                              children: [
                                TextSpan(
                                  text: 'InSession',
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    fontFamily: fontFamily,
                                  ),
                                ),
                                TextSpan(
                                  text: ' Access',
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: fontFamily,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: SvgPicture.asset(AppImages.checkMark),
                        ),
                        Expanded(
                          flex: 2,
                          child: SvgPicture.asset(AppImages.checkMark),
                        ),
                      ],
                    ),
                    const DottedDivider(),
                    ...List.generate(
                      subscriptionBenefits.length,
                      (index) => Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: Text(
                                  subscriptionBenefits[index].title,
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: fontFamily,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: GetIndicator(
                                  value: subscriptionBenefits[index].sbPro,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: GetIndicator(
                                  value: subscriptionBenefits[index].sbPlus,
                                ),
                              ),
                            ],
                          ),
                          const DottedDivider(),
                        ],
                      ),
                    ).toList()
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class GetIndicator extends StatelessWidget {
  final String value;
  const GetIndicator({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return value == 'check'
        ? SvgPicture.asset(
            AppImages.checkMark,
          )
        : value == 'uncheck'
            ? SvgPicture.asset(
                AppImages.cross,
              )
            : Text(
                value,
                textAlign: TextAlign.center,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.blue,
                ),
              );
  }
}
