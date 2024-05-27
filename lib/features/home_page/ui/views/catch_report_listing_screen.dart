import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_images.dart';
import 'package:sb_mobile/core/constant/app_strings.dart';
import 'package:sb_mobile/core/constant/ui_constant.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/routes/route_paths.dart';
import 'package:sb_mobile/features/home_page/data/sources/api/sb_backend.dart';
import 'package:sb_mobile/core/widgets/space_horizontal.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';
import 'package:sb_mobile/features/fishery_property_details/data/models/catch_report_model.dart';
import 'package:sb_mobile/features/fishery_property_details/ui/views/catch_report_detail_screen.dart';
import 'package:sb_mobile/features/my_profile/ui/widgets/common_back_bar.dart';
import 'package:sb_mobile/features/submit_catch_report/ui/views/submit_catch_report_screen.dart';

class CatchReportListingScreen extends StatefulWidget {
  const CatchReportListingScreen({super.key});

  @override
  State<CatchReportListingScreen> createState() =>
      _CatchReportListingScreenState();

  static MaterialPageRoute<dynamic> buildRouter() {
    return MaterialPageRoute(
      builder: (_) {
        return const CatchReportListingScreen();
      },
    );
  }

  static void navigateTo(BuildContext context) {
    Navigator.pushNamed(context, RoutePaths.catchReportListingScreen);
  }
}

class _CatchReportListingScreenState extends State<CatchReportListingScreen> {
  static const _pageSize = 25;

  final PagingController<int, CatchReport> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final SwimbookerApiProvider apiProvider = SwimbookerApiProvider();

      final catchReports =
          await apiProvider.getCatchReports(pageKey, _pageSize);
      if (catchReports != null) {
        final isLastPage = catchReports.length < _pageSize;
        if (isLastPage) {
          _pagingController.appendLastPage(catchReports);
        } else {
          final nextPageKey = pageKey + 1;
          _pagingController.appendPage(catchReports, nextPageKey);
        }
      } else {
        _pagingController.appendLastPage([]);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  (bool, String?) isPlusMember(
      BuildContext context, String? subscriptionLevel) {
    return (
      subscriptionLevel?.toLowerCase().contains('plus') == true ||
          subscriptionLevel?.toLowerCase().contains('pro') == true,
      subscriptionLevel
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SpaceVertical(30),
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
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
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
                  margin: const EdgeInsets.symmetric(
                      horizontal: defaultSidePadding),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14.0, vertical: 10),
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
              ],
            ),
          ),
          Theme(
            data: context.appTheme.copyWith(
              progressIndicatorTheme: const ProgressIndicatorThemeData(
                color: AppColors.blue,
              ),
            ),
            child: PagedSliverGrid<int, CatchReport>(
              showNewPageProgressIndicatorAsGridChild: false,
              showNewPageErrorIndicatorAsGridChild: false,
              showNoMoreItemsIndicatorAsGridChild: false,
              pagingController: _pagingController,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                childAspectRatio: 9 / 7,
              ),
              builderDelegate: PagedChildBuilderDelegate<CatchReport>(
                // firstPageProgressIndicatorBuilder: (context) =>
                //     const CircularProgressIndicator(
                //   color: AppColors.blue,
                // ),
                itemBuilder: (context, CatchReport catchReport, index) =>
                    GestureDetector(
                  onTap: () {
                    CatchReportDetailScreen.navigateTo(
                      context,
                      (
                        catchReport: catchReport,
                        isFromHomeScreen: true,
                        isFromMySb: false
                      ),
                    );
                  },
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: catchReport.imageUpload ?? "",
                        width: 116,
                        height: 94,
                        placeholder: (context, url) =>
                            Image.asset("assets/images/placeholder.jpg"),
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Image.asset(
                          AppImages.noImageUploaded,
                        ),
                      ),
                      Positioned(
                        top: 4,
                        left: 4,
                        child: Visibility(
                          visible: isPlusMember(
                                  context, catchReport.userSubscriptionLevel)
                              .$1,
                          child: Container(
                            height: 16,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xFF174A73),
                                  Color(0xFF062640),
                                ],
                              ),
                            ),
                            child: Text(
                              'PRO',
                              style: context.textTheme.bodySmall?.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 10,
                                fontFamily: mfontFamily,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
