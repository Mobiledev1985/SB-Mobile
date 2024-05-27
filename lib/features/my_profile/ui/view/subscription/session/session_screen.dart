import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_images.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/routes/route_paths.dart';
import 'package:sb_mobile/core/utility/utils/utils.dart';
import 'package:sb_mobile/core/widgets/space_horizontal.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';
import 'package:sb_mobile/features/authentication/data/models/angler_profile_details_model.dart';
import 'package:sb_mobile/features/my_profile/cubit/session/session_cubit.dart';
import 'package:sb_mobile/features/my_profile/ui/view/subscription/session/session_detail_screen.dart';
import 'package:sb_mobile/features/my_profile/ui/widgets/common_back_bar.dart';
import 'package:sb_mobile/features/my_profile/ui/widgets/profile_bar.dart';

class SessionScreen extends StatefulWidget {
  const SessionScreen({super.key, this.profile});
  final AnglerProfile? profile;

  static PageRouteBuilder<dynamic> buildRouter(AnglerProfile? profile) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          SessionScreen(profile: profile),
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

  static Future<void> navigateTo(
      BuildContext context, AnglerProfile? profile) async {
    await Navigator.pushNamed(context, RoutePaths.sessionScreen,
        arguments: profile);
  }

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  ValueNotifier<String> dateRange = ValueNotifier('');
  ValueNotifier<bool> clearFilter = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    context.read<SessionCubit>().getSessions();
  }

  String formatDateRange(DateTimeRange dateRange) {
    final startFormatted =
        "${dateRange.start.day}/${dateRange.start.month}/${dateRange.start.year % 100}";
    final endFormatted =
        "${dateRange.end.day}/${dateRange.end.month}/${dateRange.end.year % 100}";
    return "$startFormatted to $endFormatted";
  }

  @override
  void dispose() {
    dateRange.dispose();
    clearFilter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileBar(
              profile: widget.profile,
            ),
            const CommonBackBar(title: 'Sessions'),
            BlocBuilder<SessionCubit, SessionState>(
              builder: (context, state) {
                return state is SessionLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.blue,
                        ),
                      )
                    : state is SessionsList && state.sessions.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SpaceVertical(16),
                                Text(
                                  'A record of your previous InSessions™.',
                                  style: context.textTheme.bodyLarge
                                      ?.copyWith(fontWeight: FontWeight.w400),
                                ),
                                const SpaceVertical(24),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        showDateRangePicker(
                                          context: context,
                                          builder: (context, child) {
                                            return Theme(
                                              data: context.appTheme.copyWith(
                                                appBarTheme: context
                                                    .appTheme.appBarTheme
                                                    .copyWith(
                                                  backgroundColor:
                                                      AppColors.blue,
                                                ),
                                                datePickerTheme:
                                                    const DatePickerThemeData(
                                                  rangePickerHeaderBackgroundColor:
                                                      AppColors.blue,
                                                ),
                                              ),
                                              child: child!,
                                            );
                                          },
                                          firstDate:
                                              DateTime(DateTime.now().year - 1),
                                          lastDate:
                                              DateTime(DateTime.now().year + 1),
                                        ).then(
                                          (range) {
                                            if (range != null) {
                                              dateRange.value =
                                                  formatDateRange(range);
                                              clearFilter.value = true;
                                              context
                                                  .read<SessionCubit>()
                                                  .dateRangeFilter(range);
                                            }
                                          },
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            AppImages.dateIcon,
                                            colorFilter: const ColorFilter.mode(
                                              AppColors.black,
                                              BlendMode.srcIn,
                                            ),
                                            width: 32,
                                            height: 32,
                                            fit: BoxFit.cover,
                                          ),
                                          const SpaceHorizontal(8),
                                          ValueListenableBuilder(
                                            valueListenable: dateRange,
                                            builder: (context, range, _) {
                                              return Text(
                                                range.isEmpty
                                                    ? 'Select Date Range'
                                                    : range,
                                                style: context
                                                    .textTheme.bodyMedium
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      const Color(0xff7E7E7E),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    PopupMenuButton(
                                      icon: SvgPicture.asset(
                                        AppImages.filter,
                                        colorFilter: const ColorFilter.mode(
                                          AppColors.black,
                                          BlendMode.srcIn,
                                        ),
                                        width: 18,
                                        height: 24,
                                        fit: BoxFit.cover,
                                      ),
                                      itemBuilder: (BuildContext context) {
                                        return [
                                          const PopupMenuItem(
                                            value: 'Newest First',
                                            child: Text('Newest First'),
                                          ),
                                          const PopupMenuItem(
                                            value: 'Oldest First',
                                            child: Text('Oldest First'),
                                          ),
                                        ];
                                      },
                                      onSelected: (value) {
                                        clearFilter.value = true;
                                        context
                                            .read<SessionCubit>()
                                            .filter(value == 'Newest First');
                                      },
                                    ),
                                    ValueListenableBuilder(
                                        valueListenable: clearFilter,
                                        builder: (context, clear, _) {
                                          return Visibility(
                                            visible: clear,
                                            child: SizedBox(
                                              width: 60,
                                              height: 40,
                                              child: TextButton(
                                                onPressed: () {
                                                  clearFilter.value = false;
                                                  dateRange.value = '';
                                                  context
                                                      .read<SessionCubit>()
                                                      .clearFilter();
                                                },
                                                child: Text(
                                                  'Clear',
                                                  style: context
                                                      .textTheme.bodyMedium
                                                      ?.copyWith(
                                                    color: AppColors.blue,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        })
                                  ],
                                ),
                                const SpaceVertical(22),
                                ...state.sessions
                                    .map(
                                      (e) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 4.0,
                                        ),
                                        child: Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: CachedNetworkImage(
                                                imageUrl: e.imageUrl ?? '',
                                                height: 80,
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
                                                    .withOpacity(0.46),
                                                colorBlendMode:
                                                    BlendMode.srcATop,
                                              ),
                                            ),
                                            SizedBox(
                                              width: double.infinity,
                                              height: 80,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 14,
                                                  // vertical: 18,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 5,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          Flexible(
                                                            child: Text(
                                                              e.fisheryName ??
                                                                  '',
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: context
                                                                  .textTheme
                                                                  .headlineSmall
                                                                  ?.copyWith(
                                                                color: AppColors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            '${e.captures} Captures | ${e.sessionNoteCount} Session Notes',
                                                            style: context
                                                                .textTheme
                                                                .bodyMedium
                                                                ?.copyWith(
                                                              color: AppColors
                                                                  .white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Align(
                                                        alignment:
                                                            const Alignment(
                                                                1.0, 0.58),
                                                        child: Text(
                                                          convertDateWithSuffix(
                                                              e.endTs!),
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: context
                                                              .textTheme
                                                              .bodyMedium
                                                              ?.copyWith(
                                                            color:
                                                                AppColors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
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
                                                            10),
                                                  ),
                                                  onTap: () {
                                                    SessionDetailScreen
                                                        .navigateTo(context,
                                                            e.id ?? '');
                                                  },
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList(),
                                SpaceVertical(
                                    MediaQuery.paddingOf(context).bottom),
                              ],
                            ),
                          )
                        : Column(
                            children: [
                              SpaceVertical(
                                  MediaQuery.sizeOf(context).height * 0.20),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'You haven’t recorded\n any sessions yet!',
                                  textAlign: TextAlign.center,
                                  style: context.textTheme.headlineMedium
                                      ?.copyWith(
                                    color: AppColors.blue,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SpaceVertical(26),
                              Align(
                                alignment: Alignment.center,
                                child: RichText(
                                  text: TextSpan(
                                    text:
                                        'It’s time to get on the bank and\n get your rods out! Book your session\n online and go ',
                                    style:
                                        context.textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'In',
                                        style: context.textTheme.bodyLarge
                                            ?.copyWith(
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w900,
                                          color: AppColors.blue,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Session!',
                                        style: context.textTheme.bodyLarge
                                            ?.copyWith(
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w900,
                                          color: AppColors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          );
              },
            ),
          ],
        ),
      ),
    );
  }
}
