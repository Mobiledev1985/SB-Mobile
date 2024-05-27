import 'package:flutter/material.dart';

Color hexToColor(String code) {
  return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

class AppStyles {
  final sbBlue = hexToColor("#1F5B8C");
  final darkSbBlue = hexToColor("#1e5295");
  final sbBrown = hexToColor("#432912");
  final sbMidGrey = hexToColor("#bebebe");
  final sbWhite = hexToColor("#ffffff");
  final sbGreen = hexToColor("#3cb371");
  final sbDarkGreen = hexToColor("#2e8b57");
  final sbDarkBlue = hexToColor("#1E5295");
  final sbGrey = hexToColor("#e6e6e6");
  final sbDropShadow = hexToColor("#969696");
  final passwordTextColor = hexToColor("#676767");
  final searchRefreshColor = hexToColor("#2772AF");

  late BorderRadius borderRadius10;
  late BorderRadius borderRadius20;

  late BoxDecoration boxDecoration10Black;

  late BoxDecoration boxDecoration10White;

  late TextStyle mediumFontBlackTextStyle;
  late TextStyle mediumFontWhiteTextStyle;
  late TextStyle mediumStrongWhiteTextStyle;
  late ButtonStyle bookableButtonStyle;

  late TextStyle smallFontWhiteTextStyle;

  late TextStyle fisherySearchResultCardName;

  late EdgeInsets zeroContainerMargin;

  late TextStyle filterIconTextStyle;
  late TextStyle mediumButtonWhiteStyle;
  late TextStyle mediumButtonBlackStyle;
  late String fontGilroy = 'sb_gilroy';
  late String fontRadomir = 'sb_radomir';

  AppStyles() {
    borderRadius10 = BorderRadius.circular(10.0);
    borderRadius20 = BorderRadius.circular(20.0);

    boxDecoration10Black = BoxDecoration(borderRadius: borderRadius20);

    mediumFontBlackTextStyle = TextStyle(
        fontSize: 12.0,
        fontFamily: fontGilroy,
        // color: hexToColor("#2772AF")
        fontWeight: FontWeight.w600,
        color: Colors.black);

    fisherySearchResultCardName = TextStyle(
        fontSize: 14.0,
        fontFamily: fontGilroy,
        color: Colors.black,
        fontWeight: FontWeight.w600);

    smallFontWhiteTextStyle =
        TextStyle(fontSize: 9.0, fontFamily: fontGilroy, color: Colors.white);

    mediumFontWhiteTextStyle = TextStyle(
        fontSize: 12.0,
        fontFamily: fontGilroy,
        color: Colors.white,
        fontWeight: FontWeight.w600);

    mediumStrongWhiteTextStyle = TextStyle(
        fontSize: 11.0,
        fontFamily: fontGilroy,
        color: Colors.white,
        fontWeight: FontWeight.w600);

    bookableButtonStyle = TextButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: sbBlue,
      disabledForegroundColor: Colors.grey.withOpacity(0.38),
    );

    zeroContainerMargin = const EdgeInsets.all(0.0);

    boxDecoration10White = BoxDecoration(
        borderRadius: BorderRadius.circular(10.0), color: Colors.white);

    filterIconTextStyle = TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
        fontFamily: fontGilroy,
        color: Colors.black);

    mediumButtonWhiteStyle = TextStyle(
        fontSize: 15.0,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.italic,
        fontFamily: fontGilroy,
        color: Colors.white);

    mediumButtonBlackStyle = TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
        fontFamily: fontGilroy,
        color: Colors.black);
  }
}
