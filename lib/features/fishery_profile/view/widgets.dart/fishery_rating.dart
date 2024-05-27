import 'package:flutter/material.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/features/fishery_property_details/data/models/fishery_details.dart';

class FisheryRatings extends StatelessWidget {
  final FisheryPropertyDetails fishery;

  const FisheryRatings({Key? key, required this.fishery}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return getRatingsWidget(fishery: fishery, context: context);
  }

  Widget getRatingsWidget(
      {required FisheryPropertyDetails fishery,
      required BuildContext context}) {
    List<Widget> resultWidgets = [];
    double boarderRadius = 7.0;
    BorderRadius leftCorner = BorderRadius.only(
      topLeft: Radius.circular(boarderRadius),
      bottomLeft: Radius.circular(boarderRadius),
    );

    BorderRadius rightCorner = BorderRadius.only(
      topRight: Radius.circular(boarderRadius),
      bottomRight: Radius.circular(boarderRadius),
    );

    for (int index = 0; index < 5; index++) {
      BorderRadius radius = BorderRadius.circular(0);

      if (index == 0) {
        radius = leftCorner;
      } else if (index == 4) {
        radius = rightCorner;
      }

      resultWidgets.add(Container(
        height: 23,
        width: 28,
        decoration: BoxDecoration(
            color: fishery.rating.score <= index ? Colors.grey : AppColors.blue,
            borderRadius: radius),
        child: Container(
          margin: const EdgeInsets.all(2.0),
          child: const Image(
            image: AssetImage('assets/fishery_profile/white_fish.png'),
          ),
        ),
      ));

      if (index <= 4) {
        resultWidgets.add(const SizedBox(width: 3.0));
      }
    }

    return SizedBox(
        height: 40,
        width: 160,
        // color: Colors.orange,
        child: Row(children: resultWidgets));
  }
}
