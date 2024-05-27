import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_images.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/widgets/space_horizontal.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';

class IncredibleValuePacked extends StatefulWidget {
  const IncredibleValuePacked({super.key});

  @override
  State<IncredibleValuePacked> createState() => _IncredibleValuePackedState();
}

class _IncredibleValuePackedState extends State<IncredibleValuePacked> {
  final List<String> allPlanInclude = [
    "Book venues in the UK & abroad",
    "Submit & manage catch reports",
    "Weekly giveaways access",
    "InSession | Shop | Perks"
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Incredible value packed in.',
            style: context.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.greyTextColor,
            ),
          ),
          const SpaceVertical(14),
          Text(
            'Choose the plan which suits you best. Pay with ${Platform.isIOS ? 'Apple' : 'Android'} In-app purchase payment methods in a secure way. Cancel anytime.',
            style: context.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.greyColor,
              height: 1.5,
            ),
          ),
          const SpaceVertical(26),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: const Color(0xff8ABCE5),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'ALL PLANS INCLUDE',
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: const Color(0xffF2F6FA),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SpaceVertical(14),
                ...allPlanInclude
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              AppImages.checkIcon,
                              width: 16,
                              height: 16,
                            ),
                            const SpaceHorizontal(6),
                            Text(
                              e,
                              style: context.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: AppColors.greyTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
