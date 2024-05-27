import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_images.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/widgets/space_horizontal.dart';
import 'package:sb_mobile/features/authentication/data/models/angler_profile_details_model.dart';
import 'package:sb_mobile/features/my_profile/ui/view/subscription/wallet/wallet_screen.dart';

class CoinWidget extends StatelessWidget {
  const CoinWidget({
    super.key,
    required this.value,
    required this.fontSize,
    this.profile,
    this.isFromWallet,
  });

  final double fontSize;

  final double value;

  final AnglerProfile? profile;

  final bool? isFromWallet;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isFromWallet == null) {
          WalletScreen.navigateTo(context, profile);
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(
            color: AppColors.dividerGreyColor,
          ),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 5,
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                AppImages.coinIcon2,
                width: 22,
                height: 22,
                fit: BoxFit.cover,
              ),
              const SpaceHorizontal(8),
              Text(
                '£${(value / 100).toStringAsFixed(2)}',
                style: context.textTheme.bodyLarge?.copyWith(
                  color: AppColors.blue,
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
