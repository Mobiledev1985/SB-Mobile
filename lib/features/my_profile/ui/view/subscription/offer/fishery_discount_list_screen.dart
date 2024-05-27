import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/routes/route_paths.dart';
import 'package:sb_mobile/core/widgets/back_button.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';
import 'package:sb_mobile/features/home_page/data/models/promotion_model.dart';

class FisheryDiscountListScreen extends StatefulWidget {
  final List<PromotionModel> promotions;
  const FisheryDiscountListScreen({super.key, required this.promotions});

  static MaterialPageRoute<dynamic> buildRouter(
      List<PromotionModel> promotions) {
    return MaterialPageRoute(
      builder: (context) => FisheryDiscountListScreen(
        promotions: promotions,
      ),
    );
  }

  static void navigateTo(
      BuildContext context, List<PromotionModel> promotions) {
    Navigator.pushNamed(context, RoutePaths.fisheryDisountListScreen,
        arguments: promotions);
  }

  @override
  State<FisheryDiscountListScreen> createState() =>
      _FisheryDiscountListScreenState();
}

class _FisheryDiscountListScreenState extends State<FisheryDiscountListScreen> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark),
      );
    } else {
      FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
      FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    }
  }

  @override
  void dispose() {
    super.dispose();
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SpaceVertical(20 + MediaQuery.paddingOf(context).top),
          SizedBox(
            height: 40,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: BackButtonWidget(),
                  ),
                ),
                Text(
                  'Fishery Discounts',
                  style: context.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: widget.promotions.length,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 8,
                mainAxisExtent: 120,
              ),
              itemBuilder: (context, index) => Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        child: Stack(
                          children: [
                            CachedNetworkImage(
                              imageUrl:
                                  widget.promotions[index].fisheryImage ?? '',
                              height: 74,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              right: 4,
                              top: 4,
                              child: CircleAvatar(
                                backgroundColor: AppColors.green,
                                radius: 14,
                                child: Text(
                                  '${widget.promotions[index].discount}${widget.promotions[index].discountType}',
                                  style: context.textTheme.bodySmall?.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 46,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: Color(0xff292828),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: Text(
                          widget.promotions[index].name ?? '',
                          textAlign: TextAlign.center,
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                  Positioned.fill(
                    child: Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onTap: () {},
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
