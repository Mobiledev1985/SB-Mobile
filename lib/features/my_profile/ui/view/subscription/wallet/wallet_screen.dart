import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:intl/intl.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_images.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/routes/route_paths.dart';
import 'package:sb_mobile/core/widgets/space_horizontal.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';
import 'package:sb_mobile/features/authentication/data/models/angler_profile_details_model.dart';
import 'package:sb_mobile/features/my_profile/cubit/credit_history_cubit.dart';
import 'package:sb_mobile/features/my_profile/ui/view/subscription/offer/offer_screen.dart';
import 'package:sb_mobile/features/my_profile/ui/view/subscription/wallet/all_earned_credit_screen.dart';
import 'package:sb_mobile/features/my_profile/ui/widgets/sbplus/wallet/card_widget.dart';
import 'package:sb_mobile/features/my_profile/ui/widgets/profile_bar.dart';
import 'package:sb_mobile/features/my_profile/ui/widgets/sbplus/wallet/no_credit_earned.dart';
import 'package:sb_mobile/features/my_profile/ui/widgets/sbplus/wallet/top_section.dart';
import 'package:sb_mobile/features/my_profile/ui/widgets/sbplus/wallet/what_credit_dialog.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen._({this.profile});

  final AnglerProfile? profile;

  static PageRouteBuilder<dynamic> buildRouter(AnglerProfile? profile) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
        create: (context) => CreditHistoryCubit(),
        child: WalletScreen._(profile: profile),
      ),
      transitionsBuilder: (_, animation, __, child) {
        final tween = Tween<double>(begin: 0.0, end: 1.0).chain(
          CurveTween(curve: Curves.ease), // Replace with your desired curve
        );
        return FadeTransition(
          opacity: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
    );
  }

  static Future<void> navigateTo(
      BuildContext context, AnglerProfile? profile) async {
    await Navigator.pushNamed(context, RoutePaths.walletScreen,
        arguments: profile);
  }

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  void initState() {
    super.initState();

    context.read<CreditHistoryCubit>().getCreditHistory();
    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light),
      );
    } else {
      FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
      FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          ProfileBar(
            profile: widget.profile,
            isFromWallet: true,
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                TopSection(profile: widget.profile),
                CardWidget(profile: widget.profile),
                BlocBuilder<CreditHistoryCubit, CreditHistoryState>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Latest Earned Credit',
                                style:
                                    context.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SpaceHorizontal(4),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                        const WhatCreditDialog(),
                                  );
                                },
                                child: const Icon(
                                  CupertinoIcons.info,
                                  size: 20,
                                  color: Color(0xff6F6F6F),
                                ),
                              ),
                              const Spacer(),
                              Visibility(
                                visible: state is CreditHistorySuccess &&
                                    state.creditHistory.isNotEmpty,
                                child: TextButton(
                                  onPressed: () {
                                    AllEarnedCredit.navigateTo(
                                        context,
                                        (state as CreditHistorySuccess)
                                            .creditHistory);
                                  },
                                  child: Text(
                                    'See All',
                                    style:
                                        context.textTheme.bodyLarge?.copyWith(
                                      color: AppColors.blue,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SpaceVertical(6),
                        state is CreditHistoryLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.blue,
                                ),
                              )
                            : state is CreditHistorySuccess &&
                                    state.creditHistory.isNotEmpty
                                ? SizedBox(
                                    width: double.infinity,
                                    child: Card(
                                      color: const Color(0xffF5F5F5),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(22.0),
                                        child: Column(
                                          children: List.generate(
                                            state.creditHistory.length >= 3
                                                ? 3
                                                : state.creditHistory.length,
                                            (index) => Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  flex: 6,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        state
                                                                .creditHistory[
                                                                    index]
                                                                .description ??
                                                            '',
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: context
                                                            .textTheme.bodyLarge
                                                            ?.copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                      ),
                                                      const SpaceVertical(4),
                                                      Text(
                                                        state
                                                                    .creditHistory[
                                                                        index]
                                                                    .transactionDate ==
                                                                null
                                                            ? ''
                                                            : DateFormat(
                                                                    'd MMMM, HH:mm')
                                                                .format(DateTime
                                                                    .parse(state
                                                                        .creditHistory[
                                                                            index]
                                                                        .transactionDate!)),
                                                        style: context.textTheme
                                                            .bodyMedium
                                                            ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      if (index != 2)
                                                        const SpaceVertical(20),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    '£${(state.creditHistory[index].amountInPence! / 100).toStringAsFixed(2)}',
                                                    textAlign: TextAlign.end,
                                                    style: context.textTheme
                                                        .headlineMedium
                                                        ?.copyWith(
                                                      color: state
                                                                  .creditHistory[
                                                                      index]
                                                                  .transactionType!
                                                                  .value! ==
                                                              'DEBIT'
                                                          ? const Color(
                                                              0xffff2929)
                                                          : AppColors.green,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : const NoCreditEarned(),
                      ],
                    );
                  },
                ),
                // const NoCreditEarned(),
                const SpaceVertical(20),
                GestureDetector(
                  onTap: () {
                    OfferScreen.navigateTo(context, widget.profile);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    width: double.infinity,
                    height: 70,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: const DecorationImage(
                        image: AssetImage(
                          AppImages.banner,
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Have you checked out\nyour latest perks?',
                          style: context.textTheme.headlineSmall?.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 110,
                          height: 24,
                          child: IgnorePointer(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: const BorderSide(
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                              onPressed: () {},
                              child: Text(
                                'Go to Offers',
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SpaceVertical(20),
              ],
            ),
          )
        ],
      ),
    );
  }
}
