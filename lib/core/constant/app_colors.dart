import 'package:flutter/material.dart' show Color, Colors;

/// The class [AppColors] provides a set of predefined color constants used within the app.

///
/// Example usage:
///
/// ```dart
/// import 'package:flutter/material.dart';
/// import 'package:your_app_name/app_colors.dart';
///
/// Container(
///   width: 200,
///   height: 50,
///   color: AppColors.blue,
///   child: Center(
///     child: Text(
///       'Button',
///       style: TextStyle(
///         fontSize: 16,
///         fontWeight: FontWeight.bold,
///         color: AppColors.white,
///       ),
///     ),
///   ),
/// ),
/// ```
///

abstract final class AppColors {
  /// Hard color codes
  static const Color blue = Color(0xff1F5B8C);
  static const Color secondaryBlue = Color(0xff2772AF);
  static const Color black = Color(0xff000000);
  static const Color white = Colors.white;
  static const Color lightgrey = Color(0xffE7E7E7);
  static const Color darkOrage = Color(0xffDC9C9C);
  static const Color lightYello = Color(0xff9FA4D3);
  static const Color lightBlue = Color(0xffD7B6A8);
  static const Color lightOrage = Color(0xffE3A6A6);
  static const Color hintTextColor = Color(0xffE3A6A6);
  static const Color dividerColor = Color.fromRGBO(242, 242, 242, 1);
  static const Color bottomBarIconGreyColor = Color(0xff7A7A7A);
  static const Color backgroundColor = Color(0xffEFF2F4);
  static const Color textfieldBorderColor = Color(0xffE4E4E4);
  static const Color green = Color(0xff249968);
  static const Color darkGreen = Color(0xff178355);
  static const Color red = Color(0xffCC3D3D);
  static const Color dividerGreyColor = Color(0XFFDEDEDE);
  static const Color textBoxShadowColor = Color(0XFF000020);
  static const Color darkBlue = Color(0XFF19507C);
  static const Color dialogBlue = Color(0XFF14446A);
  static const Color skyBlue = Color(0XFF49AAF8);
  static const Color grey = Color(0XFF767676);
  static const Color textfieldDisableColor = Color(0xffEDEDED);
  static const Color cardColor = Color(0xffF8FAFA);
  static const Color blackColor = Color(0xff282828);
  static const Color blueTextColor = Color(0xffD9EEFF);
  static const Color blueLightTextColor = Color(0xff8ABCE5);
  static const Color darkTextColor = Color(0xff1F2326);
  static const Color greyTextColor = Color(0xffDCE1E5);
  static const Color greyColor = Color(0xffCCD3D9);
}
