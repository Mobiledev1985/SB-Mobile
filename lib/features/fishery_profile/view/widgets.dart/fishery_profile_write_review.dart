import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/utility/styles/app_styles.dart';
import 'package:sb_mobile/core/widgets/alert.dart';
import 'package:sb_mobile/features/fishery_profile/cubit/fishery_profile_cubit.dart';
import 'package:sb_mobile/features/fishery_profile/view/widgets.dart/sb_close_button.dart';
import 'package:sb_mobile/features/fishery_property_details/data/models/fishery_details.dart';
import 'package:sb_mobile/features/fishery_property_details/ui/widgets/base_headline.dart';

class FisheryProfileWriteReview extends StatelessWidget {
  const FisheryProfileWriteReview(
      {Key? key, required this.cubit, required this.fishery})
      : super(key: key);
  final FisheryProfileCubit cubit;

  final FisheryPropertyDetails fishery;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(20.0),
            children: [
              const SizedBox(height: 100),
              const Headline(title: 'Leave a review'),
              const SizedBox(height: 16),
              Text(
                'Select your fishery rating',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: appStyles.sbBlue),
              ),
              BlocProvider.value(
                  value: cubit,
                  child: _FisheryReviewWidget(
                    fishery: fishery,
                  ))
            ],
          ),
          const SbCloseButton()
        ],
      ),
    );
  }
}

class _FisheryReviewWidget extends StatefulWidget {
  final FisheryPropertyDetails fishery;

  const _FisheryReviewWidget({Key? key, required this.fishery})
      : super(key: key);
  @override
  _FisheryReviewWidgetState createState() => _FisheryReviewWidgetState();
}

class _FisheryReviewWidgetState extends State<_FisheryReviewWidget> {
  int currentRating = 0;
  late String currentReview;
  final reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return getPropertyReviews(fishery: widget.fishery, context: context);
  }

  void submitReview(
      {required BuildContext context,
      required String fisheryId,
      required String comment,
      required int rating}) {
    Future.microtask(() {
      context.read<FisheryProfileCubit>().submitUserReview(
          fisheryId: fisheryId, comment: comment, rating: rating);
    });
  }

  Widget setNewRating(int rating) {
    Widget image(String asset, Color color) {
      BorderRadius borderRadius = const BorderRadius.all(Radius.circular(20));
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 30),
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius,
        ),
        child: Image(
          image: AssetImage(asset),
        ),
      );
    }

    // Widget emptyImage(String asset) {
    //   // BorderRadius borderRadius = BorderRadius.zero;

    //   return Image(
    //     height: 1,
    //     color: Colors.red,
    //     image: AssetImage(asset),
    //   );
    // }

// assets/fishery_profile/white_fish.png
    return Row(
      children: [
        RatingBar(
          initialRating: 0.0,
          minRating: 1,
          maxRating: 5.0,
          direction: Axis.horizontal,
          allowHalfRating: false,
          itemCount: 5,
          itemSize: 25,
          ratingWidget: RatingWidget(
            full: image(
                'assets/fishery_profile/white_fish.png', hexToColor("#2772AF")),
            half: image(
                'assets/fishery_profile/white_fish.png', hexToColor("#2772AF")),
            empty: image('assets/fishery_profile/white_fish.png', Colors.grey),
          ),
          itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
          onRatingUpdate: (rating) {
            setState(() {
              currentRating = rating.toInt();
            });
          },
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          '$currentRating/5',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
      ],
    );
  }

  Widget getPropertyReviews(
      {required FisheryPropertyDetails fishery,
      required BuildContext context}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 15.0,
        ),
        setNewRating(
          fishery.rating.userRating,
        ),
        const SizedBox(height: 30.0),
        SizedBox(
          width: double.infinity,
          child: AutoSizeText(
            "Leave your review",
            maxLines: 2,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: appStyles.sbBlue),
          ),
        ),
        const SizedBox(
          height: 20.0,
        ),
        Container(
          height: context.dynamicHeight(0.12),
          width: context.dynamicWidth(0.9),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              border: Border.all(color: Colors.grey.withOpacity(.43))),
          child: TextField(
            textAlign: TextAlign.left,
            style: TextStyle(
                fontFamily: appStyles.fontGilroy,
                fontSize: 18,
                fontWeight: FontWeight.w300,
                color: Colors.black),
            controller: reviewController,
            maxLines: 4,
            keyboardType: TextInputType.multiline,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(10.0),
              border: InputBorder.none,
              hintStyle: TextStyle(
                color: appStyles.passwordTextColor,
                fontFamily: appStyles.fontGilroy,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20.0,
        ),
        GestureDetector(
          onTap: () {
            final String comment = reviewController.text;
            final int rating = currentRating;

            submitReview(
                context: context,
                fisheryId: fishery.fisheryId,
                comment: comment,
                rating: rating);
            reviewController.clear();
          },
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: appStyles.sbGreen,
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Center(
                child: Text(
                  'Submit',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: appStyles.sbWhite),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
