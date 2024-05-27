import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_images.dart';
import 'package:sb_mobile/core/constant/ui_constant.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/routes/route_paths.dart';
import 'package:sb_mobile/core/utility/utils/utils.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';
import 'package:sb_mobile/features/my_profile/data/models/credit_history_model.dart';

class AllEarnedCredit extends StatefulWidget {
  final List<CreditHistory> history;
  const AllEarnedCredit({super.key, required this.history});

  static MaterialPageRoute<dynamic> buildRouter(List<CreditHistory> history) {
    return MaterialPageRoute(
      builder: (context) => AllEarnedCredit(history: history),
    );
  }

  static void navigateTo(BuildContext context, List<CreditHistory> history) {
    Navigator.pushNamed(context, RoutePaths.allEarnedCreditScreen,
        arguments: history);
  }

  @override
  State<AllEarnedCredit> createState() => _AllEarnedCreditState();
}

class _AllEarnedCreditState extends State<AllEarnedCredit> {
  @override
  void initState() {
    super.initState();
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
  }

  @override
  void dispose() {
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: defaultSidePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SpaceVertical(MediaQuery.viewPaddingOf(context).top),
            SizedBox(
              height: 58,
              child: Stack(
                alignment: Alignment.center,
                fit: StackFit.expand,
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.dividerGreyColor,
                        ),
                      ),
                      // margin: const EdgeInsets.only(top: 20),
                      child: GestureDetector(
                        child: const CircleAvatar(
                          backgroundColor: AppColors.white,
                          child: Icon(
                            Icons.clear,
                            color: AppColors.black,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Container(
                      width: 96,
                      height: 58,
                      padding: const EdgeInsets.only(
                        top: 4,
                        right: 6,
                      ),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xff6EBEFF),
                            AppColors.blue,
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: SizedBox(
                            width: 14,
                            height: 18,
                            child: SvgPicture.asset(
                              AppImages.fish,
                              colorFilter: const ColorFilter.mode(
                                AppColors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SpaceVertical(26),
            Text(
              'All Earned Credit',
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SpaceVertical(12),
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: Card(
                  color: const Color(0xffF5F5F5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22.0),
                    child: ScrollConfiguration(
                      behavior: MyBehavior(),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.zero,
                        child: Column(
                          children: List.generate(
                            widget.history.length,
                            (index) => Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 6,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (index == 0) const SpaceVertical(20),
                                      Text(
                                        widget.history[index].description ?? '',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: context.textTheme.bodyLarge
                                            ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SpaceVertical(4),
                                      Text(
                                        widget.history[index].transactionDate ==
                                                null
                                            ? ''
                                            : DateFormat('d MMMM, HH:mm')
                                                .format(DateTime.parse(widget
                                                    .history[index]
                                                    .transactionDate!)),
                                        style: context.textTheme.bodyMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SpaceVertical(20),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      top: index == 0 ? 20 : 0,
                                    ),
                                    child: Text(
                                      '£${(widget.history[index].amountInPence! / 100).toStringAsFixed(2)}',
                                      textAlign: TextAlign.end,
                                      style: context.textTheme.headlineMedium
                                          ?.copyWith(
                                        color: widget.history[index]
                                                    .transactionType!.value!
                                                    .toUpperCase() ==
                                                'DEBIT'
                                            ? const Color(0xffff2929)
                                            : AppColors.green,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SpaceVertical(12),
          ],
        ),
      ),
    );
  }
}
