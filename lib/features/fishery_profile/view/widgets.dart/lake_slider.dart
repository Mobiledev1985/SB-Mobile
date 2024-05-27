import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/widgets/space_horizontal.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';
import 'package:sb_mobile/features/fishery_property_details/ui/views/lake_details_page.dart';
import '../../../fishery_property_details/data/models/fishery_details.dart';
import '../../../fishery_property_details/data/models/property_details/lake_details.dart';
import '../../../fishery_property_details/data/models/property_details/lakes.dart';

class LakeSlider extends StatefulWidget {
  const LakeSlider({
    Key? key,
    required this.fishery,
  }) : super(key: key);

  final FisheryPropertyDetails fishery;

  @override
  State<LakeSlider> createState() => _LakeSliderState();
}

class _LakeSliderState extends State<LakeSlider> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 232,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 33.0),
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.fishery.lakes.length,
              itemBuilder: (context, index) {
                final SBLake lake = widget.fishery.lakes[index];
                final LakeMetaDetails lakeDetails =
                    widget.fishery.lakeDetails.lakes[index];
                // print(lakeDetails);
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LakeDetailsPage(
                            lake: lake, lakeDetails: lakeDetails),
                      ),
                    );
                  },
                  child: _LakeSiderItem(
                    lake: lake,
                    lakeDetails: lakeDetails,
                  ),
                );
              },
            ),
          ),
        ),
        Positioned(
          top: 118,
          left: 0,
          child: GestureDetector(
            onTap: () {
              _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease,
              );
            },
            child: const Icon(Icons.chevron_left),
          ),
        ),
        Positioned(
          top: 118,
          right: 0,
          child: GestureDetector(
            onTap: () {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease,
              );
            },
            child: const Icon(
              Icons.chevron_right,
            ),
          ),
        ),
      ],
    );
  }
}

class _LakeSiderItem extends StatelessWidget {
  const _LakeSiderItem({
    Key? key,
    required this.lake,
    required this.lakeDetails,
  }) : super(key: key);

  final SBLake lake;
  final LakeMetaDetails lakeDetails;
  @override
  Widget build(BuildContext context) {
    // TextStyle lakeDetailTitleStyle = TextStyle(
    //     fontSize: 16.sp,
    //     fontFamily: appStyles.fontGilroy,
    //     fontWeight: FontWeight.bold,
    //     color: Colors.black);
    // TextStyle lakeDetailStyle = TextStyle(
    //     fontSize: 16.sp, fontFamily: appStyles.fontGilroy, color: Colors.black);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 2.0),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: lake.images.primary,
                placeholder: (context, url) =>
                    Image.asset("assets/images/placeholder.jpg"),
                width: double.infinity,
                height: 119,
                errorWidget: (context, url, error) =>
                    Image.asset("assets/images/placeholder.jpg"),
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lake.name,
                          style: context.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: const Color(0xff062640),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SpaceVertical(4),
                        Text(
                          lake.accommodation
                              ? 'Public'
                              : "${lake.accessType[0].toUpperCase()}${lake.accessType.substring(1).toLowerCase()}",
                          style: context.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColors.blue,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "Max Size: ${lake.maxSize} ${lake.maxSizeUnit}",
                    style: context.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff737A80),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SpaceVertical(10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
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
                  Text(
                    lake.accommodation
                        ? 'Type : Accommodation'
                        : "Type : ${lake.type[0].toUpperCase()}${lake.type.substring(1).toLowerCase()}",
                    style: context.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff737A80),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 114,
                    height: 30,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LakeDetailsPage(
                              lake: lake,
                              lakeDetails: lakeDetails,
                            ),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'More info',
                            style: context.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: const Color(0xffF2F6FA),
                            ),
                          ),
                          const SpaceHorizontal(9),
                          Container(
                            width: 16,
                            height: 16,
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.white,
                              ),
                            ),
                            child: const FittedBox(
                              child: Icon(
                                Icons.arrow_forward_ios,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    // return Container(
    //   margin: EdgeInsets.all(5.0.w),
    //   // height: context.dynamicHeight(0.3),
    //   decoration: BoxDecoration(
    //       color: Colors.white,
    //       border: Border.all(color: appStyles.sbGrey),
    //       borderRadius: BorderRadius.all(Radius.circular(20.r))),
    //   child: Row(
    //     children: [
    //       SizedBox(
    //         width: 130.w,
    //         child: Container(
    //           decoration: BoxDecoration(
    //             color: Colors.white,
    //             borderRadius: const BorderRadius.only(
    //                 topLeft: Radius.circular(20.0),
    //                 bottomLeft: Radius.circular(20.0)),
    //             image: DecorationImage(
    //               image: CachedNetworkImageProvider(lake.images.primary),
    //               fit: BoxFit.cover,
    //             ),
    //           ),
    //         ),
    //       ),
    //       Expanded(
    //         child: SizedBox(
    //           width: 150.w,
    //           child: Container(
    //             // width: double.infinity,
    //             // width: 130.w,
    //             decoration: const BoxDecoration(
    //                 color: Colors.white,
    //                 borderRadius: BorderRadius.only(
    //                     topRight: Radius.circular(20.0),
    //                     bottomRight: Radius.circular(20.0))),
    //             child: Padding(
    //               padding:
    //                   const EdgeInsets.only(left: 8.0, top: 20.0, right: 2),
    //               child: Stack(
    //                 children: [
    //                   Column(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     mainAxisAlignment: MainAxisAlignment.start,
    //                     children: [
    //                       Text(
    //                         //! Include lake name in the API
    //                         lake.name,
    //                         style: TextStyle(
    //                             fontSize: 17.0,
    //                             fontWeight: FontWeight.bold,
    //                             color: appStyles.sbBlue),
    //                       ),
    //                       const SizedBox(height: 8.0),
    //                       RichText(
    //                         softWrap: true,
    //                         text: TextSpan(
    //                           style: lakeDetailStyle,
    //                           children: <TextSpan>[
    //                             TextSpan(
    //                                 text: 'Type: ',
    //                                 style: lakeDetailTitleStyle),
    //                             TextSpan(
    //                                 text: lake.accommodation
    //                                     ? 'Accommodation'
    //                                     : "${lake.type[0].toUpperCase()}${lake.type.substring(1).toLowerCase()}",
    //                                 style: lakeDetailStyle)
    //                           ],
    //                         ),
    //                       ),
    //                       const SizedBox(height: 8.0),
    //                       RichText(
    //                         softWrap: true,
    //                         text: TextSpan(
    //                           style: lakeDetailStyle,
    //                           children: <TextSpan>[
    //                             TextSpan(
    //                                 text: 'Access: ',
    //                                 style: lakeDetailTitleStyle),
    //                             TextSpan(
    //                               text: lake.accommodation
    //                                   ? 'Public'
    //                                   : "${lake.accessType[0].toUpperCase()}${lake.accessType.substring(1).toLowerCase()}",
    //                               style: lakeDetailStyle,
    //                             )
    //                           ],
    //                         ),
    //                       ),
    //                       const SizedBox(height: 8.0),
    //                       Visibility(
    //                         visible: !lake.accommodation,
    //                         child: RichText(
    //                           softWrap: true,
    //                           text: TextSpan(
    //                             style: lakeDetailStyle,
    //                             children: <TextSpan>[
    //                               TextSpan(
    //                                   text: 'Max Size: ',
    //                                   style: lakeDetailTitleStyle),
    //                               TextSpan(
    //                                 text: "${lake.maxSize} ${lake.maxSizeUnit}",
    //                                 style: lakeDetailStyle,
    //                               )
    //                             ],
    //                           ),
    //                         ),
    //                       ),
    //                     ],
    //                   )
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ),
    //       )
    //     ],
    //   ),
    // );
  }
}
