import 'package:flutter/material.dart';
import 'package:sb_mobile/core/constant/app_strings.dart';
import 'package:sb_mobile/core/widgets/alert.dart';
import 'package:sb_mobile/core/widgets/space_horizontal.dart';
import 'package:sb_mobile/features/submit_catch_report/ui/views/submit_catch_report_screen.dart';

class SubmitCatchReportWidget extends StatelessWidget {
  final bool isLoggedInUser;
  const SubmitCatchReportWidget({super.key, required this.isLoggedInUser});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: IntrinsicWidth(
        child: TextButton(
          onPressed: () {
            if (isLoggedInUser) {
              SubmitCatchReportScreen.navigateTo(context);
            } else {
              showAlert('Please login to Submit Catch Report');
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SvgPicture.asset(
              //   AppImages.fishing,
              //   width: 22,
              //   height: 22,
              // ),
              const SpaceHorizontal(6),
              Text(
                AppStrings.submitCatchReport,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
