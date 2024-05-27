import 'package:flutter/material.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/ui_constant.dart';

// Global theme
mixin AppThemeMixin {
  ThemeData appTheme(BuildContext context) => ThemeData(
        useMaterial3: false,
        appBarTheme: const AppBarTheme(
          actionsIconTheme: IconThemeData(color: Colors.black),
          // iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: AppColors.black,
            fontSize: 20,
            fontFamily: 'sb_gilroy',
            fontWeight: FontWeight.w500,
          ),
          elevation: 0,
        ),
        // scaffoldBackgroundColor: AppColors.backgroundColor,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            elevation: const MaterialStatePropertyAll(0),
            minimumSize: const MaterialStatePropertyAll<Size>(
              Size(double.infinity, 42),
            ),
            alignment: Alignment.center,
            textStyle: const MaterialStatePropertyAll(
              TextStyle(
                color: Colors.white,
                fontFamily: 'Gilroy',
                fontSize: 18,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w600,
                height: 1.0,
              ),
            ),
            backgroundColor: MaterialStateProperty.all(AppColors.blue),
            shape: const MaterialStatePropertyAll<OutlinedBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(defaultButtonRadius),
                ),
              ),
            ),
          ),
        ),
        cardTheme: const CardTheme(elevation: 0.0, margin: EdgeInsets.zero),
        fontFamily: 'sb_gilroy',
        textTheme: const TextTheme(
          bodySmall: TextStyle(color: AppColors.black, fontSize: 12),
          bodyMedium: TextStyle(color: AppColors.black, fontSize: 14),
          bodyLarge: TextStyle(color: AppColors.black, fontSize: 16),
          headlineSmall: TextStyle(color: AppColors.black, fontSize: 18),
          headlineMedium: TextStyle(color: AppColors.black, fontSize: 20),
          displaySmall: TextStyle(color: AppColors.black, fontSize: 22),
          displayMedium: TextStyle(color: AppColors.black, fontSize: 24),
          displayLarge: TextStyle(color: AppColors.black, fontSize: 26),
        ),
        inputDecorationTheme: InputDecorationTheme(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 12,
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0xffE4E4E4),
            ),
            borderRadius: BorderRadius.circular(
              4,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0xffE4E4E4),
            ),
            borderRadius: BorderRadius.circular(
              4,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0xffE4E4E4),
            ),
            borderRadius: BorderRadius.circular(
              4,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0xffE4E4E4),
            ),
            borderRadius: BorderRadius.circular(
              4,
            ),
          ),
          hintStyle: const TextStyle(
            color: Color(0xff787878),
            fontWeight: FontWeight.w300,
            fontStyle: FontStyle.normal,
            fontSize: 14,
          ),
        ),
      );
}
