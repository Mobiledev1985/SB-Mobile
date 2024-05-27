import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sb_mobile/core/constant/app_images.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/widgets/space_horizontal.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';
import 'package:sb_mobile/features/fishery_property_details/data/models/catch_report_model.dart';
import 'package:sb_mobile/features/fishery_property_details/ui/views/catch_report_detail_screen.dart';

class CaptureGallery extends StatelessWidget {
  final List<CatchReport?> catchReports;

  const CaptureGallery({super.key, required this.catchReports});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 14,
        ),
        child: Column(
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  AppImages.gallery,
                ),
                const SpaceHorizontal(14),
                Text(
                  'Capture Gallery',
                  style: context.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SpaceVertical(14),
            catchReports.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'No Catch Reports Uploaded',
                      textAlign: TextAlign.center,
                      style: context.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : GridView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                      mainAxisExtent: 84,
                    ),
                    itemCount: catchReports.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          CatchReportDetailScreen.navigateTo(
                            context,
                            (
                              catchReport: catchReports[index]!,
                              isFromHomeScreen: false,
                              isFromMySb: false,
                            ),
                          );
                        },
                        child: CachedNetworkImage(
                          imageUrl: catchReports[index]?.imageUpload ?? '',
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
