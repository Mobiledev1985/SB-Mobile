import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/routes/route_paths.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';
import 'package:sb_mobile/features/home_page/ui/views/bottom_bar_provider.dart';
import 'package:sb_mobile/features/home_page/ui/views/bottom_bar_screen.dart';

class SBIntroductionScreen extends StatefulWidget {
  const SBIntroductionScreen({super.key});

  @override
  State<SBIntroductionScreen> createState() => _SBIntroductionScreenState();

  static MaterialPageRoute<dynamic> buildRouter() {
    return MaterialPageRoute(
      builder: (context) => const SBIntroductionScreen(),
    );
  }

  static void navigateTo(BuildContext context) {
    Navigator.pushReplacementNamed(
      context,
      RoutePaths.sbIntroductionScreen,
    );
  }
}

class _SBIntroductionScreenState extends State<SBIntroductionScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      );
    } else {
      FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
      FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    }
  }

  Future<void> _onIntroEnd(context) async {
    BottomBarProvider.of(context).selectedBottomBarItem.value = 2;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const BottomBarScreen(),
      ),
      (route) => false,
    );
  }

  Widget getImage(int index) {
    return Image.asset(
      'assets/images/sb_slider_$index.png',
      fit: BoxFit.fill,
      width: index == 1 ? null : double.infinity,
    );
  }

  @override
  Widget build(BuildContext context) {
    const pageDecoration = PageDecoration(
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
      imagePadding: EdgeInsets.only(top: 10),
      titlePadding: EdgeInsets.zero,
      imageFlex: 5,
      bodyFlex: 1,
      footerPadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      globalFooter: const SizedBox(
        width: double.infinity,
        height: 8,
      ),
      bodyPadding: EdgeInsets.only(
        top: MediaQuery.sizeOf(context).height * 0.05,
      ),
      pages: [
        PageViewModel(
          titleWidget: const SizedBox.shrink(),
          bodyWidget: Text(
            'swimbooker+ | Angling. Evolved. With your new swimbooker+ membership you’ve unlocked a world of benefits. Let’s take a look at a few...',
            style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          image: getImage(1),
          decoration: pageDecoration.copyWith(),
        ),
        PageViewModel(
          titleWidget: const SizedBox.shrink(),
          bodyWidget: Column(
            children: [
              Text.rich(
                TextSpan(
                  text: 'Insurance -',
                  children: [
                    TextSpan(
                      text:
                          ' All of your policy documents and claim support for accidents or equipment damage in one place.',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                    ),
                  ],
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                textAlign: TextAlign.start,
              ),
              const SpaceVertical(10),
              Text.rich(
                TextSpan(
                  text: 'Wallet - ',
                  children: [
                    TextSpan(
                      text:
                          ' Your digital angling wallet! Earn cashback directly into your SB wallet.',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                    ),
                  ],
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                textAlign: TextAlign.start,
              ),
            ],
          ),
          image: getImage(2),
          decoration: pageDecoration.copyWith(
            imageFlex: 3,
            bodyFlex: 1,
          ),
        ),
        PageViewModel(
          titleWidget: const SizedBox.shrink(),
          bodyWidget: Column(
            children: [
              Text.rich(
                TextSpan(
                  text: 'Giveaways - ',
                  children: [
                    TextSpan(
                      text:
                          ' To enter each weekly giveaway, simply answer the question via your SB angler profile.',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                    ),
                  ],
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                textAlign: TextAlign.start,
              ),
              const SpaceVertical(10),
              Text.rich(
                TextSpan(
                  text: 'Perks - ',
                  children: [
                    TextSpan(
                      text:
                          ' Gain access to exclusive perks & discounts from brands & fisheries.',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                    ),
                  ],
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                textAlign: TextAlign.start,
              ),
            ],
          ),
          image: getImage(3),
          decoration: pageDecoration.copyWith(
            imageFlex: 3,
            bodyFlex: 1,
          ),
        ),
        PageViewModel(
          titleWidget: const SizedBox.shrink(),
          bodyWidget: Column(
            children: [
              Text.rich(
                TextSpan(
                  text: 'InSession - ',
                  children: [
                    TextSpan(
                      text:
                          ' Access to your new digital session tool. Save notes, log catches and find local food.',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                    ),
                  ],
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                textAlign: TextAlign.start,
              ),
              const SpaceVertical(20),
              Text.rich(
                TextSpan(
                  text: 'Your new ',
                  children: [
                    TextSpan(
                      text: 'angling ',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.blue,
                          ),
                    ),
                    const TextSpan(
                      text: 'experience awaits...',
                    ),
                  ],
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                textAlign: TextAlign.center,
              ),
              const SpaceVertical(10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff062640),
                ),
                onPressed: () {
                  _onIntroEnd(context);
                },
                child: Text(
                  'Explore swimbooker+',
                  style: context.textTheme.headlineMedium?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
          image: getImage(4),
          decoration: pageDecoration.copyWith(
            imageFlex: 3,
            bodyFlex: 1,
          ),
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context),
      showSkipButton: true,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: false,
      back: const Icon(
        Icons.arrow_back,
        color: AppColors.black,
      ),
      skip: const Text(
        'Skip',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.black,
        ),
      ),
      next: const Icon(
        Icons.arrow_forward,
        color: AppColors.black,
      ),
      done: const Text(
        'Done',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.black,
        ),
      ),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(25.0),
          ),
        ),
      ),
    );
  }
}
