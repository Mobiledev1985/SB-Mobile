import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_images.dart';
import 'package:sb_mobile/core/constant/ui_constant.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/utility/utils/utils.dart';
import 'package:sb_mobile/core/widgets/space_horizontal.dart';
import 'package:sb_mobile/features/fishery_property_details/data/models/catch_report_model.dart';
import 'package:sb_mobile/features/fishery_property_details/ui/views/catch_report_detail_screen.dart';

class CatchReportListView extends StatelessWidget {
  final bool isFromHomeScreen;
  final List<CatchReport> catchReports;

  const CatchReportListView(
      {super.key, required this.catchReports, required this.isFromHomeScreen});
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
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: 174,
      child: ListView.separated(
        shrinkWrap: true,
        primary: false,
        scrollDirection: Axis.horizontal,
        padding:
            const EdgeInsets.only(left: defaultPadding, right: defaultPadding),
        itemCount: catchReports.length,
        itemBuilder: (context, index) {
          final CatchReport catchReport = catchReports[index];
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: catchReport.imageUpload!,
                  width: 248,
                  height: 174,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Image.asset(
                    'assets/images/placeholder.jpg',
                    width: 248,
                    height: 174,
                    fit: BoxFit.cover,
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    AppImages.noImageUploaded,
                    width: 248,
                    height: 174,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Visibility(
                  visible:
                      isPlusMember(context, catchReport.userSubscriptionLevel)
                          .$1,
                  child: Container(
                    height: 22,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
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
                        fontFamily: mfontFamily,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Icon(
                          Icons.location_on_sharp,
                          size: 12,
                          color: Colors.white,
                        ),
                        const SpaceHorizontal(4),
                        Expanded(
                          child: Text(
                            catchReport.fishery ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodySmall?.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SpaceHorizontal(4),
                        SvgPicture.asset(
                          AppImages.dateIcon,
                          width: 12,
                          height: 12,
                          colorFilter: const ColorFilter.mode(
                              AppColors.white, BlendMode.srcIn),
                        ),
                        const SpaceHorizontal(2),
                        Text(
                          dateFormat(catchReport.fishCaughtDate!),
                          style: textTheme.bodySmall?.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 25,
                left: 25,
                right: 25,
                child: Container(
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Icon(
                          Icons.description_sharp,
                          size: 18,
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 7),
                          child: Text(
                            "${catchReport.fishSpecies}",
                            // "${catchReport.fishSpecies} | ${catchReport.fishWeightLb}lb ${catchReport.fishWeightOz}oz",
                            style: textTheme.bodyMedium?.copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
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
                  color: Colors.transparent,
                  child: InkWell(
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onTap: () {
                      CatchReportDetailScreen.navigateTo(
                        context,
                        (
                          catchReport: catchReport,
                          isFromHomeScreen: isFromHomeScreen,
                          isFromMySb: false
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
        separatorBuilder: (context, index) => const SpaceHorizontal(6),
      ),
    );
  }
}
