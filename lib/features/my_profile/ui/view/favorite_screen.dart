import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_images.dart';
import 'package:sb_mobile/core/constant/ui_constant.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/routes/route_paths.dart';
import 'package:sb_mobile/core/widgets/alert.dart';
import 'package:sb_mobile/core/widgets/space_horizontal.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';
import 'package:sb_mobile/features/authentication/data/models/angler_profile_details_model.dart';
import 'package:sb_mobile/features/my_profile/cubit/favourite_cubit.dart';
import 'package:sb_mobile/features/my_profile/ui/widgets/common_back_bar.dart';
import 'package:sb_mobile/features/my_profile/ui/widgets/profile_bar.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen._(this.profile);
  final AnglerProfile? profile;
  static PageRouteBuilder<dynamic> buildRouter(AnglerProfile? anglerProfile) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          FavoriteScreen._(anglerProfile),
      settings: const RouteSettings(name: RoutePaths.favoritesScreen),
      transitionsBuilder: (_, animation, __, child) {
        final tween = Tween<double>(begin: 0.0, end: 1.0).chain(
          CurveTween(curve: Curves.ease), // Replace with your desired curve
        );
        return FadeTransition(
          opacity: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
    );
  }

  static void navigateTo(BuildContext context, AnglerProfile? profile) {
    Navigator.pushNamed(context, RoutePaths.favoritesScreen,
        arguments: profile);
  }

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FavouriteCubit>().getFavourites();
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileBar(
              level: 5,
              profile: widget.profile,
            ),
            const CommonBackBar(title: 'Favourites'),
            const SpaceVertical(14),
            Card(
              color: const Color(0xffC14F40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin:
                  const EdgeInsets.symmetric(horizontal: defaultSidePadding),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info,
                      color: AppColors.white,
                    ),
                    const SpaceHorizontal(14),
                    Expanded(
                      child: Text(
                        'If you wish to remove a favourite from your account, simply press the heart icon.',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SpaceVertical(10),
            BlocConsumer<FavouriteCubit, FavouriteState>(
              listener: (context, state) {
                if (state is FavouriteFailed) {
                  showAlert('Falid to load Favourites');
                }
              },
              builder: (context, state) {
                if (state is FavouriteLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.blue,
                    ),
                  );
                } else if (state is FavouriteLoaded) {
                  return Column(
                    children: state.favourites
                        .map(
                          (e) => GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                '/fishery/profile',
                                arguments: {
                                  'id': "",
                                  'publicId': e.publicId,
                                },
                              ).then(
                                (value) {
                                  Future.delayed(Durations.medium4).then(
                                    (value) {
                                      if (Platform.isAndroid) {
                                        SystemChrome.setSystemUIOverlayStyle(
                                          const SystemUiOverlayStyle(
                                              statusBarColor:
                                                  Colors.transparent,
                                              statusBarIconBrightness:
                                                  Brightness.light),
                                        );
                                      } else {
                                        FlutterStatusbarcolor
                                            .setStatusBarWhiteForeground(true);
                                        FlutterStatusbarcolor.setStatusBarColor(
                                            Colors.transparent);
                                      }
                                    },
                                  );
                                },
                              );
                            },
                            child: Card(
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Stack(
                                  children: [
                                    Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl: e.image,
                                            width: double.infinity,
                                            height: 150.h,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 12.0,
                                            right: 15,
                                            left: 15,
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 5,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      e.name,
                                                      style: context.textTheme
                                                          .headlineSmall
                                                          ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: const Color(
                                                            0xff062640),
                                                      ),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    const SpaceVertical(4),
                                                    Text(
                                                      "${e.city.trim()}, ${e.postCode}",
                                                      style: context
                                                          .textTheme.bodySmall
                                                          ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: AppColors.blue,
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 8,
                                                      backgroundColor:
                                                          const Color(
                                                              0xff174A73),
                                                      child: SvgPicture.asset(
                                                        AppImages.sea,
                                                      ),
                                                    ),
                                                    const SpaceHorizontal(10),
                                                    Text(
                                                      '${e.numLakes} lakes',
                                                      style: context
                                                          .textTheme.bodyMedium
                                                          ?.copyWith(
                                                        color: const Color(
                                                            0xff737A80),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 4,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 8,
                                                      backgroundColor:
                                                          const Color(
                                                              0xff174A73),
                                                      child: Image.asset(
                                                        'assets/icons/fish.png',
                                                        width: 14,
                                                        height: 14,
                                                      ),
                                                    ),
                                                    const SpaceHorizontal(10),
                                                    Text(
                                                      'Up to ${e.maxLbs}lbs',
                                                      style: context
                                                          .textTheme.bodyMedium
                                                          ?.copyWith(
                                                        color: const Color(
                                                            0xff737A80),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SpaceVertical(10),
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 10,
                                          ),
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10),
                                              topLeft: Radius.circular(5),
                                              topRight: Radius.circular(5),
                                            ),
                                            color: Color(0xffF2F6FA),
                                          ),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                AppImages.fishWithEye,
                                              ),
                                              const SpaceHorizontal(10),
                                              Text(
                                                '${e.totalReviews} ratings | ${e.totalComments} reviews',
                                                style: context
                                                    .textTheme.bodyMedium
                                                    ?.copyWith(
                                                  color: AppColors.blue,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const Spacer(),
                                              IntrinsicWidth(
                                                child: SizedBox(
                                                  height: 30,
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pushNamed(
                                                        '/fishery/profile',
                                                        arguments: {
                                                          'id': "",
                                                          'publicId':
                                                              e.publicId,
                                                        },
                                                      ).then(
                                                        (value) {
                                                          Future.delayed(
                                                                  Durations
                                                                      .medium4)
                                                              .then(
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
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'View Profile',
                                                          style: context
                                                              .textTheme
                                                              .bodySmall
                                                              ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: const Color(
                                                                0xffF2F6FA),
                                                          ),
                                                        ),
                                                        const SpaceHorizontal(
                                                            9),
                                                        Container(
                                                          width: 16,
                                                          height: 16,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2),
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                              color: AppColors
                                                                  .white,
                                                            ),
                                                          ),
                                                          child:
                                                              const FittedBox(
                                                            child: Icon(
                                                              Icons
                                                                  .arrow_forward_ios,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Positioned(
                                      top: 10,
                                      right: 10,
                                      child: GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                FavouriteDialog(
                                              favouriteName: e.name,
                                              onRemove: () async {
                                                await context
                                                    .read<FavouriteCubit>()
                                                    .updateFavourites(e.id)
                                                    .then(
                                                  (value) {
                                                    Navigator.pop(context);
                                                  },
                                                );
                                              },
                                            ),
                                          );
                                        },
                                        child: SvgPicture.asset(
                                          AppImages.favouriteIcon1,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
            const SpaceVertical(20),
          ],
        ),
      ),
    );
  }
}

//  Padding(
//                           padding = const EdgeInsets.symmetric(
//                             horizontal: defaultSidePadding,
//                             vertical: 8,
//                           ),
//                           child = Column(
//                             children: [
//                               Stack(
//                                 children: [
//                                   ClipRRect(
//                                     borderRadius: const BorderRadius.only(
//                                       topLeft: Radius.circular(10),
//                                       topRight: Radius.circular(10),
//                                     ),
//                                     child: CachedNetworkImage(
//                                       imageUrl: e.image,
//                                       height: 170,
//                                       width: double.infinity,
//                                       fit: BoxFit.cover,
//                                     ),
//                                   ),
//                                   Positioned.fill(
//                                     child: Material(
//                                       type: MaterialType.transparency,
//                                       child: InkWell(
//                                         customBorder: RoundedRectangleBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(
//                                                     defaultBorderRadius)),
//                                         onTap: () {
//                                           Navigator.of(context).pushNamed(
//                                             '/fishery/profile',
//                                             arguments: {
//                                               'id': "",
//                                               'publicId': e.publicId,
//                                             },
//                                           );
//                                         },
//                                       ),
//                                     ),
//                                   ),
//                                   Positioned(
//                                     top: 0,
//                                     right: 0,
//                                     child: ClipOval(
//                                       child: Material(
//                                         type: MaterialType.transparency,
//                                         child: IconButton(
//                                           onPressed: () {
//                                             showDialog(
//                                               context: context,
//                                               builder: (context) =>
//                                                   FavouriteDialog(
//                                                 favouriteName: e.name,
//                                                 onRemove: () async {
//                                                   await context
//                                                       .read<FavouriteCubit>()
//                                                       .updateFavourites(e.id)
//                                                       .then(
//                                                     (value) {
//                                                       Navigator.pop(context);
//                                                     },
//                                                   );
//                                                 },
//                                               ),
//                                             );
//                                           },
//                                           icon: const Icon(
//                                             Icons.favorite_outlined,
//                                             color: Color(0xffC14F40),
//                                             size: 34,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   vertical: 10,
//                                 ),
//                                 decoration: const BoxDecoration(
//                                   borderRadius: BorderRadius.only(
//                                     bottomLeft: Radius.circular(10),
//                                     bottomRight: Radius.circular(10),
//                                   ),
//                                   color: AppColors.blue,
//                                 ),
//                                 width: double.infinity,
//                                 alignment: Alignment.center,
//                                 child: Text(
//                                   e.name,
//                                   style: context.textTheme.headlineSmall
//                                       ?.copyWith(
//                                     fontWeight: FontWeight.bold,
//                                     color: AppColors.white,
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),

typedef FutureFunction = Future<void> Function();

class FavouriteDialog extends StatefulWidget {
  final String favouriteName;
  final FutureFunction onRemove;
  const FavouriteDialog({
    super.key,
    required this.favouriteName,
    required this.onRemove,
  });

  @override
  State<FavouriteDialog> createState() => _FavouriteDialogState();
}

class _FavouriteDialogState extends State<FavouriteDialog> {
  ValueNotifier isLoading = ValueNotifier(false);

  @override
  void dispose() {
    isLoading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: IntrinsicHeight(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 22.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Remove Venue From Favourites',
                textAlign: TextAlign.center,
                style: context.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SpaceVertical(14),
              Text(
                'Are you sure you want to remove ${widget.favouriteName} from your favourites?',
                textAlign: TextAlign.center,
                style: context.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SpaceVertical(24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 100,
                    height: 36,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        backgroundColor: const Color(0xffC4C4C4),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: context.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    height: 36,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        backgroundColor: const Color(0xffC14F40),
                      ),
                      onPressed: () async {
                        isLoading.value = true;
                        await widget.onRemove.call();
                        isLoading.value = false;
                      },
                      child: ValueListenableBuilder(
                        valueListenable: isLoading,
                        builder: (context, isLoading, _) {
                          return isLoading
                              ? const CircularProgressIndicator(
                                  color: AppColors.white,
                                )
                              : Text(
                                  'Remove',
                                  style: context.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.white,
                                  ),
                                );
                        },
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
