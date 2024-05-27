import 'package:flutter/material.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/utility/utils/utils.dart';
import 'package:sb_mobile/core/widgets/space_horizontal.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';

typedef SBPlusItems = ({String image, String title, String text});

class WhatIsSwimbookerPlus extends StatefulWidget {
  const WhatIsSwimbookerPlus({super.key});

  @override
  State<WhatIsSwimbookerPlus> createState() => _WhatIsSwimbookerPlusState();
}

class _WhatIsSwimbookerPlusState extends State<WhatIsSwimbookerPlus> {
  final List<SBPlusItems> sbPlusItems = [
    (
      image: 'assets/images/slider0.png',
      title: 'Book Fishing Online',
      text: 'No added booking fees'
    ),
    (
      image: 'assets/images/slider1.png',
      title: 'Live Weekly Giveaways',
      text: 'Over 52 chances to win per year'
    ),
    (
      image: 'assets/images/slider2.png',
      title: 'Comprehensive Angling Cover',
      text: 'Protect yourself and your equipment'
    ),
    (
      image: 'assets/images/slider3.png',
      title: 'Cashback on Fishing & Shop',
      text: 'Earn credit back to spend on more fishing!'
    ),
    (
      image: 'assets/images/slider4.png',
      title: '5* Customer Service',
      text: 'Providing you with incredible support'
    ),
    (
      image: 'assets/images/slider5.png',
      title: 'Private Community',
      text: 'Join a group of likeminded anglers'
    ),
    (
      image: 'assets/images/slider6.png',
      title: 'Exclusive Perks and Offers',
      text: 'An ever-growing list of member benefits'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0),
          child: Text(
            'What is swimbooker+?',
            style: context.textTheme.displaySmall?.copyWith(
              color: AppColors.greyTextColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: ListView.separated(
              padding: const EdgeInsets.only(top: 16, left: 22),
              itemCount: sbPlusItems.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        sbPlusItems[index].image,
                        width: 260,
                        height: 130,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SpaceVertical(14),
                    Text(
                      sbPlusItems[index].title,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: AppColors.greyTextColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SpaceVertical(6),
                    Text(
                      sbPlusItems[index].text,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: AppColors.greyColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) => const SpaceHorizontal(20),
            ),
          ),
        ),
      ],
    );
  }
}
