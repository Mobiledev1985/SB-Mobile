import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_images.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/routes/route_paths.dart';
import 'package:sb_mobile/core/widgets/space_horizontal.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';
import 'package:sb_mobile/features/authentication/data/models/angler_profile_details_model.dart';
import 'package:sb_mobile/features/my_profile/cubit/giveaway_cubit.dart';
import 'package:sb_mobile/features/my_profile/data/models/giveaway_quiz_model.dart';
import 'package:sb_mobile/features/my_profile/data/models/winner_model.dart';
import 'package:sb_mobile/features/my_profile/ui/widgets/common_back_bar.dart';
import 'package:sb_mobile/features/my_profile/ui/widgets/profile_bar.dart';
import 'package:sb_mobile/features/my_profile/ui/widgets/sbplus/giveaway/question_section.dart';
import 'package:sb_mobile/features/my_profile/data/source/sb_backend.dart';

class Options {
  String option;
  bool isSelected;
  Options({
    required this.option,
    required this.isSelected,
  });
}

class GiveawaysScreen extends StatefulWidget {
  const GiveawaysScreen({super.key, this.profile});

  final AnglerProfile? profile;

  static PageRouteBuilder<dynamic> buildRouter(AnglerProfile? profile) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => GiveawayCubit(),
          ),
        ],
        child: GiveawaysScreen(profile: profile),
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

  static Future<void> navigateTo(
      BuildContext context, AnglerProfile? profile) async {
    await Navigator.pushNamed(context, RoutePaths.giveawayScreen,
        arguments: profile);
  }

  @override
  State<GiveawaysScreen> createState() => _GiveawaysScreenState();
}

class _GiveawaysScreenState extends State<GiveawaysScreen> {
  static const _pageSize = 10;
  final PagingController<int, WinnerModel> _pagingController =
      PagingController(firstPageKey: 0);
  @override
  void initState() {
    super.initState();
    context.read<GiveawayCubit>().getGiveawayQuizzes();
    _pagingController.addPageRequestListener((pageKey) {
      _giveawayWinnerList(pageKey);
    });
  }

  Future<void> _giveawayWinnerList(int pageKey) async {
    try {
      final SwimbookerApiProvider apiProvider = SwimbookerApiProvider();

      final List<WinnerModel>? winners =
          await apiProvider.getListOfAllWinners(pageKey, _pageSize);
      if (winners != null) {
        final isLastPage = winners.length < _pageSize;
        if (isLastPage) {
          _pagingController.appendLastPage(winners);
        } else {
          final nextPageKey = pageKey + 1;
          _pagingController.appendPage(winners, nextPageKey);
        }
      } else {
        _pagingController.appendLastPage([]);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: ProfileBar(
              level: 5,
              profile: widget.profile,
            ),
          ),
          const SliverToBoxAdapter(child: CommonBackBar(title: 'Giveaways')),
          SliverToBoxAdapter(
            child: BlocBuilder<GiveawayCubit, GiveawayState>(
              builder: (context, state) {
                return state is GiveawayLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.blue,
                        ),
                      )
                    : state is GiveawayFailed
                        ? Center(
                            child: Text(state.message),
                          )
                        : state is GiveawaySuccess
                            ? Column(
                                children: [
                                  Visibility(
                                    visible: state.giveawayQuizzes.isNotEmpty,
                                    child: Column(
                                      children: [
                                        ...List.generate(
                                            state.giveawayQuizzes.length,
                                            (index) {
                                          final GiveawayQuizModel quiz =
                                              state.giveawayQuizzes[index];
                                          final List<Options> options = [
                                            Options(
                                              option: quiz.option1 ?? '',
                                              isSelected: false,
                                            ),
                                            Options(
                                              option: quiz.option2 ?? '',
                                              isSelected: false,
                                            ),
                                            Options(
                                              option: quiz.option3 ?? '',
                                              isSelected: false,
                                            ),
                                          ];
                                          final ValueNotifier<bool> isLoading =
                                              ValueNotifier(false);

                                          return Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0),
                                                child: Column(
                                                  children: [
                                                    Stack(
                                                      alignment:
                                                          Alignment.topCenter,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            top: 42,
                                                          ),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(20),
                                                              topRight: Radius
                                                                  .circular(
                                                                20,
                                                              ),
                                                            ),
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl:
                                                                  quiz.bannerImage ??
                                                                      '',
                                                              width: double
                                                                  .infinity,
                                                              height: 236,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                        Positioned(
                                                          top: 21,
                                                          child: Container(
                                                            width: 240,
                                                            height: 42,
                                                            alignment: Alignment
                                                                .center,
                                                            decoration:
                                                                BoxDecoration(
                                                              gradient:
                                                                  const LinearGradient(
                                                                colors: [
                                                                  Color(
                                                                      0xff101010),
                                                                  Color(
                                                                      0xff404040),
                                                                ],
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50),
                                                              border: Border.all(
                                                                  color: AppColors
                                                                      .dividerColor),
                                                            ),
                                                            child: Text(
                                                              quiz.endTs != null
                                                                  ? 'Draw: ${DateFormat('EEE d MMM').format(DateTime.parse(quiz.endTs!))}'
                                                                  : '',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headlineSmall
                                                                  ?.copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: AppColors
                                                                        .white,
                                                                  ),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    Container(
                                                      decoration:
                                                          const BoxDecoration(
                                                        gradient:
                                                            LinearGradient(
                                                          colors: [
                                                            Color(0xff101010),
                                                            Color(0xff404040),
                                                          ],
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  20),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  20),
                                                        ),
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          const SpaceVertical(
                                                              20),
                                                          Stack(
                                                            children: [
                                                              const Positioned(
                                                                top: 24,
                                                                left: 14,
                                                                right: 14,
                                                                child: Divider(
                                                                  color: Color(
                                                                      0xff0074B4),
                                                                  thickness: 2,
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                  horizontal:
                                                                      20.0,
                                                                ),
                                                                child:
                                                                    CountdownTimer(
                                                                  targetDateTime:
                                                                      DateTime.parse(
                                                                          quiz.endTs!),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SpaceVertical(
                                                              22),
                                                          Visibility(
                                                            visible:
                                                                quiz.ticketNumber ==
                                                                    null,
                                                            child: Text(
                                                              quiz.question ??
                                                                  '',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: context
                                                                  .textTheme
                                                                  .headlineMedium
                                                                  ?.copyWith(
                                                                color: AppColors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          ),
                                                          const SpaceVertical(
                                                              18),
                                                          ValueListenableBuilder(
                                                            valueListenable:
                                                                isLoading,
                                                            builder: (_,
                                                                loading, __) {
                                                              return loading
                                                                  ? const Center(
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsets.only(
                                                                            top:
                                                                                18,
                                                                            bottom:
                                                                                36.0),
                                                                        child:
                                                                            CircularProgressIndicator(
                                                                          color:
                                                                              AppColors.white,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : QuestionSection(
                                                                      options:
                                                                          options,
                                                                      questionState:
                                                                          quiz.questionState!,
                                                                      ticketNumber:
                                                                          quiz.ticketNumber,
                                                                      onTap:
                                                                          () async {
                                                                        isLoading.value =
                                                                            true;
                                                                        await context.read<GiveawayCubit>().onAnswer(
                                                                            quiz,
                                                                            options.firstWhere((element) => element.isSelected).option);

                                                                        isLoading.value =
                                                                            false;
                                                                      },
                                                                    );
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              const SpaceVertical(22),
                                              Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    vertical: 18.0,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SvgPicture.asset(
                                                        AppImages.gift,
                                                      ),
                                                      const SpaceHorizontal(8),
                                                      Text(
                                                        'PRIZES!',
                                                        style: context.textTheme
                                                            .displaySmall
                                                            ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      const SpaceHorizontal(8),
                                                      SvgPicture.asset(
                                                        AppImages.gift,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SpaceVertical(16),
                                              SizedBox(
                                                width: double.infinity,
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 18.0),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Text(
                                                        quiz.title ?? '',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: context.textTheme
                                                            .headlineMedium
                                                            ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SpaceVertical(16),
                                              SizedBox(
                                                width: double.infinity,
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 22.0),
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          'This weeks prize theme:',
                                                          style: context
                                                              .textTheme
                                                              .displaySmall
                                                              ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        const SpaceVertical(8),
                                                        SizedBox(
                                                          width:
                                                              double.infinity,
                                                          child: Card(
                                                            color: const Color(
                                                                0xffF8FAFA),
                                                            margin:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        16),
                                                            shape:
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
                                                                vertical: 14,
                                                              ),
                                                              child: Text(
                                                                quiz.giveawayTheme ??
                                                                    '',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: context
                                                                    .textTheme
                                                                    .displaySmall
                                                                    ?.copyWith(),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 26.0,
                                                ),
                                                child: Divider(
                                                  color: Color(0xffEBEBEB),
                                                  thickness: 2,
                                                ),
                                              ),
                                            ],
                                          );
                                        }),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox.shrink();
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(AppImages.party),
                        const SpaceHorizontal(12),
                        Text(
                          'Giveaway Winners',
                          style: context.textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SpaceVertical(16),
              ],
            ),
          ),
          PagedSliverList<int, WinnerModel>(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<WinnerModel>(
              itemBuilder: (context, winnerModel, index) {
                return Stack(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: 62,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xff005886),
                            Color(0xff3992C9),
                          ],
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SvgPicture.asset(
                            AppImages.multipleFish,
                          ),
                          Row(
                            children: [
                              Text(
                                winnerModel.winnerName ?? '',
                                style: context.textTheme.displaySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.white,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  winnerModel.prize ?? '',
                                  textAlign: TextAlign.end,
                                  style: context.textTheme.bodyLarge?.copyWith(
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SliverToBoxAdapter(
            child: SpaceVertical(18),
          )
        ],
      ),
    );
  }
}

class CountdownTimer extends StatefulWidget {
  final DateTime targetDateTime;

  const CountdownTimer({super.key, required this.targetDateTime});

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;
  Duration _remainingTime = Duration.zero;

  final List<String> durations = [
    "DAYS",
    "HRS",
    "MINS",
    "SECS",
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      if (widget.targetDateTime.isBefore(now)) {
        _timer.cancel();
        return;
      }

      setState(() {
        _remainingTime = widget.targetDateTime.difference(now);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<int> time = [
      _remainingTime.inDays,
      _remainingTime.inHours.remainder(24),
      _remainingTime.inMinutes.remainder(60),
      _remainingTime.inSeconds.remainder(60)
    ];

    return Row(
      children: [
        ...List.generate(
          durations.length,
          (index) => Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 14,
              ),
              margin: const EdgeInsets.symmetric(
                horizontal: 5,
              ),
              decoration: BoxDecoration(
                color: const Color(0xff606060),
                borderRadius: BorderRadius.circular(
                  10,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    time[index].toString(),
                    style: context.textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                  const SpaceVertical(2),
                  Text(
                    durations[index],
                    style: context.textTheme.bodySmall?.copyWith(
                      color: const Color(0xffDEB33F),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
