import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_images.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/routes/route_paths.dart';
import 'package:sb_mobile/core/widgets/back_button.dart';
import 'package:sb_mobile/core/widgets/space_horizontal.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';
import 'package:sb_mobile/features/my_profile/cubit/my_profile_cubit.dart';
import 'package:sb_mobile/features/my_profile/cubit/session/session_details_cubit.dart';
import 'package:sb_mobile/features/my_profile/data/models/session_detail_model.dart';
import 'package:sb_mobile/features/my_profile/ui/view/catches_screen.dart';
import 'package:sb_mobile/features/my_profile/ui/view/statistics_screen.dart';
import 'package:sb_mobile/features/my_profile/ui/widgets/profile_bar.dart';
import 'package:sb_mobile/features/my_profile/ui/widgets/sbplus/session/capture_gallery.dart';
import 'package:sb_mobile/features/my_profile/ui/widgets/sbplus/session/session_detail.dart';
import 'package:sb_mobile/features/my_profile/ui/widgets/sbplus/session/your_notes.dart';

typedef FishingStats = ({String title, dynamic value, bool isCatches});

class SessionDetailScreen extends StatefulWidget {
  final String sessionId;
  const SessionDetailScreen({super.key, required this.sessionId});

  static PageRouteBuilder<dynamic> buildRouter(String sessionId) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
        create: (context) => SessionDetailsCubit(),
        child: SessionDetailScreen(sessionId: sessionId),
      ),
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

  static void navigateTo(BuildContext context, String sessionId) {
    Navigator.pushNamed(context, RoutePaths.sessionDetailScreen,
        arguments: sessionId);
  }

  @override
  State<SessionDetailScreen> createState() => _SessionDetailScreenState();
}

class _SessionDetailScreenState extends State<SessionDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SessionDetailsCubit>().getSessionDetails(widget.sessionId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F8F8),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileBar(
            profile: (context.read<MyProfileCubit>().state as MyProfileLoaded)
                .profile,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SpaceVertical(24),
                    const BackButtonWidget(),
                    BlocBuilder<SessionDetailsCubit, SessionDetailsState>(
                      builder: (context, state) {
                        return state is SessionDetailsLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.blue,
                                ),
                              )
                            : state is SessionDetailsFailed
                                ? const Center(
                                    child: Text(
                                        'Server Error, please try again later.'),
                                  )
                                : state is SessionDetailsSuccess
                                    ? Column(
                                        children: [
                                          SessionDetail(
                                            sessionDetail: state.sessionDetail,
                                          ),
                                          CaptureGallery(
                                            catchReports: state
                                                .sessionDetail.catchReports!,
                                          ),
                                          YourNotes(
                                            sessionNotes: state
                                                .sessionDetail.sessionNotes,
                                          ),
                                          Card(
                                            elevation: 1,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 8),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 16.0,
                                                vertical: 14,
                                              ),
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    AppImages.fishingStats,
                                                  ),
                                                  const SpaceHorizontal(14),
                                                  Text(
                                                    'Fishing Stats',
                                                    style: context
                                                        .textTheme.displaySmall
                                                        ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Builder(builder: (context) {
                                            final CatchReportSummary?
                                                catchReportSummary = state
                                                    .sessionDetail
                                                    .catchReportSummary;
                                            final List<FishingStats>
                                                fishingStats = [
                                              (
                                                title: 'Fish Caught',
                                                value: catchReportSummary
                                                    ?.fishCaught,
                                                isCatches: true
                                              ),
                                              (
                                                title: 'Species Caught',
                                                value: catchReportSummary
                                                    ?.speciesCaught,
                                                isCatches: true
                                              ),
                                              (
                                                title: 'Avg. Weight',
                                                value: catchReportSummary
                                                    ?.averageFishWeight,
                                                isCatches: false
                                              ),
                                              (
                                                title: 'Max. Weight',
                                                value: catchReportSummary
                                                    ?.maximumFishWeight,
                                                isCatches: false
                                              ),
                                            ];
                                            return GridView.builder(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              padding: EdgeInsets.zero,
                                              shrinkWrap: true,
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                mainAxisSpacing: 6,
                                                crossAxisSpacing: 6,
                                                mainAxisExtent: 124,
                                              ),
                                              itemCount: fishingStats.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  elevation: 1,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 10,
                                                      vertical: 8.0,
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .stretch,
                                                      children: [
                                                        Text(
                                                          fishingStats[index]
                                                              .title,
                                                          style: context
                                                              .textTheme
                                                              .bodySmall
                                                              ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        const SpaceVertical(16),
                                                        Text(
                                                          '${fishingStats[index].value}',
                                                          style: context
                                                              .textTheme
                                                              .displayLarge
                                                              ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        const SpaceVertical(16),
                                                        Material(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                          color: const Color(
                                                              0xffBABABA),
                                                          child: InkWell(
                                                            onTap: () {
                                                              if (fishingStats[
                                                                      index]
                                                                  .isCatches) {
                                                                CatchesScreen.navigateTo(
                                                                    context,
                                                                    (context.read<MyProfileCubit>().state
                                                                            as MyProfileLoaded)
                                                                        .profile);
                                                              } else {
                                                                StatisticsScreen.navigateTo(
                                                                    context,
                                                                    (context.read<MyProfileCubit>().state
                                                                            as MyProfileLoaded)
                                                                        .userStatistics!);
                                                              }
                                                            },
                                                            splashColor:
                                                                AppColors.white,
                                                            customBorder:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                horizontal: 10,
                                                                vertical: 6.0,
                                                              ),
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    'View ${fishingStats[index].isCatches ? 'Catches' : 'Statistics'}',
                                                                    style: context
                                                                        .textTheme
                                                                        .bodySmall
                                                                        ?.copyWith(
                                                                      color: AppColors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                  const Spacer(),
                                                                  Image.asset(
                                                                    AppImages
                                                                        .share,
                                                                    width: 14,
                                                                    height: 14,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    color: AppColors
                                                                        .white,
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          }),
                                          const SpaceVertical(24),
                                        ],
                                      )
                                    : const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
