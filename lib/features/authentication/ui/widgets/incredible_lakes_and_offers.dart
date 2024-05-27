import 'package:flutter/material.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';

typedef IncredibleLakesAndOffers = ({String image, String title});

class IncredibleLakesAndOffer extends StatefulWidget {
  const IncredibleLakesAndOffer({super.key, required this.features});

  final GlobalKey features;

  @override
  State<IncredibleLakesAndOffer> createState() =>
      _IncredibleLakesAndOfferState();
}

class _IncredibleLakesAndOfferState extends State<IncredibleLakesAndOffer> {
  final List<IncredibleLakesAndOffers> incredibleOffersAndLakes = [
    (image: 'assets/images/incredible0.jpeg', title: 'Sandhurst\nLake'),
    (image: 'assets/images/incredible1.jpeg', title: 'Elphicks\nFisheries'),
    (image: 'assets/images/incredible2.jpeg', title: 'The Approach\nFisheries'),
    (image: 'assets/images/incredible3.png', title: 'Sticky\nBaits'),
    (image: 'assets/images/incredible4.jpeg', title: 'Carpworks\nClothing'),
    (image: 'assets/images/incredible5.jpeg', title: 'Wolf\nInternational'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SpaceVertical(50),
          Text(
            'Incredible Lakes. Incredible Offers.',
            style: context.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.greyTextColor,
            ),
          ),
          const SpaceVertical(14),
          Text(
            'Earn credit at lakes worldwide. Access exclusive perks from industry suppliers.',
            style: context.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.greyColor,
              height: 1.5,
            ),
          ),
          const SpaceVertical(36),
          GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 30,
            ),
            itemCount: incredibleOffersAndLakes.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: const Color(0xff5C6166),
                    child: CircleAvatar(
                      radius: 31,
                      backgroundColor: AppColors.white,
                      backgroundImage: AssetImage(
                        incredibleOffersAndLakes[index].image,
                      ),
                    ),
                  ),
                  const SpaceVertical(8),
                  Text(
                    incredibleOffersAndLakes[index].title,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xffF2F6FA),
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            },
          ),
          const SpaceVertical(30),
          Divider(
            key: widget.features,
            thickness: 2,
            indent: 36,
            endIndent: 36,
            color: const Color(0xff737A80),
          ),
        ],
      ),
    );
  }
}
