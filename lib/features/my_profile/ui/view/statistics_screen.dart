import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:sb_mobile/core/constant/app_strings.dart';
import 'package:sb_mobile/core/routes/route_paths.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';
import 'package:sb_mobile/features/home_page/data/models/user_statistics.dart';
import 'package:sb_mobile/features/my_profile/cubit/my_profile_cubit.dart';
import 'package:sb_mobile/features/my_profile/ui/widgets/common_back_bar.dart';
import 'package:sb_mobile/features/my_profile/ui/widgets/profile_bar.dart';
import 'package:sb_mobile/features/my_profile/ui/widgets/statistics_item_widget.dart';

typedef StatisticsItem = ({
  String title,
  String subtitle,
});

class StatisticsScreen extends StatefulWidget {
  final UserStatistics userStatistics;
  const StatisticsScreen({super.key, required this.userStatistics});
  static PageRouteBuilder<dynamic> buildRouter(UserStatistics userStatistics) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          StatisticsScreen(userStatistics: userStatistics),
      settings: const RouteSettings(name: RoutePaths.statisticsScreen),
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

  static void navigateTo(BuildContext context, UserStatistics userStatistics) {
    Navigator.pushNamed(context, RoutePaths.statisticsScreen,
        arguments: userStatistics);
  }

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
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
  }

  @override
  Widget build(BuildContext context) {
    final List<StatisticsItem> statisticsItems = [
      (
        title: 'SESSIONS BOOKED',
        subtitle: widget.userStatistics.sessionsBooked.toString()
      ),
      (
        title: 'TOTAL SESSION HOURS',
        subtitle: '${widget.userStatistics.totalSessionHours?.toInt()} H',
      ),
      (
        title: 'FISH CAUGHT',
        subtitle: widget.userStatistics.fishCaught.toString(),
      ),
      (
        title: 'AVERAGE SESSION LENGTH',
        subtitle: '${widget.userStatistics.averageSessionLength} H',
      ),
      (
        title: 'AVERAGE SESSION VALUE',
        subtitle: '£${widget.userStatistics.averageSessionValue}',
      ),
      (
        title: 'FISHERY REVIEWS',
        subtitle: widget.userStatistics.fisheryReviews.toString(),
      ),
      (
        title: 'SPECIES CAUGHT',
        subtitle: widget.userStatistics.speciesCaught.toString(),
      ),
      (
        title: 'AVERAGE FISH WEIGHT',
        subtitle: widget.userStatistics.averageFishWeight ?? '',
      ),
      (
        title: 'MAXIMUM FISH WEIGHT',
        subtitle: widget.userStatistics.maximumFishWeight ?? '',
      ),
    ];
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileBar(
            level: 5,
            profile: (context.read<MyProfileCubit>().state as MyProfileLoaded)
                .profile,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: [
                const CommonBackBar(title: AppStrings.statistics),
                const SpaceVertical(20),
                ...statisticsItems.map(
                  (e) => StatisticsItemWidget(
                    title: e.title,
                    subtitle: e.subtitle,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
