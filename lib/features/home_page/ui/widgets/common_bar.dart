import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_images.dart';
import 'package:sb_mobile/core/constant/ui_constant.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/widgets/space_horizontal.dart';
import 'package:sb_mobile/features/authentication/data/models/angler_profile_details_model.dart';
import 'package:sb_mobile/features/home_page/cubit/home_page_cubit.dart';
import 'package:sb_mobile/features/home_page/ui/views/loggedin_dialog_screen.dart';
import 'package:sb_mobile/features/home_page/ui/views/login_dialog_screen.dart';

class CommonBar extends StatelessWidget {
  final AnglerProfile? anglerProfile;
  final double topPadding;
  final bool isFromDialog;
  final bool isExclusiveMediaScreen;
  final bool isFromBottomBar360;
  const CommonBar({
    super.key,
    required this.topPadding,
    required this.isFromDialog,
    this.anglerProfile,
    required this.isExclusiveMediaScreen,
    required this.isFromBottomBar360,
  });

  (bool, String?) isPlusMember(BuildContext context) {
    final String? subscriptionLevel =
        (context.read<HomePageCubit>().state as HomePageLoaded)
            .subscriptionLevel;

    return (
      subscriptionLevel?.toLowerCase().contains('plus') == true ||
          subscriptionLevel?.toLowerCase().contains('pro') == true,
      subscriptionLevel
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 14.0,
        right: 14.0,
        top: topPadding + 10,
        bottom: 10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            AppImages.logo,
            height: 48,
            width: 112,
          ),
          Visibility(
            visible: isPlusMember(context).$1,
            child: Text(
              '+',
              style: context.textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.blue,
              ),
            ),
          ),
          const Spacer(),
          Visibility(
            visible: isPlusMember(context).$1,
            child: Container(
              height: 22,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF174A73),
                    Color(0xFF062640),
                  ],
                ),
              ),
              child: Text(
                isPlusMember(context).$2?.toUpperCase() ?? '',
                style: context.textTheme.bodySmall?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w900,
                  fontFamily: mfontFamily,
                ),
              ),
            ),
          ),
          const SpaceHorizontal(10),
          GestureDetector(
            onTap: () {
              isFromDialog
                  ? Navigator.pop(context)
                  : anglerProfile == null
                      ? showDialog(
                          context: context,
                          builder: (context) => LoginDialogScreen(
                            topPadding: topPadding,
                            isFromBottomBar360: isFromBottomBar360,
                          ),
                        )
                      : showDialog(
                          context: context,
                          builder: (context) => LoggedDialogScreen(
                            topPadding: topPadding,
                            anglerProfile: anglerProfile!,
                            isExclusiveMediaScreen: isExclusiveMediaScreen,
                            isFromBottomBar360: isFromBottomBar360,
                          ),
                        );
            },
            child: Row(
              children: [
                anglerProfile != null
                    ? Stack(
                        children: [
                          ClipOval(
                            child: Image.network(
                              anglerProfile?.profileImage ?? '',
                              fit: BoxFit.cover,
                              width: 44,
                              height: 44,
                              errorBuilder: (context, error, stackTrace) =>
                                  ClipOval(
                                child: SvgPicture.asset(
                                  'assets/images/user.svg',
                                  width: 44,
                                  height: 44,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            child: BlocBuilder<HomePageCubit, HomePageState>(
                              builder: (context, state) {
                                return Visibility(
                                  visible: state is HomePageLoaded &&
                                      context
                                          .read<HomePageCubit>()
                                          .getNotification(false)
                                          .isNotEmpty,
                                  child: Transform(
                                    transform:
                                        Matrix4.translationValues(6, -6, 0),
                                    child: CircleAvatar(
                                      radius: 12,
                                      backgroundColor: const Color(0xffD95757),
                                      child: Text(
                                        context
                                            .read<HomePageCubit>()
                                            .getNotification(false)
                                            .length
                                            .toString(),
                                        style: context.textTheme.bodyMedium
                                            ?.copyWith(
                                          color: AppColors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    : CircleAvatar(
                        radius: 22,
                        backgroundColor: AppColors.lightgrey,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SvgPicture.asset(
                            AppImages.scanProfile,
                            width: 24,
                            height: 24,
                            colorFilter: const ColorFilter.mode(
                              AppColors.black,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                const SpaceHorizontal(5),
                IntrinsicWidth(
                  child: Icon(
                    isFromDialog ? CupertinoIcons.chevron_down : Icons.menu,
                    size: 20,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
