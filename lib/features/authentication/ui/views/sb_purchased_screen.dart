import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_images.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/routes/route_paths.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';
import 'package:sb_mobile/features/authentication/ui/views/background.dart';
import 'package:sb_mobile/features/authentication/ui/views/sb_introduction_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class SBPurchasedScreen extends StatefulWidget {
  const SBPurchasedScreen({super.key, required this.subscriptionLevel});

  final String subscriptionLevel;

  static MaterialPageRoute<dynamic> buildRouter(String subscriptionLevel) {
    return MaterialPageRoute(
      builder: (context) => SBPurchasedScreen(
        subscriptionLevel: subscriptionLevel,
      ),
    );
  }

  static void navigateTo(BuildContext context, String subscriptionLevel) {
    Navigator.pushNamedAndRemoveUntil(context, RoutePaths.subscriptionPurchased,
        (Route<dynamic> route) => false,
        arguments: subscriptionLevel);
  }

  @override
  State<SBPurchasedScreen> createState() => _SBPurchasedScreenState();
}

class _SBPurchasedScreenState extends State<SBPurchasedScreen> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: AppColors.blue,
          statusBarIconBrightness: Brightness.light,
        ),
      );
    } else {
      FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
      FlutterStatusbarcolor.setStatusBarColor(AppColors.blue);
    }
  }

  @override
  void dispose() {
    // if (Platform.isAndroid) {
    //   SystemChrome.setSystemUIOverlayStyle(
    //     const SystemUiOverlayStyle(
    //         statusBarColor: Colors.white,
    //         statusBarIconBrightness: Brightness.dark),
    //   );
    // } else {
    //   FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    //   FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    // }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Align(
              //   alignment: Alignment.topLeft,
              //   child: Container(
              //     decoration: BoxDecoration(
              //       shape: BoxShape.circle,
              //       border: Border.all(
              //         color: AppColors.dividerGreyColor,
              //       ),
              //     ),
              //     child: GestureDetector(
              //       onTap: () {
              //         Navigator.pop(context);
              //       },
              //       child: const CircleAvatar(
              //         radius: 20,
              //         backgroundColor: AppColors.white,
              //         child: Align(
              //           alignment: Alignment(0.6, 0.0),
              //           child: Icon(
              //             Icons.arrow_back_ios,
              //             color: AppColors.blue,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),

              Stack(
                children: [
                  Image.asset(
                    AppImages.animationImage,
                  ),
                  Positioned(
                    right: 80,
                    left: 80,
                    bottom: 0,
                    child: SizedBox(
                      height: 32,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: 70,
                              height: 30,
                              child: Image.asset(
                                'assets/icons/fish.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Transform(
                              transform: Matrix4.translationValues(0, -12, 0),
                              child: Text(
                                '+',
                                style: context.textTheme.displayLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              const SpaceVertical(36),
              Text(
                'CONGRATULATIONS! \nYOU ARE NOW A \n${widget.subscriptionLevel}\nMEMBER!',
                style: context.textTheme.displayLarge?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SpaceVertical(24),
              Text(
                'Make sure to join the official Facebook group for regular updates & announcements.',
                style: context.textTheme.headlineMedium?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SpaceVertical(24),
              ElevatedButton(
                onPressed: () async {
                  try {
                    if (await launchUrl(Uri.parse(
                        'https://www.facebook.com/groups/swimbookerplus'))) {
                    } else {
                      throw Exception('Could not launch ');
                    }
                  } catch (e) {
                    // print('Error launching URL: $e');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff008DFF),
                ),
                child: Text(
                  'Join Exclusive SB+ Facebook Group',
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SpaceVertical(12),
              ElevatedButton(
                onPressed: () {
                  SBIntroductionScreen.navigateTo(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.black,
                ),
                child: Text(
                  'Go To Swimbooker Profile',
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
