import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:sb_mobile/core/constant/app_strings.dart';

class MapWidget extends StatelessWidget {
  final ValueNotifier selectedBottomBarItem;

  const MapWidget({super.key, required this.selectedBottomBarItem});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: TextButton(
        onPressed: () {
          if (Platform.isAndroid) {
            SystemChrome.setSystemUIOverlayStyle(
              const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness.dark),
            );
          } else {
            FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
            FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
          }
          selectedBottomBarItem.value = 1;
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SvgPicture.asset(
            //   AppImages.mapIcon,
            //   width: 22,
            //   height: 22,
            // ),
            // const SpaceHorizontal(6),
            Text(
              AppStrings.viewOnMap,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
            )
          ],
        ),
      ),
    );
  }
}
