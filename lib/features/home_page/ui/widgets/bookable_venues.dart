import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_images.dart';
import 'package:sb_mobile/core/constant/app_strings.dart';
import 'package:sb_mobile/core/constant/ui_constant.dart';
import 'package:sb_mobile/core/widgets/space_horizontal.dart';
import 'package:sb_mobile/features/home_page/cubit/home_page_cubit.dart';
import 'package:sb_mobile/features/home_page/data/models/fisheries_model.dart';
import 'package:sb_mobile/features/home_page/ui/widgets/list_header.dart';

class BookableVenuesWidget extends StatelessWidget {
  final List<FisheriesModel> bookableVenues;

  final bool isLoggedIn;
  const BookableVenuesWidget(
      {super.key, required this.bookableVenues, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        const ListHeader(
          icon: AppImages.dateIcon,
          title: AppStrings.bookableVenues,
          trailing: AppStrings.swipForMore,
        ),
        SizedBox(
          height: 180,
          child: ListView.separated(
            shrinkWrap: true,
            primary: false,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(
                left: defaultPadding, right: defaultPadding),
            itemCount: bookableVenues.length,
            itemBuilder: (context, index) {
              final FisheriesModel bookableVenuesItem = bookableVenues[index];
              return Stack(
                children: [
                  ShaderMask(
                    blendMode: BlendMode.srcATop,
                    shaderCallback: (Rect bounds) {
                      return const LinearGradient(
                        colors: [
                          Color.fromRGBO(0, 0, 0, 0),
                          Color.fromRGBO(0, 0, 0, 0.60)
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ).createShader(bounds);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(defaultBorderRadius),
                      child: CachedNetworkImage(
                        imageUrl: bookableVenuesItem.images?.first ?? "",
                        fit: BoxFit.cover,
                        width: 270,
                        height: 180,
                        placeholder: (context, url) => Image.asset(
                          'assets/images/placeholder.jpg',
                          fit: BoxFit.cover,
                          width: 248,
                          height: 180,
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/images/placeholder.jpg',
                          fit: BoxFit.cover,
                          width: 248,
                          height: 180,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    left: 0,
                    bottom: 8,
                    child: Column(
                      children: [
                        Text(
                          bookableVenuesItem.name ?? '',
                          style: textTheme.bodyLarge?.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          bookableVenuesItem.city ?? "",
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ),
                  ),
                  Positioned.fill(
                    child: Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        customBorder: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(defaultBorderRadius)),
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            '/fishery/profile',
                            arguments: {
                              'id': "",
                              'publicId': bookableVenuesItem.publicId,
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Visibility(
                      visible: isLoggedIn,
                      child: ClipOval(
                        child: Material(
                          type: MaterialType.transparency,
                          child: IconButton(
                            onPressed: () {
                              context.read<HomePageCubit>().onFavorite(
                                  fisheryId: bookableVenuesItem.id!);
                            },
                            icon: Icon(
                              bookableVenuesItem.isFavourite != null &&
                                      bookableVenuesItem.isFavourite!
                                  ? Icons.favorite_outlined
                                  : Icons.favorite_border,
                              color: bookableVenuesItem.isFavourite != null &&
                                      bookableVenuesItem.isFavourite!
                                  ? const Color(0xffC14F40)
                                  : AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
            separatorBuilder: (context, index) => const SpaceHorizontal(6),
          ),
        )
      ],
    );
  }
}
