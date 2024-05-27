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
import 'package:sb_mobile/features/authentication/ui/widgets/subscription_plan_card.dart';
import 'package:sb_mobile/features/authentication/ui/widgets/what_you_get.dart';
import 'package:sb_mobile/features/home_page/ui/views/bottom_bar_provider.dart';
import 'package:sb_mobile/features/home_page/ui/views/bottom_bar_screen.dart';
import 'package:sb_mobile/features/my_profile/ui/view/subscription/insurance/pdf_screen.dart';

typedef TierSectionData = ({String email, bool isFromFeatureScreen});

class TierSectionScreen extends StatefulWidget {
  final TierSectionData tierSectionData;
  const TierSectionScreen({
    super.key,
    required this.tierSectionData,
  });

  static MaterialPageRoute<dynamic> buildRouter(
      TierSectionData tierSectionData) {
    return MaterialPageRoute(
      builder: (context) => TierSectionScreen(
        tierSectionData: tierSectionData,
      ),
    );
  }

  static void navigateTo(BuildContext context, TierSectionData tierSectionData,
      bool isFromAuthScreens) {
    if (isFromAuthScreens) {
      Navigator.pushReplacementNamed(
        context,
        RoutePaths.tierSectionScreen,
        arguments: tierSectionData,
      );
    } else {
      Navigator.pushNamed(
        context,
        RoutePaths.tierSectionScreen,
        arguments: tierSectionData,
      );
    }
  }

  @override
  State<TierSectionScreen> createState() => _TierSectionScreenState();
}

class _TierSectionScreenState extends State<TierSectionScreen> {
  late SubscriptionProvider subscriptionProvider;
  String termAndConditionPath = "";
  String privacyPolicy = "";
  final ValueNotifier<bool> isMonthly = ValueNotifier(true);

  @override
  void initState() {
    subscriptionProvider = context.read<SubscriptionProvider>();
    if (subscriptionProvider.isFromBanner) {
      if (Platform.isAndroid) {
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
              statusBarColor: Color(0xffF2F2F2),
              statusBarIconBrightness: Brightness.dark),
        );
      } else {
        FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
        FlutterStatusbarcolor.setStatusBarColor(
          const Color(0xffF2F2F2),
        );
      }
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
    super.initState();
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
    if (subscriptionProvider.isFromBanner) {
      if (Platform.isAndroid) {
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light),
        );
      } else {
        FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
        FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
      }
    }
    isMonthly.dispose();
    subscriptionProvider.onDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SpaceVertical(20 + MediaQuery.paddingOf(context).top),
            SizedBox(
              height: 40,
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    left: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          if (widget.tierSectionData.isFromFeatureScreen) {
                            Navigator.pop(context);
                          } else {
                            BottomBarProvider.of(context)
                                .selectedBottomBarItem
                                .value = 0;
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const BottomBarScreen(),
                                ),
                                (route) => false);
                          }
                        },
                        child: const CircleAvatar(
                          radius: 16,
                          backgroundColor: AppColors.black,
                          child: Align(
                            alignment: Alignment(0.99, 0.0),
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'Choose Your Package',
                    style: context.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Consumer<SubscriptionProvider>(
              builder: (context, planProvider, _) {
                return planProvider.loading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.blue,
                        ),
                      )
                    : !planProvider.isAvailable
                        ? const Center(
                            child: Text('Not connected..'),
                          )
                        : Column(
                            children: [
                              const SpaceVertical(20),
                              IntrinsicWidth(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    border: Border.all(
                                      color: const Color(0xffE2E2E2),
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: ValueListenableBuilder(
                                    valueListenable: isMonthly,
                                    builder: (context, isSelected, _) {
                                      return Row(
                                        children: [
                                          TierDuration(
                                            isMonthly: isSelected,
                                            onTap: planProvider.purchasePending
                                                ? null
                                                : () {
                                                    isMonthly.value =
                                                        !isMonthly.value;
                                                  },
                                            text: 'Monthly',
                                          ),
                                          TierDuration(
                                            isMonthly: !isSelected,
                                            onTap: planProvider.purchasePending
                                                ? null
                                                : () {
                                                    isMonthly.value =
                                                        !isMonthly.value;
                                                  },
                                            text: 'Annual',
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SpaceVertical(16),
                              ValueListenableBuilder(
                                valueListenable: isMonthly,
                                builder: (context, isMonthly, _) {
                                  return Consumer<SubscriptionProvider>(
                                    builder: (context, provider, _) {
                                      return Column(
                                        children: [
                                          // if (!subscriptionProvider
                                          //     .isFromBanner)
                                          //   Card(
                                          //     shape: RoundedRectangleBorder(
                                          //       borderRadius:
                                          //           BorderRadius.circular(10),
                                          //     ),
                                          //     margin:
                                          //         const EdgeInsets.symmetric(
                                          //       horizontal: 10,
                                          //     ),
                                          //     child: Padding(
                                          //       padding:
                                          //           const EdgeInsets.symmetric(
                                          //               horizontal: 16,
                                          //               vertical: 12.0),
                                          //       child: Column(
                                          //         children: [
                                          //           RichText(
                                          //             text: TextSpan(
                                          //               text: 'swim',
                                          //               style: context.textTheme
                                          //                   .displaySmall
                                          //                   ?.copyWith(
                                          //                 fontWeight:
                                          //                     FontWeight.w600,
                                          //                 color: AppColors.blue,
                                          //               ),
                                          //               children: [
                                          //                 TextSpan(
                                          //                   text:
                                          //                       'booker Basic',
                                          //                   style: context
                                          //                       .textTheme
                                          //                       .displayMedium
                                          //                       ?.copyWith(
                                          //                     fontWeight:
                                          //                         FontWeight
                                          //                             .w600,
                                          //                   ),
                                          //                 ),
                                          //               ],
                                          //             ),
                                          //           ),
                                          //           const SpaceVertical(12),
                                          //           Text(
                                          //             'FREE',
                                          //             style: context.textTheme
                                          //                 .displayMedium
                                          //                 ?.copyWith(
                                          //               fontSize: 36,
                                          //               fontWeight:
                                          //                   FontWeight.w600,
                                          //             ),
                                          //           ),
                                          //           const SpaceVertical(20),
                                          //           Align(
                                          //             alignment:
                                          //                 Alignment.center,
                                          //             child: IntrinsicWidth(
                                          //               child: Column(
                                          //                 children: [
                                          //                   ...[
                                          //                     'Book Fishing Online & In-App',
                                          //                     'Submit & Manage Catch Reports',
                                          //                     'No added booking fees'
                                          //                   ].map(
                                          //                     (e) => Padding(
                                          //                       padding: const EdgeInsets
                                          //                           .symmetric(
                                          //                           vertical:
                                          //                               8.0),
                                          //                       child: Row(
                                          //                         mainAxisAlignment:
                                          //                             MainAxisAlignment
                                          //                                 .start,
                                          //                         children: [
                                          //                           SvgPicture
                                          //                               .asset(
                                          //                             AppImages
                                          //                                 .checked,
                                          //                             width: 15,
                                          //                             height:
                                          //                                 15,
                                          //                           ),
                                          //                           const SpaceHorizontal(
                                          //                               10),
                                          //                           Text(
                                          //                             e,
                                          //                             style: context
                                          //                                 .textTheme
                                          //                                 .bodySmall
                                          //                                 ?.copyWith(
                                          //                               color: const Color(
                                          //                                   0xff757575),
                                          //                               fontWeight:
                                          //                                   FontWeight.w600,
                                          //                             ),
                                          //                           ),
                                          //                         ],
                                          //                       ),
                                          //                     ),
                                          //                   ),
                                          //                 ],
                                          //               ),
                                          //             ),
                                          //           ),
                                          //           const SpaceVertical(12),
                                          //           SizedBox(
                                          //             width: double.infinity,
                                          //             height: 46,
                                          //             child: ElevatedButton(
                                          //               style: ElevatedButton
                                          //                   .styleFrom(
                                          //                 backgroundColor:
                                          //                     AppColors.black,
                                          //               ),
                                          //               onPressed: () {
                                          //                 BottomBarProvider.of(
                                          //                         context)
                                          //                     .selectedBottomBarItem
                                          //                     .value = 2;
                                          //                 Navigator
                                          //                     .pushAndRemoveUntil(
                                          //                         context,
                                          //                         MaterialPageRoute(
                                          //                           builder:
                                          //                               (context) =>
                                          //                                   const BottomBarScreen(),
                                          //                         ),
                                          //                         (route) =>
                                          //                             false);
                                          //               },
                                          //               child: Text(
                                          //                 'Choose Basic',
                                          //                 style: context
                                          //                     .textTheme
                                          //                     .displaySmall
                                          //                     ?.copyWith(
                                          //                   color:
                                          //                       AppColors.white,
                                          //                   fontWeight:
                                          //                       FontWeight.w600,
                                          //                 ),
                                          //               ),
                                          //             ),
                                          //           ),
                                          //           const SpaceVertical(12),
                                          //         ],
                                          //       ),
                                          //     ),
                                          //   ),
                                          // const SpaceVertical(12),
                                          SubcriptionPlanCard(
                                            isPro: true,
                                            isMonthly: isMonthly,
                                            price: isMonthly
                                                ? provider.products
                                                    .firstWhere((element) =>
                                                        element.id ==
                                                        "sb_plus_pro_6.99_1m")
                                                    .price
                                                : provider.products
                                                    .firstWhere((element) =>
                                                        element.id ==
                                                        "sb_plus_pro_59.99_1y")
                                                    .price,
                                            usallyPrice:
                                                isMonthly ? "10.99" : '99.99',
                                            benefits: const [
                                              "Enhanced Insurance Cover",
                                              "Maximum Cashback & Offers",
                                              "Access To Weekly Giveaways"
                                            ],
                                            onTap: () {
                                              planProvider.onPurchasePlan(
                                                isMonthly
                                                    ? 'sb_plus_pro_6.99_1m'
                                                    : 'sb_plus_pro_59.99_1y',
                                                true,
                                                widget.tierSectionData.email,
                                              );
                                            },
                                            isLoading:
                                                planProvider.isProSelect &&
                                                    provider.purchasePending,
                                            isLoggedIn: true,
                                          ),
                                          const SpaceVertical(12),
                                          SubcriptionPlanCard(
                                            isPro: false,
                                            isMonthly: isMonthly,
                                            price: isMonthly
                                                ? provider.products
                                                    .firstWhere((element) =>
                                                        element.id ==
                                                        "sb_plus_4.99_1m")
                                                    .price
                                                : provider.products
                                                    .firstWhere((element) =>
                                                        element.id ==
                                                        "sb_plus_49.99_1y")
                                                    .price,
                                            usallyPrice:
                                                isMonthly ? "6.99" : "69.99",
                                            benefits: const [
                                              "Basic Insurance Cover",
                                              "Standard Cashback & Offers",
                                              "Access To Weekly Giveaways"
                                            ],
                                            onTap: () {
                                              planProvider.onPurchasePlan(
                                                isMonthly
                                                    ? 'sb_plus_4.99_1m'
                                                    : 'sb_plus_49.99_1y',
                                                false,
                                                widget.tierSectionData.email,
                                              );
                                            },
                                            isLoading:
                                                !planProvider.isProSelect &&
                                                    provider.purchasePending,
                                            isLoggedIn: false,
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                              const SpaceVertical(20),
                              TextButton(
                                onPressed: () {
                                  if (termAndConditionPath.isNotEmpty) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PdfScreen(
                                            filePath: termAndConditionPath),
                                      ),
                                    );
                                  }
                                },
                                child: Text(
                                  'Terms and Conditions',
                                  style:
                                      context.textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  if (privacyPolicy.isNotEmpty) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PdfScreen(filePath: privacyPolicy),
                                      ),
                                    );
                                  }
                                },
                                child: Text(
                                  'Privacy Policy',
                                  style:
                                      context.textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30),
                                      ),
                                    ),
                                    context: context,
                                    builder: (context) => SizedBox(
                                      height:
                                          MediaQuery.sizeOf(context).height *
                                              0.85,
                                      child: Column(
                                        children: [
                                          const Expanded(
                                            child: WhatYouGet(),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              width: double.infinity,
                                              height: 46,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      AppColors.black,
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  'Close',
                                                  style: context
                                                      .textTheme.displaySmall
                                                      ?.copyWith(
                                                    color: AppColors.white,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SpaceVertical(
                                              MediaQuery.paddingOf(context)
                                                  .bottom),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Compare Plans',
                                  style:
                                      context.textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              const SpaceVertical(20),
                            ],
                          );
              },
            ),
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
          color: isMonthly ? AppColors.blue : null,
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
            color: isMonthly ? AppColors.white : null,
          ),
        ),
      ),
    );
  }
}
