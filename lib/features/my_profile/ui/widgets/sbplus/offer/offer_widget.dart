import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';
import 'package:sb_mobile/features/my_profile/data/models/perks_model.dart';
import 'package:sb_mobile/features/my_profile/ui/view/subscription/offer/offer_detail_screen.dart';

class OfferWidget extends StatelessWidget {
  final Perk perk;
  final bool isFromList;
  const OfferWidget({super.key, required this.perk, required this.isFromList});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: CachedNetworkImage(
                imageUrl: perk.headerImage ?? '',
                height: 104,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              height: 56,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: const BoxDecoration(
                color: Color(0xff1F1F1F),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SpaceVertical(4),
                  Flexible(
                    child: Text(
                      perk.title ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    perk.discountLine ?? '',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: const Color(0xff909090),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SpaceVertical(4),
                ],
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
              onTap: () {
                OfferDetailScreen.navigateTo(
                  context,
                  (isFromList: isFromList, perk: perk),
                );
              },
            ),
          ),
        )
      ],
    );
  }
}
