import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/routes/route_paths.dart';
import 'package:sb_mobile/core/widgets/back_button.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';
import 'package:sb_mobile/features/my_profile/data/models/perks_model.dart';
import 'package:sb_mobile/features/my_profile/ui/widgets/sbplus/offer/offer_widget.dart';

typedef OfferListData = ({List<Perk> perks, String title});

class OfferListScreen extends StatefulWidget {
  final OfferListData offerListData;
  const OfferListScreen({super.key, required this.offerListData});
  static MaterialPageRoute<dynamic> buildRouter(OfferListData offerListData) {
    return MaterialPageRoute(
      builder: (context) => OfferListScreen(
        offerListData: offerListData,
      ),
    );
  }

  static void navigateTo(BuildContext context, OfferListData offerListData) {
    Navigator.pushNamed(context, RoutePaths.offerListScreen,
        arguments: offerListData);
  }

  @override
  State<OfferListScreen> createState() => _OfferListScreenState();
}

class _OfferListScreenState extends State<OfferListScreen> {
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
                  'Latest Supplier Offers',
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
              itemCount: widget.offerListData.perks.length,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 6,
                mainAxisSpacing: 10,
                mainAxisExtent: 160,
              ),
              itemBuilder: (context, index) => OfferWidget(
                  perk: widget.offerListData.perks[index], isFromList: true),
            ),
          ),
        ],
      ),
    );
  }
}
