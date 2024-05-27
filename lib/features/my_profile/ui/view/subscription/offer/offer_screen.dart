import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/ui_constant.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/notification/web_view_screen.dart';
import 'package:sb_mobile/core/routes/route_paths.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';
import 'package:sb_mobile/features/authentication/data/models/angler_profile_details_model.dart';
import 'package:sb_mobile/features/my_profile/cubit/offer_cubit.dart';
import 'package:sb_mobile/features/my_profile/ui/view/subscription/offer/fishery_discount_list_screen.dart';
import 'package:sb_mobile/features/my_profile/ui/view/subscription/offer/offer_list_screen.dart';
import 'package:sb_mobile/features/my_profile/ui/widgets/common_back_bar.dart';
import 'package:sb_mobile/features/my_profile/ui/widgets/profile_bar.dart';
import 'package:sb_mobile/features/my_profile/ui/widgets/sbplus/offer/offer_widget.dart';

class OfferScreen extends StatefulWidget {
  const OfferScreen._(this.profile);

  final AnglerProfile? profile;

  @override
  State<OfferScreen> createState() => _OfferScreenState();

  static MaterialPageRoute<dynamic> buildRouter(AnglerProfile? profile) {
    return MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (context) => OfferCubit(),
        child: OfferScreen._(profile),
      ),
    );
  }

  static Future<void> navigateTo(
      BuildContext context, AnglerProfile? profile) async {
    await Navigator.pushNamed(context, RoutePaths.offerScreen,
        arguments: profile);
  }
}

class _OfferScreenState extends State<OfferScreen> {
  @override
  void initState() {
    super.initState();
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
    context.read<OfferCubit>().getPerks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ProfileBar(
            profile: widget.profile,
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: [
                const CommonBackBar(
                  title: 'Perks',
                ),
                BlocBuilder<OfferCubit, OfferState>(
                  builder: (context, state) {
                    return state is OfferLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.blue,
                            ),
                          )
                        : state is OfferFailed
                            ? Center(
                                child: Text(state.message),
                              )
                            : state is OfferSuccess
                                ? Column(
                                    children: [
                                      const SpaceVertical(10),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        child: Text(
                                          'Exclusive offers for plus users from across the industry.',
                                          style: context.textTheme.bodyLarge
                                              ?.copyWith(
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      const SpaceVertical(32),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        child: Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      defaultBorderRadius),
                                              child: Image.asset(
                                                'assets/images/perks_banner.jpg',
                                                fit: BoxFit.cover,
                                                width: double.maxFinite,
                                                height: 110,
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        defaultBorderRadius),
                                                color: AppColors.black
                                                    .withOpacity(0.35),
                                              ),
                                              width: double.maxFinite,
                                              height: 110,
                                            ),
                                            Positioned.fill(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 14.0,
                                                  bottom: 10.0,
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'SB MERCHANDISE',
                                                      style: context
                                                          .textTheme.bodyLarge
                                                          ?.copyWith(
                                                        color: AppColors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SpaceVertical(2),
                                                    Text(
                                                      'Exclusive to swimbooker+',
                                                      style: context
                                                          .textTheme.bodyMedium
                                                          ?.copyWith(
                                                        color: AppColors.white,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Positioned.fill(
                                              child: Material(
                                                type: MaterialType.transparency,
                                                child: InkWell(
                                                  customBorder:
                                                      RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const WebViewScreen(
                                                          url: '',
                                                          isGoBackToHomeScreen:
                                                              false,
                                                          title: 'Shop',
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      const SpaceVertical(32),
                                      if (state.promotions.isNotEmpty) ...[
                                        CommonHeaderWithSeeAll(
                                          title: 'Fishery Discounts',
                                          onTap: state.promotions.length < 6
                                              ? null
                                              : () {
                                                  FisheryDiscountListScreen
                                                      .navigateTo(
                                                    context,
                                                    state.promotions,
                                                  );
                                                },
                                          length: null,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                          ),
                                          child: Text(
                                            'Automatically applied on every booking you make online',
                                            style: context.textTheme.bodyLarge
                                                ?.copyWith(
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        GridView.builder(
                                          shrinkWrap: true,
                                          itemCount: state.promotions.length < 6
                                              ? state.promotions.length
                                              : 6,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 10,
                                          ),
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            crossAxisSpacing: 4,
                                            mainAxisSpacing: 8,
                                            mainAxisExtent: 120,
                                          ),
                                          itemBuilder: (context, index) =>
                                              Stack(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(10),
                                                      topRight:
                                                          Radius.circular(10),
                                                    ),
                                                    child: Stack(
                                                      children: [
                                                        CachedNetworkImage(
                                                          imageUrl: state
                                                                  .promotions[
                                                                      index]
                                                                  .fisheryImage ??
                                                              '',
                                                          height: 74,
                                                          width:
                                                              double.infinity,
                                                          fit: BoxFit.cover,
                                                        ),
                                                        Positioned(
                                                          right: 4,
                                                          top: 4,
                                                          child: CircleAvatar(
                                                            backgroundColor:
                                                                AppColors.green,
                                                            radius: 14,
                                                            child: Text(
                                                              state.promotions[index]
                                                                          .discountType ==
                                                                      '%'
                                                                  ? '${state.promotions[index].discount}${state.promotions[index].discountType}'
                                                                  : '${state.promotions[index].discountType}${state.promotions[index].discount}',
                                                              style: context
                                                                  .textTheme
                                                                  .bodySmall
                                                                  ?.copyWith(
                                                                color: AppColors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
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
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Color(0xff292828),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(10),
                                                        bottomRight:
                                                            Radius.circular(10),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      state.promotions[index]
                                                              .fisheryName ??
                                                          '',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: context
                                                          .textTheme.bodyMedium
                                                          ?.copyWith(
                                                        color: AppColors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Positioned.fill(
                                                child: Material(
                                                  type:
                                                      MaterialType.transparency,
                                                  child: InkWell(
                                                    customBorder:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pushNamed(
                                                        '/fishery/profile',
                                                        arguments: {
                                                          'id': "",
                                                          'publicId': state
                                                              .promotions[index]
                                                              .fisheryPublicId,
                                                        },
                                                      ).then(
                                                        (value) {
                                                          Future.delayed(
                                                            const Duration(
                                                                milliseconds:
                                                                    400),
                                                          ).then(
                                                            (value) {
                                                              if (Platform
                                                                  .isAndroid) {
                                                                SystemChrome
                                                                    .setSystemUIOverlayStyle(
                                                                  const SystemUiOverlayStyle(
                                                                      statusBarColor:
                                                                          Colors
                                                                              .transparent,
                                                                      statusBarIconBrightness:
                                                                          Brightness
                                                                              .light),
                                                                );
                                                              } else {
                                                                FlutterStatusbarcolor
                                                                    .setStatusBarWhiteForeground(
                                                                        true);
                                                                FlutterStatusbarcolor
                                                                    .setStatusBarColor(
                                                                        Colors
                                                                            .transparent);
                                                              }
                                                            },
                                                          );
                                                        },
                                                      );
                                                    },
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SpaceVertical(32),
                                      ],
                                      if (state.perksModel.supplierPerks !=
                                              null &&
                                          state.perksModel.supplierPerks!
                                              .isNotEmpty) ...[
                                        CommonHeaderWithSeeAll(
                                          title: 'Latest Supplier Offers',
                                          onTap: state.perksModel.supplierPerks!
                                                      .length <
                                                  4
                                              ? null
                                              : () {
                                                  OfferListScreen.navigateTo(
                                                    context,
                                                    (
                                                      title:
                                                          'Latest Supplier Offers',
                                                      perks: state.perksModel
                                                          .supplierPerks!
                                                    ),
                                                  );
                                                },
                                          length: state
                                              .perksModel.supplierPerks!.length,
                                        ),
                                        GridView.builder(
                                          shrinkWrap: true,
                                          itemCount: state.perksModel
                                                      .supplierPerks!.length <
                                                  4
                                              ? state.perksModel.supplierPerks
                                                  ?.length
                                              : 4,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                          ),
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 6,
                                            mainAxisSpacing: 10,
                                            mainAxisExtent: 160,
                                          ),
                                          itemBuilder: (context, index) {
                                            return OfferWidget(
                                                perk: state.perksModel
                                                    .supplierPerks![index],
                                                isFromList: false);
                                          },
                                        ),
                                        const SpaceVertical(32),
                                      ],
                                      if (state.perksModel.fisheryPerks !=
                                              null &&
                                          state.perksModel.fisheryPerks!
                                              .isNotEmpty) ...[
                                        CommonHeaderWithSeeAll(
                                          title: 'Latest Fishery Offers',
                                          onTap: state.perksModel.fisheryPerks!
                                                      .length <
                                                  4
                                              ? null
                                              : () {
                                                  OfferListScreen.navigateTo(
                                                    context,
                                                    (
                                                      title:
                                                          'Latest Fishery Offers',
                                                      perks: state.perksModel
                                                          .fisheryPerks!
                                                    ),
                                                  );
                                                },
                                          length: state
                                              .perksModel.fisheryPerks!.length,
                                        ),
                                        GridView.builder(
                                            shrinkWrap: true,
                                            itemCount: state.perksModel
                                                        .fisheryPerks!.length <
                                                    4
                                                ? state.perksModel.fisheryPerks
                                                    ?.length
                                                : 4,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                            ),
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 6,
                                              mainAxisSpacing: 10,
                                              mainAxisExtent: 160,
                                            ),
                                            itemBuilder: (context, index) {
                                              return OfferWidget(
                                                  perk: state.perksModel
                                                      .fisheryPerks![index],
                                                  isFromList: false);
                                            }),
                                        const SpaceVertical(40),
                                      ],
                                    ],
                                  )
                                : const SizedBox.shrink();
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CommonHeaderWithSeeAll extends StatelessWidget {
  const CommonHeaderWithSeeAll(
      {super.key,
      required this.title,
      required this.onTap,
      required this.length});

  final String title;
  final VoidCallback? onTap;
  final int? length;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: onTap != null ? 0 : 12,
      ),
      child: Row(
        children: [
          Text(
            title,
            style: context.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Visibility(
            visible: onTap != null,
            child: TextButton(
              onPressed: onTap,
              child: Text(
                'See All${length == null ? '' : ' ($length)'}',
                style: context.textTheme.bodyLarge?.copyWith(
                  color: AppColors.blue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
