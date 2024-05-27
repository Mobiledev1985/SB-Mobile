import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_images.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/utility/utils/utils.dart';
import 'package:sb_mobile/core/widgets/space_horizontal.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';

class AnswerWidget extends StatelessWidget {
  const AnswerWidget({
    super.key,
    required this.isCorrect,
    this.ticketNumber,
  });

  final bool isCorrect;
  final String? ticketNumber;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            color: const Color(0xff606060),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        isCorrect ? AppImages.checked : AppImages.remove,
                        width: 26,
                        height: 26,
                      ),
                      const SpaceHorizontal(10),
                      Text(
                        'You answered ${isCorrect ? 'correctly!' : 'incorrectly'}',
                        style: context.textTheme.headlineSmall?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SpaceVertical(12),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: const Color(0xff525252),
                    child: isCorrect
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  AppImages.ticket,
                                ),
                                const SpaceHorizontal(22),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Your ticket number is:',
                                        style: context.textTheme.bodyMedium
                                            ?.copyWith(
                                          color: AppColors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SpaceVertical(8),
                                      Text(
                                        ticketNumber!,
                                        style: context.textTheme.bodyMedium
                                            ?.copyWith(
                                          color: AppColors.white,
                                          fontSize: 30,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24.0),
                            child: Center(
                              child: Text(
                                'Please come back and try again next week!',
                                textAlign: TextAlign.center,
                                style:
                                    context.textTheme.headlineMedium?.copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                  )
                ],
              ),
            ),
          ),
          const SpaceVertical(16),
          Card(
            color: const Color(0xff606060),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 22.0, vertical: 26),
              child: Column(
                children: [
                  Text(
                    'The weekly live draw takes place in the swimbooker+ Facebook community group.\n\nYou can join using the link below:',
                    textAlign: TextAlign.center,
                    style: context.textTheme.headlineSmall?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SpaceVertical(4),
                  TextButton(
                    onPressed: () {
                      openUrlInWebBrowser(
                          'https://bit.ly/SBPlusCommunityGroup');
                    },
                    child: Text(
                      'bit.ly/SBPlusCommunityGroup',
                      textAlign: TextAlign.center,
                      style: context.textTheme.headlineSmall?.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SpaceVertical(16),
        ],
      ),
    );
  }
}
