import 'package:flutter/material.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/ui_constant.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/widgets/back_button.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';

class RequireFisheryApproval extends StatelessWidget {
  const RequireFisheryApproval({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(defaultBorderRadius),
        side: const BorderSide(
          color: AppColors.dividerGreyColor,
          width: 1,
        ),
      ),
      backgroundColor: AppColors.dialogBlue,
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 45,
                child: Stack(
                  alignment: Alignment.center,
                  fit: StackFit.expand,
                  children: [
                    const Positioned(
                      left: 0,
                      // top: 0,
                      child: BackButtonWidget(isCloseIcon: true),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Image.asset(
                        'assets/icons/fish.png',
                        width: 45,
                        height: 30,
                      ),
                    ),
                  ],
                ),
              ),
              const SpaceVertical(10),
              Text(
                'Requires Fishery Approval',
                textAlign: TextAlign.center,
                style: context.textTheme.displaySmall?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SpaceVertical(14),
              Text(
                'Achievements relating to catch reports & species will require the fishery to approve the catch report.',
                textAlign: TextAlign.center,
                style: context.textTheme.headlineSmall?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SpaceVertical(28),
              Text(
                'Once approved, you will receive your badge and points.',
                textAlign: TextAlign.center,
                style: context.textTheme.headlineSmall?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SpaceVertical(30),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(defaultBorderRadius),
                  ),
                ),
                child: Text(
                  'Back',
                  style: context.textTheme.headlineMedium?.copyWith(
                    color: AppColors.blue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
