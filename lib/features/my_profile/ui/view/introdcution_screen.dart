import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:sb_mobile/core/config/authenticator.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_images.dart';
import 'package:sb_mobile/features/home_page/ui/views/bottom_bar_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroductionScreens extends StatefulWidget {
  const IntroductionScreens({Key? key}) : super(key: key);

  @override
  IntroductionScreensState createState() => IntroductionScreensState();
}

class IntroductionScreensState extends State<IntroductionScreens> {
  final introKey = GlobalKey<IntroductionScreenState>();

  Future<void> _onIntroEnd(context) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(isFirstTimeKey, false);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const BottomBarScreen()),
    );
  }

  late final Future<LottieComposition> _composition;
  late final Future<LottieComposition> _composition2;
  @override
  void initState() {
    super.initState();

    _composition = AssetLottie(AppImages.fisheries).load();
    _composition2 = AssetLottie(AppImages.mysb).load();
  }

  @override
  Widget build(BuildContext context) {
    const pageDecoration = PageDecoration(
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      imagePadding: EdgeInsets.only(top: 10),
      titlePadding: EdgeInsets.only(
        bottom: 20,
        top: 30,
      ),
      bodyAlignment: Alignment.center,
      imageAlignment: Alignment.bottomCenter,
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
          titleWidget: Text.rich(
            TextSpan(
              text: 'Welcome to the\n',
              children: [
                TextSpan(
                  text: 'swimbooker',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: AppColors.blue,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                TextSpan(
                  text: ' app',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: AppColors.black,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: AppColors.black,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            textAlign: TextAlign.center,
          ),
          bodyWidget: Text.rich(
            TextSpan(
              text: 'Angler! ',
              children: [
                TextSpan(
                  text:
                      ' This is the one place to find venues, book fishing and keep track of your angling over time!',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppColors.black,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            textAlign: TextAlign.center,
          ),
          image: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                AppImages.swimbooker,
              ),
            ),
          ),
          decoration: pageDecoration.copyWith(),
        ),
        PageViewModel(
          titleWidget: Text.rich(
            TextSpan(
              text: 'New ',
              children: [
                TextSpan(
                  text: 'fisheries\n',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: AppColors.blue,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                TextSpan(
                  text: 'every week!',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: AppColors.black,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: AppColors.black,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            textAlign: TextAlign.center,
          ),
          bodyWidget: Text(
            'We’re constantly working to bring new fisheries to the platform; allowing you to book directly from our app.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          image: FutureBuilder<LottieComposition>(
            future: _composition,
            builder: (context, snapshot) {
              var composition = snapshot.data;
              if (composition != null) {
                return Lottie(
                  composition: composition,
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.blue,
                  ),
                );
              }
            },
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          titleWidget: Text.rich(
            TextSpan(
              text: 'My SB ',
              children: [
                TextSpan(
                  text: '- Your\n Personal Hub',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: AppColors.black,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: AppColors.blue,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            textAlign: TextAlign.center,
          ),
          bodyWidget: Text.rich(
            TextSpan(
              text: 'Your centralised angling experience! ',
              children: [
                TextSpan(
                  text:
                      ' Upload your catches, track your angling statistics and mark your favourite venues! ',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppColors.black,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            textAlign: TextAlign.center,
          ),
          image: FutureBuilder<LottieComposition>(
            future: _composition2,
            builder: (context, snapshot) {
              var composition = snapshot.data;
              if (composition != null) {
                return Lottie(
                  composition: composition,
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.blue,
                  ),
                );
              }
            },
          ),
          decoration: pageDecoration.copyWith(
            imagePadding: const EdgeInsets.only(
              top: 40,
            ),
          ),
        ),
        PageViewModel(
          titleWidget: Text.rich(
            TextSpan(
              text: 'Make sure to\n',
              children: [
                TextSpan(
                  text: 'enable',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: AppColors.blue,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                TextSpan(
                  text: ' notifications',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: AppColors.black,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: AppColors.black,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            textAlign: TextAlign.center,
          ),
          bodyWidget: Text(
            'We’ll  ping you about new bookable fisheries, exciting news and updates regarding your account.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          image: Lottie.asset(
            AppImages.notificationGIF,
            width: 280,
            fit: BoxFit.cover,
          ),
          decoration: pageDecoration.copyWith(
            imagePadding: EdgeInsets.zero,
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
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
