import 'package:flutter/material.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';

class Background extends StatelessWidget {
  const Background({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.blue,
                  Color(0xFF1B4C74),
                ],
              ),
            ),
          ),
          child
        ],
      ),
    );
  }
}
