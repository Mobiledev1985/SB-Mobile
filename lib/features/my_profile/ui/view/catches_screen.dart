import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_images.dart';
import 'package:sb_mobile/core/constant/app_strings.dart';
import 'package:sb_mobile/core/constant/ui_constant.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/routes/route_paths.dart';
import 'package:sb_mobile/core/widgets/space_horizontal.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';
import 'package:sb_mobile/features/authentication/data/models/angler_profile_details_model.dart';
import 'package:sb_mobile/features/fishery_property_details/ui/views/catch_report_detail_screen.dart';
import 'package:sb_mobile/features/my_profile/cubit/catches_cubit.dart';
import 'package:sb_mobile/features/my_profile/ui/widgets/common_back_bar.dart';
import 'package:sb_mobile/features/my_profile/ui/widgets/profile_bar.dart';
import 'package:sb_mobile/features/submit_catch_report/ui/views/submit_catch_report_screen.dart';

class CatchesScreen extends StatefulWidget {
  const CatchesScreen._(this.profile);
  final AnglerProfile? profile;
  static PageRouteBuilder<dynamic> buildRouter(AnglerProfile? profile) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          CatchesScreen._(profile),
      settings: const RouteSettings(name: RoutePaths.catchesScreen),
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

  static void navigateTo(BuildContext context, AnglerProfile? profile,
      [bool isFromEditCatchReport = false]) {
    if (isFromEditCatchReport) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        RoutePaths.catchesScreen,
        (route) {
          return route.settings.name == '/';
        },
        arguments: profile,
      );
    } else {
      Navigator.pushNamed(
        context,
        RoutePaths.catchesScreen,
        arguments: profile,
      );
    }
  }

  @override
  State<CatchesScreen> createState() => _CatchesScreenState();
}

class _CatchesScreenState extends State<CatchesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CatchesCubit>().getCatchReports();
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
            const CommonBackBar(title: AppStrings.catchReports),
            IntrinsicWidth(
              child: TextButton(
                onPressed: () {
                  SubmitCatchReportScreen.navigateTo(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SpaceHorizontal(6),
                    Text(
                      AppStrings.submitCatchReport,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                    )
                  ],
                ),
              ),
            ),
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
                        AppStrings.tosee,
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
            BlocBuilder<CatchesCubit, CatchesState>(
              builder: (context, state) {
                if (state is CatchesLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.blue,
                    ),
                  );
                } else if (state is CatchesLoaded) {
                  return Column(
                    children: state.cathesList
                        .map(
                          (e) => Visibility(
                            visible: e.reports != null && e.reports!.isNotEmpty,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: defaultSidePadding,
                                  ),
                                  child: Text(
                                    e.name ?? '',
                                    style: context.textTheme.displaySmall
                                        ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SpaceVertical(6),
                                if (e.address != null &&
                                    e.address?.city != null) ...[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: defaultSidePadding,
                                    ),
                                    child: Text(
                                      "${e.address?.city}, ${e.address?.postcode}",
                                      style: context.textTheme.bodySmall,
                                    ),
                                  ),
                                ],
                                const SpaceVertical(16),
                                GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: defaultSidePadding),
                                  shrinkWrap: true,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 2,
                                    mainAxisSpacing: 2,
                                    childAspectRatio: 9 / 7,
                                  ),
                                  itemCount: e.reports?.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () {
                                        if (e.name == 'Other Fisheries') {
                                          e.reports![index].isNonSb = true;
                                        }
                                        CatchReportDetailScreen.navigateTo(
                                          context,
                                          (
                                            catchReport: e.reports![index],
                                            isFromHomeScreen: false,
                                            isFromMySb: true
                                          ),
                                        );
                                      },
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            e.reports?[index].imageUpload ?? "",
                                        width: 116,
                                        height: 94,
                                        fit: BoxFit.cover,
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                          AppImages.noImageUploaded,
                                          width: 116,
                                          height: 94,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SpaceVertical(35),
                              ],
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
          ],
        ),
      ),
    );
  }
}
