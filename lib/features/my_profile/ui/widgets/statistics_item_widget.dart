import 'package:flutter/material.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/ui_constant.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';

class StatisticsItemWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  const StatisticsItemWidget({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(
          left: defaultSidePadding, bottom: 20, right: defaultSidePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.bodyLarge?.copyWith(
              color: AppColors.skyBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SpaceVertical(15),
          Row(
            children: [
              Text(
                subtitle,
                style: textTheme.displaySmall?.copyWith(
                  color: AppColors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              // Visibility(
              //   visible: isSwitchMetric,
              //   child: SizedBox(
              //     width: 140,
              //     height: 32,
              //     child: ElevatedButton(
              //       style: ElevatedButton.styleFrom(
              //         backgroundColor: AppColors.green,
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(50),
              //         ),
              //       ),
              //       onPressed: () {},
              //       child: Text(
              //         AppStrings.switchMetric,
              //         style: textTheme.bodyMedium?.copyWith(
              //           fontWeight: FontWeight.bold,
              //           color: AppColors.white,
              //         ),
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
          const SpaceVertical(20),
          const Divider(
            height: 0,
            color: Color(0xffe2e2e2),
          )
        ],
      ),
    );
  }
}
