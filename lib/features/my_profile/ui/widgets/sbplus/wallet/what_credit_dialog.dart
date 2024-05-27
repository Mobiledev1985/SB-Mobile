import 'package:flutter/material.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/ui_constant.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/widgets/space_horizontal.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';

class WhatCreditDialog extends StatelessWidget {
  const WhatCreditDialog({super.key});

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
                'What Credit Do I Earn?',
                textAlign: TextAlign.center,
                style: context.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SpaceVertical(16),
              Text(
                'Credit is calculated based on the\nfinal value at checkout',
                textAlign: TextAlign.center,
                style: context.textTheme.bodyLarge?.copyWith(),
              ),
              const SpaceVertical(16),
              Text(
                'UK Venue Bookings',
                textAlign: TextAlign.center,
                style: context.textTheme.bodyLarge?.copyWith(
                  color: AppColors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SpaceVertical(18),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PlanCard(plan: 'SB+', percentage: '0.10'),
                  SpaceHorizontal(14),
                  PlanCard(plan: 'SB+ Pro', percentage: '0.25'),
                ],
              ),
              const SpaceVertical(18),
              Text(
                'International Venue Bookings',
                textAlign: TextAlign.center,
                style: context.textTheme.bodyLarge?.copyWith(
                  color: AppColors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SpaceVertical(18),
              const PlanCard(plan: 'SB+ Pro', percentage: '1'),
              const SpaceVertical(18),
              Text(
                'SB+ Shop Purchases',
                textAlign: TextAlign.center,
                style: context.textTheme.bodyLarge?.copyWith(
                  color: AppColors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SpaceVertical(18),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PlanCard(plan: 'SB+', percentage: '1'),
                  SpaceHorizontal(14),
                  PlanCard(plan: 'SB+ Pro', percentage: '2'),
                ],
              ),
              const SpaceVertical(18),
            ],
          ),
        ),
      ),
    );
  }
}

class PlanCard extends StatelessWidget {
  final String plan;
  final String percentage;
  const PlanCard({super.key, required this.plan, required this.percentage});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      height: 50,
      child: Card(
        color: AppColors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              plan,
              style: context.textTheme.bodyLarge?.copyWith(
                fontFamily: mfontFamily,
                fontWeight: FontWeight.w900,
                color: AppColors.white,
              ),
            ),
            Text(
              '$percentage%',
              style: context.textTheme.bodyLarge?.copyWith(
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
