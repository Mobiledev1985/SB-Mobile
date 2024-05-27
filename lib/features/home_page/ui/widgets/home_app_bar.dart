import 'package:flutter/material.dart';
import 'package:sb_mobile/core/constant/ui_constant.dart';
import 'package:sb_mobile/features/authentication/data/models/angler_profile_details_model.dart';
import 'package:sb_mobile/features/home_page/ui/widgets/common_bar.dart';

class HomeAppBar extends StatelessWidget {
  final AnglerProfile? profile;
  final bool isExclusiveMediaScreen;
  final bool isFromBottomBar360;
  const HomeAppBar({
    super.key,
    this.profile,
    required this.isExclusiveMediaScreen,
    required this.isFromBottomBar360,
  });

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.viewPaddingOf(context).top;

    return SizedBox(
      width: double.infinity,
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(defaultBorderRadius),
            bottomRight: Radius.circular(defaultBorderRadius),
          ),
        ),
        margin: EdgeInsets.zero,
        child: CommonBar(
          topPadding: topPadding,
          isFromDialog: false,
          anglerProfile: profile,
          isExclusiveMediaScreen: isExclusiveMediaScreen,
          isFromBottomBar360: isFromBottomBar360,
        ),
      ),
    );
  }
}
