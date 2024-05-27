import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/widgets/space_horizontal.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';

class SubcriptionPlanCard extends StatelessWidget {
  const SubcriptionPlanCard({
    super.key,
    required this.isPro,
    required this.isMonthly,
    required this.price,
    required this.usallyPrice,
    required this.benefits,
    required this.onTap,
    required this.isLoading,
    required this.isLoggedIn,
  });

  final bool isPro;
  final bool isMonthly;
  final String price;
  final String usallyPrice;
  final List<String> benefits;
  final VoidCallback onTap;
  final bool isLoading;
  final bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: const Border(
          bottom: BorderSide(
            color: Color(0xff737A80),
          ),
          left: BorderSide(
            color: Color(0xff737A80),
          ),
          right: BorderSide(
            color: Color(0xff737A80),
          ),
        ),
        gradient: const LinearGradient(
          stops: [0.02, 0.02],
          colors: [
            AppColors.secondaryBlue,
            Colors.transparent,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12.0),
        child: Column(
          children: [
            const SpaceVertical(10),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: AppColors.secondaryBlue,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 2),
                  child: Text(
                    isPro ? 'MAX BENEFITS' : 'BEST VALUE',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: AppColors.greyTextColor,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Spacer(),
                Text(
                  '£$usallyPrice',
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xffA1AAB2),
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SpaceHorizontal(6),
                Column(
                  children: [
                    Text(
                      price,
                      style: context.textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xffF2F6FA),
                      ),
                    ),
                    Text(
                      'per month',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: AppColors.greyColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Align(
              alignment: Alignment.topLeft,
              child: RichText(
                text: TextSpan(
                  text: 'swimbooker+',
                  style: context.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xffF2F6FA),
                  ),
                  children: [
                    if (isPro)
                      TextSpan(
                        text: ' PRO',
                        style: context.textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: const Color(0xffF2F6FA),
                          fontFamily: 'Montserrat',
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SpaceVertical(12),
            Column(
              children: [
                ...benefits.map(
                  (e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 5,
                          height: 5,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.greyColor,
                          ),
                        ),
                        const SpaceHorizontal(10),
                        Text(
                          e,
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: AppColors.greyColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SpaceVertical(12),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryBlue,
                ),
                onPressed: isLoading ? () {} : onTap,
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: AppColors.white,
                      )
                    : Text(
                        isLoggedIn
                            ? 'Choose ${isPro ? "Pro" : "Plus"}'
                            : 'Login To Subscribe',
                        style: context.textTheme.displaySmall?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            const SpaceVertical(12),
            RichText(
              text: TextSpan(
                text:
                    'Claim swimbooker+ Pro for £6.99 per month. Offer available for new subscribers only. ',
                style: context.textTheme.bodySmall?.copyWith(
                  color: const Color(0xffA1AAB2),
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
                children: [
                  TextSpan(
                    text: 'Click here',
                    recognizer: TapGestureRecognizer()..onTap = () {},
                    style: context.textTheme.bodySmall?.copyWith(
                      color: const Color(0xffA1AAB2),
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const TextSpan(
                    text: ' for full terms and conditions.',
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
