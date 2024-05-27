import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:intl/intl.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_strings.dart';
import 'package:sb_mobile/core/constant/ui_constant.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/routes/route_paths.dart';
import 'package:sb_mobile/core/utility/utils/utils.dart';
import 'package:sb_mobile/core/widgets/alert.dart';
import 'package:sb_mobile/core/widgets/custom_expansion_pannel.dart';
import 'package:sb_mobile/core/widgets/space_horizontal.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';
import 'package:sb_mobile/features/authentication/data/models/angler_profile_details_model.dart';
import 'package:sb_mobile/features/my_profile/cubit/booking_cubit.dart';
import 'package:sb_mobile/features/my_profile/data/models/booking_model.dart';
import 'package:sb_mobile/features/my_profile/ui/view/view_ticket_screen.dart';
import 'package:sb_mobile/features/my_profile/ui/widgets/booking_item_widget.dart';
import 'package:sb_mobile/features/my_profile/ui/widgets/common_back_bar.dart';
import 'package:sb_mobile/features/my_profile/ui/widgets/profile_bar.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key, this.profile});

  final AnglerProfile? profile;

  static PageRouteBuilder<dynamic> buildRouter(AnglerProfile? anglerProfile) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
        create: (context) => BookingCubit(),
        child: BookingsScreen(profile: anglerProfile),
      ),
      settings: const RouteSettings(name: RoutePaths.bookingsScreen),
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
    Navigator.pushNamed(context, RoutePaths.bookingsScreen, arguments: profile);
  }

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  final ValueNotifier<int> selectedTabIndex = ValueNotifier(0);
  final ValueNotifier<int> currentOpnedUpcomingBookingIndex = ValueNotifier(-1);
  final ValueNotifier<int> currentOpnedHistoricalIndex = ValueNotifier(-1);

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
    context.read<BookingCubit>().getBookings();
  }

  @override
  void dispose() {
    selectedTabIndex.dispose();
    currentOpnedHistoricalIndex.dispose();
    currentOpnedUpcomingBookingIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileBar(level: 5, profile: widget.profile),
            const CommonBackBar(title: 'Bookings'),
            const SpaceVertical(14),
            Card(
              color: AppColors.blue,
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
                        AppStrings.toSeeFull,
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
            const SpaceVertical(25),
            BlocConsumer<BookingCubit, BookingState>(
              listener: (context, state) {
                if (state is BookingFailed) {
                  showAlert('Failed to load bookings');
                }
              },
              builder: (context, state) {
                if (state is BookingLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.blue,
                    ),
                  );
                } else if (state is BookingLoaded) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: defaultSidePadding),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: const Color(0xffE0E0E0),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ValueListenableBuilder(
                            valueListenable: selectedTabIndex,
                            builder: (context, index, _) {
                              return Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      customBorder: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      onTap: () {
                                        selectedTabIndex.value = 0;
                                        currentOpnedUpcomingBookingIndex.value =
                                            -1;
                                        currentOpnedHistoricalIndex.value = -1;
                                      },
                                      child: Material(
                                        type: MaterialType.transparency,
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            color: index == 0
                                                ? AppColors.blue
                                                : const Color(0xffE0E0E0),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 10.0,
                                            ),
                                            child: Text(
                                              AppStrings.upcoming,
                                              textAlign: TextAlign.center,
                                              style: context
                                                  .textTheme.headlineSmall
                                                  ?.copyWith(
                                                color: AppColors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      customBorder: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      onTap: () {
                                        selectedTabIndex.value = 1;
                                      },
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: index == 1
                                              ? AppColors.blue
                                              : const Color(0xffE0E0E0),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 10.0,
                                          ),
                                          child: Text(
                                            AppStrings.historical,
                                            textAlign: TextAlign.center,
                                            style: context
                                                .textTheme.headlineSmall
                                                ?.copyWith(
                                              color: AppColors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                      const SpaceVertical(10),
                      ValueListenableBuilder(
                        valueListenable: selectedTabIndex,
                        builder: (context, i, _) {
                          return Column(
                            children: [
                              if (i == 0 &&
                                  state.bookingModel.upcoming!.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Text(
                                    'No upcoming bookings...',
                                    style: context.textTheme.displaySmall
                                        ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )
                              else if (i == 1 &&
                                  state.bookingModel.history!.isEmpty) ...[
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Text(
                                    'No Historical bookings...',
                                    style: context.textTheme.displaySmall
                                        ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )
                              ] else
                                ...List.generate(
                                  i == 0
                                      ? state.bookingModel.upcoming!.length
                                      : state.bookingModel.history!.length,
                                  (index) {
                                    final BookingItem bookingItem = (i == 0
                                        ? (state.bookingModel.upcoming?[index])
                                        : (state
                                            .bookingModel.history?[index]))!;
                                    return ValueListenableBuilder(
                                      valueListenable: i == 0
                                          ? currentOpnedUpcomingBookingIndex
                                          : currentOpnedHistoricalIndex,
                                      builder: (context, ind, _) {
                                        return CustomExpansionPanel(
                                          key: UniqueKey(),
                                          isOpenDefault: ind == index,
                                          onTap: () {
                                            if (i == 0) {
                                              currentOpnedUpcomingBookingIndex
                                                      .value =
                                                  currentOpnedHistoricalIndex
                                                              .value ==
                                                          index
                                                      ? -1
                                                      : index;
                                            } else {
                                              currentOpnedHistoricalIndex
                                                      .value =
                                                  currentOpnedHistoricalIndex
                                                              .value ==
                                                          index
                                                      ? -1
                                                      : index;
                                            }
                                          },
                                          header: Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: CachedNetworkImage(
                                                  imageUrl: bookingItem.image!,
                                                  height: i == 0 ? 110 : 74,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) =>
                                                      const Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: AppColors.blue,
                                                    ),
                                                  ),
                                                  color: Colors.black
                                                      .withOpacity(0.35),
                                                  colorBlendMode:
                                                      BlendMode.srcATop,
                                                ),
                                              ),
                                              SizedBox(
                                                width: double.infinity,
                                                height: i == 0 ? 110 : 74,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 14,
                                                    right: 14,
                                                    top: 8,
                                                    bottom: 18,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 5,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                '${bookingItem.name}',
                                                                maxLines: 2,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: context
                                                                    .textTheme
                                                                    .headlineMedium
                                                                    ?.copyWith(
                                                                  color:
                                                                      AppColors
                                                                          .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ),
                                                            Visibility(
                                                              visible: i == 0,
                                                              child: Text(
                                                                '${bookingItem.anglers} Anglers | ${bookingItem.guests} Guest',
                                                                style: context
                                                                    .textTheme
                                                                    .bodySmall
                                                                    ?.copyWith(
                                                                  color:
                                                                      AppColors
                                                                          .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 3,
                                                        child: Align(
                                                          alignment: i == 0
                                                              ? Alignment
                                                                  .bottomRight
                                                              : Alignment
                                                                  .centerRight,
                                                          child: Text(
                                                            convertDateWithSuffix(
                                                                bookingItem
                                                                    .arrival!),
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: context
                                                                .textTheme
                                                                .bodySmall
                                                                ?.copyWith(
                                                              color: AppColors
                                                                  .white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          body: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4.0),
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: double.infinity,
                                                  height: 36,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xffEBEBEB),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    AppStrings.bookingDetails,
                                                    style: context
                                                        .textTheme.headlineSmall
                                                        ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                const SpaceVertical(12),
                                                BookingItemWidget(
                                                  title: AppStrings.noOfAnlers,
                                                  value:
                                                      '${bookingItem.anglers}',
                                                  isFromTicketView: false,
                                                ),
                                                BookingItemWidget(
                                                  title: AppStrings.noOfGuests,
                                                  value:
                                                      '${bookingItem.guests}',
                                                  isFromTicketView: false,
                                                ),
                                                BookingItemWidget(
                                                  title: AppStrings.selected,
                                                  value:
                                                      '${bookingItem.selected}',
                                                  isFromTicketView: false,
                                                ),
                                                BookingItemWidget(
                                                  title: AppStrings.lake,
                                                  value: '${bookingItem.name}',
                                                  isFromTicketView: false,
                                                ),
                                                BookingItemWidget(
                                                  title:
                                                      AppStrings.arrivalDetails,
                                                  value: DateFormat(
                                                          'HH:mm - d/M/yyyy')
                                                      .format(
                                                    DateTime.parse(
                                                        bookingItem.arrival!),
                                                  ),
                                                  isFromTicketView: false,
                                                ),
                                                BookingItemWidget(
                                                  title: AppStrings
                                                      .departureDetails,
                                                  value: DateFormat(
                                                          'HH:mm - d/M/yyyy')
                                                      .format(
                                                    DateTime.parse(
                                                        bookingItem.departure!),
                                                  ),
                                                  isFromTicketView: false,
                                                ),
                                                const SpaceVertical(20),
                                                Builder(builder: (context) {
                                                  return Text.rich(
                                                    TextSpan(
                                                      text: AppStrings
                                                          .paymentTotal,
                                                      style: context.textTheme
                                                          .displaySmall
                                                          ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                              ' £${bookingItem.paymentTotal}',
                                                          style: context
                                                              .textTheme
                                                              .displaySmall
                                                              ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color:
                                                                AppColors.blue,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }),
                                                const SpaceVertical(16),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        AppColors.green,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    ViewTicketScreen.navigateTo(
                                                      context,
                                                      (
                                                        bookingItem:
                                                            bookingItem,
                                                        profile: widget.profile!
                                                      ),
                                                    );
                                                  },
                                                  child: const Text(
                                                    'VIEW TICKET',
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        AppColors.darkBlue,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pushNamed(
                                                      '/fishery/profile',
                                                      arguments: {
                                                        'id': "",
                                                        'publicId':
                                                            int.tryParse(
                                                                  bookingItem
                                                                          .fisheryPublicId ??
                                                                      '',
                                                                ) ??
                                                                0,
                                                      },
                                                    );
                                                  },
                                                  child: const Text(
                                                    'Visit Fishery Profile',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ).reversed,
                              const SpaceVertical(10),
                            ],
                          );
                        },
                      ),
                    ],
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
