import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_images.dart';
import 'package:sb_mobile/core/constant/app_strings.dart';
import 'package:sb_mobile/core/constant/ui_constant.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';

class SearchWidget extends StatelessWidget {
  final VoidCallback onTap;
  const SearchWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 102,
        margin: const EdgeInsets.symmetric(
          vertical: 5,
        ),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.blue,
              Color(0xff3D8CCC),
              Color(0xff3D8CCC),
              Color(0xff3D8CCC),
              AppColors.blue,
              // AppColors.darkOrage,
              // AppColors.lightBlue,
              // AppColors.lightYello,
              // AppColors.lightOrage,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppStrings.searchText,
              style: textTheme.bodyLarge?.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SpaceVertical(8),
            Center(
              child: Container(
                height: 45.0,
                padding:
                    const EdgeInsets.symmetric(horizontal: 00.0, vertical: 0.0),
                margin: const EdgeInsets.symmetric(
                  horizontal: defaultPadding,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(
                    color: const Color(0XFF909090),
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: IntrinsicWidth(
                    child: Theme(
                      data: ThemeData(),
                      child: IgnorePointer(
                        child: TextFormField(
                          textAlignVertical: TextAlignVertical.center,
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                          onTap: onTap,
                          decoration: InputDecoration(
                            isCollapsed: true,
                            prefixIcon: SvgPicture.asset(
                              AppImages.search,
                              width: 17,
                              height: 17,
                              colorFilter: const ColorFilter.mode(
                                AppColors.blue,
                                BlendMode.srcIn,
                              ),
                            ),
                            prefixIconConstraints: const BoxConstraints(
                              minWidth: 25,
                              minHeight: 15,
                            ),
                            hintText: AppStrings.searchHintText,
                            hintStyle: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w400,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
