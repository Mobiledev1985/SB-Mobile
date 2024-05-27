import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/ui_constant.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';
import 'package:sb_mobile/features/authentication/data/models/angler_profile_details_model.dart';
import 'package:sb_mobile/features/my_profile/ui/widgets/sbplus/wallet/money_widget.dart';

class ProfileBar extends StatelessWidget {
  final int? level;
  final AnglerProfile? profile;
  final bool? isFromWallet;

  const ProfileBar({
    super.key,
    this.level,
    required this.profile,
    this.isFromWallet,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final topPadding = MediaQuery.viewPaddingOf(context).top;
    return Stack(
      children: [
        Hero(
          tag: 'Background',
          child: Material(
            child: Image.network(
              profile?.backgroundImage?.replaceAll('https', 'http') ?? '',
              width: double.infinity,
              height: 146 + topPadding,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Image.asset(
                'assets/images/bg_gradiated.jpg',
                width: double.infinity,
                height: 146 + topPadding,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: defaultSidePadding,
            right: defaultSidePadding,
            top: topPadding,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SpaceVertical(10),
              Row(
                children: [
                  Hero(
                    tag: 'ProfileImage',
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        height: 74,
                        width: 74,
                        padding: const EdgeInsets.all(1.0),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: Image.network(
                            profile?.profileImage
                                    ?.replaceAll('https', 'http') ??
                                '',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                SvgPicture.asset(
                              'assets/images/user.svg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Hero(
                    tag: 'coin',
                    child: Material(
                      type: MaterialType.transparency,
                      child: CoinWidget(
                        value: profile == null ? 0.0 : profile!.walletAmount,
                        fontSize: 16,
                        profile: profile,
                        isFromWallet: isFromWallet,
                      ),
                    ),
                  ),
                ],
              ),
              const SpaceVertical(10),
              Row(
                children: [
                  Hero(
                    tag: 'Name',
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        '${profile?.firstName} ${profile?.lastName}',
                        style: textTheme.bodyLarge?.copyWith(
                          fontSize: 32,
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                          shadows: [
                            const BoxShadow(
                              offset: Offset(0, 1.5),
                              blurRadius: 9,
                              color: AppColors.textBoxShadowColor,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Text(
                  //   'Level 5',
                  //   style: textTheme.headlineMedium?.copyWith(
                  //     color: AppColors.white,
                  //     fontWeight: FontWeight.w500,
                  //   ),
                  // )
                ],
              ),
              Hero(
                tag: 'stats',
                placeholderBuilder: (context, heroSize, child) =>
                    const SizedBox(),
                child: const SizedBox(width: double.infinity),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
