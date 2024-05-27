import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_images.dart';
import 'package:sb_mobile/core/constant/ui_constant.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';
import 'package:sb_mobile/features/authentication/data/models/angler_profile_details_model.dart';
import 'package:sb_mobile/features/authentication/ui/views/sb_plus_purchase_screen.dart';
import 'package:sb_mobile/features/home_page/cubit/home_page_cubit.dart';
import 'package:sb_mobile/features/home_page/ui/views/bottom_bar_provider.dart';

class SbBanner extends StatelessWidget {
  const SbBanner(
      {super.key, required this.profile, required this.isFromProfile});
  final AnglerProfile? profile;

  final bool isFromProfile;

  bool isPlusMember(BuildContext context) {
    final String? subscriptionLevel =
        (context.read<HomePageCubit>().state as HomePageLoaded)
            .subscriptionLevel;

    return subscriptionLevel?.toLowerCase().contains('plus') == true ||
        subscriptionLevel?.toLowerCase().contains('pro') == true;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (isPlusMember(context)) {
          //ignore: use_build_context_synchronously
          BottomBarProvider.of(context).selectedBottomBarItem.value = 2;
          // ignore: use_build_context_synchronously
          // Navigator.pushAndRemoveUntil(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => const BottomBarScreen(),
          //   ),
          //   (route) => false,
          // );
        } else {
          SbPlusPurchaseScreen.navigateTo(
            context,
            (email: profile?.email ?? '', isLoggedIn: profile != null),
          ).then((value) {
            if (isFromProfile) {
              Future.delayed(const Duration(milliseconds: 500)).then(
                (value) {
                  if (Platform.isAndroid) {
                    SystemChrome.setSystemUIOverlayStyle(
                      const SystemUiOverlayStyle(
                          statusBarColor: Colors.transparent,
                          statusBarIconBrightness: Brightness.light),
                    );
                  } else {
                    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
                    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
                  }
                },
              );
            }
          });
          // FeatureListScreen.navigateTo(context, profile?.email);
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: isFromProfile ? 0.0 : defaultSidePadding,
        ),
        width: double.infinity,
        height: 130,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(defaultBorderRadius),
          gradient: isPlusMember(context)
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                      AppColors.blue,
                      Color(0xff0D3759),
                    ])
              : null,
          image: !isPlusMember(context)
              ? const DecorationImage(
                  image: AssetImage(
                    AppImages.banner,
                  ),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isPlusMember(context)
                      ? 'Welcome to swimbooker+'
                      : '${isFromProfile ? 'Unlock' : 'Introducing'} swimbooker+',
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SpaceVertical(8),
                Text(
                  isPlusMember(context)
                      ? 'As a member, you’ve gained access\nto a host of exciting features!'
                      : 'The all-in-one membership\nfor anglers',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SpaceVertical(15),
                IgnorePointer(
                  child: SizedBox(
                    width: 118,
                    height: 24,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffF3F3F3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      onPressed: () async {},
                      child: Text(
                        isPlusMember(context)
                            ? 'View My Profile'
                            : 'Learn More',
                        style: context.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            const Spacer(),
            Image.asset(
              isPlusMember(context)
                  ? AppImages.phoneBanner2
                  : AppImages.phoneBanner,
            )
          ],
        ),
      ),
    );
  }
}
