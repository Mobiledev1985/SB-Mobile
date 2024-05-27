import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';

import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/routes/route_paths.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';
import 'package:sb_mobile/features/authentication/providers/subscription_provider.dart';
import 'package:sb_mobile/features/authentication/ui/widgets/incredible_lakes_and_offers.dart';
import 'package:sb_mobile/features/authentication/ui/widgets/incredible_value_packed.dart';
import 'package:sb_mobile/features/authentication/ui/widgets/plan_section.dart';
import 'package:sb_mobile/features/authentication/ui/widgets/sb_plus_features.dart';
import 'package:sb_mobile/features/authentication/ui/widgets/sb_plus_top_section.dart';
import 'package:sb_mobile/features/authentication/ui/widgets/sb_questions.dart';
import 'package:sb_mobile/features/authentication/ui/widgets/what_is_swimbooker_plus.dart';
import 'package:sb_mobile/features/my_profile/ui/view/subscription/insurance/pdf_screen.dart';

typedef SubscriptionData = ({String email, bool isLoggedIn});

class SbPlusPurchaseScreen extends StatefulWidget {
  const SbPlusPurchaseScreen({super.key, required this.subscriptionData});

  final SubscriptionData subscriptionData;

  @override
  State<SbPlusPurchaseScreen> createState() => _SbPlusPurchaseScreenState();

  static MaterialPageRoute<dynamic> buildRouter(
      SubscriptionData subscriptionData) {
    return MaterialPageRoute(
      builder: (context) => SbPlusPurchaseScreen(
        subscriptionData: subscriptionData,
      ),
    );
  }

  static Future<void> navigateTo(
      BuildContext context, SubscriptionData subscriptionData) async {
    await Navigator.pushNamed(
      context,
      RoutePaths.sbPlusPurchaseScreen,
      arguments: subscriptionData,
    );
  }
}

class _SbPlusPurchaseScreenState extends State<SbPlusPurchaseScreen> {
  final GlobalKey features = GlobalKey();
  final GlobalKey incredibleValuePacked = GlobalKey();
  final GlobalKey duration = GlobalKey();
  late SubscriptionProvider subscriptionProvider;
  String termAndConditionPath = "";
  String privacyPolicy = "";
  final ValueNotifier<bool> isMonthly = ValueNotifier(true);
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    subscriptionProvider = context.read<SubscriptionProvider>();
    subscriptionProvider.isFromBanner = true;

    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          // statusBarColor: AppColors.darkTextColor,
          // statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      );
    } else {
      FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
      FlutterStatusbarcolor.setStatusBarColor(
        // AppColors.darkTextColor,
        Colors.transparent,
      );
    }
    subscriptionProvider.onInit(context);
    fromAsset('assets/pdf/t&c.pdf', 't&c.pdf').then((f) {
      setState(() {
        termAndConditionPath = f.path;
      });
    });
    fromAsset('assets/pdf/privacy_policy.pdf', 'privacy_policy.pdf').then((f) {
      setState(() {
        privacyPolicy = f.path;
      });
    });
  }

  Future<File> fromAsset(String asset, String filename) async {
    // To open from assets, you can copy them to the app storage folder, and the access them "locally"
    Completer<File> completer = Completer();

    try {
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  @override
  void dispose() {
    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
        ),
      );
    } else {
      FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
      FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    }
    isMonthly.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.darkTextColor,
      body: SingleChildScrollView(
        // padding: EdgeInsets.only(top: context.mediaQuery.padding.top),
        controller: _scrollController,
        child: Column(
          children: [
            SpaceVertical(
              context.mediaQuery.padding.top - 10,
            ),
            SBPlusTopSection(
              onJoinTheClub: () {
                Scrollable.ensureVisible(
                  duration.currentContext!,
                  duration: const Duration(milliseconds: 500),
                );
              },
              onCompareFeature: () {
                Scrollable.ensureVisible(
                  features.currentContext!,
                  duration: const Duration(milliseconds: 500),
                );
              },
            ),
            const WhatIsSwimbookerPlus(),
            IncredibleLakesAndOffer(
              features: features,
            ),
            const SpaceVertical(34),
            SBPlusFeatures(
              onFeature: () {
                Scrollable.ensureVisible(
                  incredibleValuePacked.currentContext!,
                  duration: const Duration(milliseconds: 500),
                );
              },
            ),
            SpaceVertical(key: incredibleValuePacked, 50),
            const IncredibleValuePacked(),
            PlanSection(
              duration: duration,
              isLoggedIn: widget.subscriptionData.isLoggedIn,
              email: widget.subscriptionData.email,
            ),
            const SpaceVertical(50),
            const SBQuestions(),
            const SpaceVertical(24),
            Text(
              'Copyright © SWIMBOOKER LIMITED 2024',
              style: context.textTheme.bodySmall?.copyWith(
                color: const Color(0xffA1AAB2),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SpaceVertical(12),
            GestureDetector(
              onTap: () {
                if (termAndConditionPath.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PdfScreen(filePath: termAndConditionPath),
                    ),
                  );
                }
              },
              child: Text(
                'Terms & Conditions',
                style: context.textTheme.bodySmall?.copyWith(
                  color: const Color(0xffA1AAB2),
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SpaceVertical(12),
            GestureDetector(
              onTap: () {
                if (privacyPolicy.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PdfScreen(filePath: privacyPolicy),
                    ),
                  );
                }
              },
              child: Text(
                'Privacy Policy',
                style: context.textTheme.bodySmall?.copyWith(
                  color: const Color(0xffA1AAB2),
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SpaceVertical(50),
          ],
        ),
      ),
    );
  }
}

class TierDuration extends StatelessWidget {
  const TierDuration({
    super.key,
    required this.isMonthly,
    required this.onTap,
    required this.text,
  });

  final String text;
  final bool isMonthly;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 96,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isMonthly ? AppColors.secondaryBlue : null,
          border: isMonthly
              ? Border.all(
                  color: const Color(0xffE2E2E2),
                )
              : null,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: context.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: isMonthly ? AppColors.white : const Color(0xff737A80),
          ),
        ),
      ),
    );
  }
}
