import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_images.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/widgets/space_horizontal.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';
import 'package:sb_mobile/features/authentication/providers/subscription_provider.dart';
import 'package:sb_mobile/features/authentication/ui/views/login_screen.dart';
import 'package:sb_mobile/features/authentication/ui/views/sb_plus_purchase_screen.dart';
import 'package:sb_mobile/features/authentication/ui/widgets/subscription_plan_card.dart';

// ignore: must_be_immutable
class PlanSection extends StatefulWidget {
  PlanSection(
      {super.key,
      required this.duration,
      required this.isLoggedIn,
      required this.email});

  final GlobalKey duration;
  bool isLoggedIn;
  String email;

  @override
  State<PlanSection> createState() => _PlanSectionState();
}

class _PlanSectionState extends State<PlanSection> {
  final ValueNotifier<bool> isMonthly = ValueNotifier(true);

  @override
  void dispose() {
    super.dispose();
    isMonthly.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0),
          child: Consumer<SubscriptionProvider>(
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
                            SpaceVertical(key: widget.duration, 20),
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
                                            "Personal Accident Insurance",
                                            "Equipment cover up to £1000",
                                            "Up to 2% credit back on purchases",
                                            "Up to 1% credit back on fishing"
                                          ],
                                          onTap: () {
                                            if (widget.isLoggedIn) {
                                              planProvider.onPurchasePlan(
                                                isMonthly
                                                    ? 'sb_plus_pro_6.99_1m'
                                                    : 'sb_plus_pro_59.99_1y',
                                                true,
                                                widget.email,
                                              );
                                            } else {
                                              LoginScreen.navigateTo(
                                                context,
                                                true,
                                              ).then((value) async {
                                                if (value != null) {
                                                  widget.email = value['email'];
                                                  widget.isLoggedIn = true;
                                                  setState(() {});
                                                }

                                                await Future.delayed(
                                                  const Duration(
                                                    milliseconds: 400,
                                                  ),
                                                );
                                                if (Platform.isAndroid) {
                                                  SystemChrome
                                                      .setSystemUIOverlayStyle(
                                                    const SystemUiOverlayStyle(
                                                      statusBarIconBrightness:
                                                          Brightness.light,
                                                    ),
                                                  );
                                                } else {
                                                  FlutterStatusbarcolor
                                                      .setStatusBarWhiteForeground(
                                                          true);
                                                }
                                              });
                                            }
                                          },
                                          isLoading: planProvider.isProSelect &&
                                              provider.purchasePending,
                                          isLoggedIn: widget.isLoggedIn,
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
                                            "Personal Accident Insurance",
                                            "Equipment cover up to £350",
                                            "Up to 1% credit back on purchases",
                                            "Up to 0.10% credit back on fishing"
                                          ],
                                          onTap: () async {
                                            if (widget.isLoggedIn) {
                                              planProvider.onPurchasePlan(
                                                isMonthly
                                                    ? 'sb_plus_4.99_1m'
                                                    : 'sb_plus_49.99_1y',
                                                false,
                                                widget.email,
                                              );
                                            } else {
                                              LoginScreen.navigateTo(
                                                context,
                                                true,
                                              ).then((value) async {
                                                if (value != null) {
                                                  widget.email = value['email'];
                                                  widget.isLoggedIn = true;
                                                  setState(() {});
                                                }

                                                await Future.delayed(
                                                  const Duration(
                                                    milliseconds: 400,
                                                  ),
                                                );
                                                if (Platform.isAndroid) {
                                                  SystemChrome
                                                      .setSystemUIOverlayStyle(
                                                    const SystemUiOverlayStyle(
                                                      statusBarIconBrightness:
                                                          Brightness.light,
                                                    ),
                                                  );
                                                } else {
                                                  FlutterStatusbarcolor
                                                      .setStatusBarWhiteForeground(
                                                          true);
                                                }
                                              });
                                            }
                                          },
                                          isLoading:
                                              !planProvider.isProSelect &&
                                                  provider.purchasePending,
                                          isLoggedIn: widget.isLoggedIn,
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        );
            },
          ),
        ),
        const SpaceVertical(22),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Securely processed',
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.greyColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SpaceHorizontal(10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: AppColors.greyColor,
                ),
              ),
              child: Row(
                children: [
                  Platform.isAndroid
                      ? Padding(
                          padding: const EdgeInsets.only(right: 2.0),
                          child: SvgPicture.asset(
                            AppImages.googleIcon,
                            colorFilter: const ColorFilter.mode(
                                AppColors.greyColor, BlendMode.srcIn),
                            width: 24,
                            height: 24,
                          ),
                        )
                      : const Icon(
                          Icons.apple,
                          color: AppColors.greyColor,
                        ),
                  Text(
                    'In-App',
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.greyColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
