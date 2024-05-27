import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_strings.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';

class CardItem extends StatelessWidget {
  final String imagePath;
  final String title;
  final VoidCallback onTap;
  const CardItem(
      {super.key,
      required this.imagePath,
      required this.title,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 5,
        color: AppColors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          onTap: onTap,
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  title == AppStrings.bookings
                      ? Image.asset(
                          imagePath,
                          width: 46,
                          height: 46,
                        )
                      : SvgPicture.asset(
                          imagePath,
                          width: 46,
                          height: 46,
                        ),
                  const SpaceVertical(6),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
