import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_strings.dart';
import 'package:sb_mobile/core/constant/ui_constant.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';
import 'package:sb_mobile/features/authentication/data/models/angler_profile_details_model.dart';
import 'package:sb_mobile/features/exclusiveMedia/ui/view/exclusive_media_common_screen.dart';
import 'package:sb_mobile/features/home_page/data/models/home_model.dart';
import 'package:sb_mobile/features/home_page/ui/views/bottom_bar_provider.dart';

class ExclusiveMedia extends StatelessWidget {
  final List<Exclusive> exclusiveList;
  final AnglerProfile? profile;
  const ExclusiveMedia(
      {super.key, required this.exclusiveList, required this.profile});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Text.rich(
          TextSpan(
            text: AppStrings.swim,
            style: textTheme.headlineSmall?.copyWith(
              color: AppColors.blue,
              fontWeight: FontWeight.w600,
            ),
            children: [
              TextSpan(
                text: AppStrings.exclusiveMedia,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          primary: false,
          // scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(
              top: 15, left: defaultPadding, right: defaultPadding),
          itemCount: exclusiveList.length,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            mainAxisExtent: 120,
          ),
          itemBuilder: (context, index) {
            final Exclusive exclusive = exclusiveList[index];
            return Stack(
              children: [
                ShaderMask(
                  blendMode: BlendMode.srcATop,
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      colors: [
                        Color.fromRGBO(39, 114, 175, 0),
                        Color.fromRGBO(44, 44, 44, 1)
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ).createShader(bounds);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(defaultBorderRadius),
                    child: Image.asset(
                      exclusive.backgroundImage,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        exclusive.name == "SB Diaries"
                            ? Image.asset(
                                exclusive.icon,
                                width: 64,
                                height: 48,
                                fit: BoxFit.contain,
                              )
                            : SvgPicture.asset(
                                exclusive.icon,
                                width: 64,
                                height: 48,
                                fit: BoxFit.contain,
                              ),
                        const SpaceVertical(6),
                        Text(
                          exclusive.name,
                          style: textTheme.bodyLarge!.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Material(
                    type: MaterialType.transparency,
                    child: InkWell(
                      customBorder: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(defaultBorderRadius),
                      ),
                      onTap: () {
                        if (exclusive.name == "Angling Social") {
                          final selectedBottomBarItem =
                              BottomBarProvider.of(context)
                                  .selectedBottomBarItem;
                          selectedBottomBarItem.value = 3;
                        } else {
                          ExclusiveMediaCommonScreen.navigateTo(
                            context,
                            (
                              text: exclusive.name,
                              image: exclusive.icon,
                              apiEndPoint: exclusive.apiEndpoint!,
                              profile: profile,
                              isFromHomeScreen: false
                            ),
                          );
                        }
                      },
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ],
    );
  }
}
