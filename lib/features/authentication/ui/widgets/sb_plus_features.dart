import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_images.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';

typedef Features = ({
  String feature,
  bool isFree,
  String? toolTip,
  JustTheController justTheController
});

class SBPlusFeatures extends StatefulWidget {
  const SBPlusFeatures({super.key, required this.onFeature});

  final VoidCallback onFeature;

  @override
  State<SBPlusFeatures> createState() => _SBPlusFeaturesState();
}

class _SBPlusFeaturesState extends State<SBPlusFeatures> {
  final tooltipController = JustTheController();

  final List<Features> features = [
    (
      feature: 'Access 100+ Venues',
      isFree: true,
      toolTip: null,
      justTheController: JustTheController()
    ),
    (
      feature: 'No Booking Fees',
      isFree: true,
      toolTip: null,
      justTheController: JustTheController()
    ),
    (
      feature: 'Insurance Cover',
      isFree: false,
      toolTip:
          'swimbooker+ insurance cover is backed by Aviva and claims are handled by our partners at Marsh Sports.',
      justTheController: JustTheController()
    ),
    (
      feature: 'Exclusive Perks',
      isFree: false,
      toolTip:
          'Access industry first, exclusive member perks from the most popular brands and suppliers in the industry.',
      justTheController: JustTheController()
    ),
    (
      feature: 'Fishing Discounts',
      isFree: false,
      toolTip:
          'Receive significant discount when booking across our network of fishery and lake partners',
      justTheController: JustTheController()
    ),
    (
      feature: 'Weekly Giveaways',
      isFree: false,
      toolTip:
          'Gain access to over 52 giveaways per year with an average prize pot of over £250.00',
      justTheController: JustTheController()
    ),
    (
      feature: 'SB+ Shop',
      isFree: false,
      toolTip:
          'Your one-stop-shop; unlock swimbooker merchandise and incredible deals from across the industry',
      justTheController: JustTheController()
    ),
    (
      feature: 'Cashback on fishing & tackle',
      isFree: false,
      toolTip:
          'Plus members earn credit back in their SB wallet for every purchase made via our platform',
      justTheController: JustTheController()
    ),
    (
      feature: 'InSession Pro Tool',
      isFree: false,
      toolTip:
          'A handy bankside assistant; allowing you to keep notes, track your captures, find local food and so much more!',
      justTheController: JustTheController()
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Become part of the club.',
                style: context.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.greyTextColor,
                ),
              ),
              const SpaceVertical(14),
              Text(
                'Join swimbooker+ to enjoy a host of angler benefits. Cancel anytime.',
                style: context.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.greyColor,
                  height: 1.5,
                ),
              ),
              const SpaceVertical(24),
            ],
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 22.0, bottom: 10.0),
                child: Text(
                  'What you get',
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xffF2F6FA),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 12,
              ),
              decoration: const BoxDecoration(
                color: Color(0xffDCE1E5),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                ),
              ),
              child: Text(
                'swimbooker\nFree Account',
                style: context.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff45494D),
                  height: 1.6,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 12,
              ),
              decoration: const BoxDecoration(
                color: Color(0xff0D3759),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(5),
                ),
              ),
              child: Text(
                'swimbooker+\nMembership',
                style: context.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: const Color(0XFFF2F6FA),
                  height: 1.6,
                ),
              ),
            )
          ],
        ),
        const Divider(
          height: 0,
          thickness: 1,
          color: AppColors.greyColor,
        ),
        ...features
            .map(
              (Features e) => Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 22.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 26.0),
                            child: JustTheTooltip(
                              preferredDirection: AxisDirection.right,
                              backgroundColor:
                                  const Color.fromRGBO(220, 225, 229, 1),
                              controller: e.justTheController,
                              content: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  e.toolTip ?? '',
                                ),
                              ),
                              child: GestureDetector(
                                onTap: e.toolTip != null
                                    ? () {
                                        e.justTheController.showTooltip();
                                      }
                                    : null,
                                child: Text(
                                  e.feature,
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xffDCE1E5),
                                    decoration: e.toolTip != null
                                        ? TextDecoration.underline
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: e.isFree
                              ? SvgPicture.asset(AppImages.checkIcon)
                              : const Divider(
                                  height: 0,
                                  color: AppColors.greyColor,
                                  thickness: 2,
                                  indent: 34,
                                  endIndent: 34,
                                ),
                        ),
                        Expanded(
                          flex: 1,
                          child: SvgPicture.asset(AppImages.checkIcon),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 0,
                    thickness: 1,
                    color: AppColors.greyColor,
                  ),
                ],
              ),
            )
            .toList(),
        const SpaceVertical(24),
        Align(
          alignment: Alignment.center,
          child: SizedBox(
            height: 46,
            width: context.width * 0.75,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                  side: BorderSide(
                    color: AppColors.greyTextColor,
                  ),
                ),
              ),
              onPressed: widget.onFeature,
              child: Text(
                'Compare features',
                style: context.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.greyTextColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
