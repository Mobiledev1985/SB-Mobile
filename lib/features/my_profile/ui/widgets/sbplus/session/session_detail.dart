import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_images.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/widgets/space_horizontal.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';
import 'package:sb_mobile/features/my_profile/data/models/session_detail_model.dart';

class SessionDetail extends StatefulWidget {
  final SessionDetailModel sessionDetail;
  const SessionDetail({super.key, required this.sessionDetail});

  @override
  State<SessionDetail> createState() => _SessionDetailState();
}

class _SessionDetailState extends State<SessionDetail> {
  // final TextEditingController swimController = TextEditingController();
  // final ValueNotifier<bool> isEditSwim = ValueNotifier(false);
  // final FocusNode focusNode = FocusNode();

  // bool needToListen = true;

  String getTime(String date) {
    return DateFormat('HH:mma').format(DateTime.parse(date));
  }

  String getDay(String date) {
    return DateFormat('EEEE').format(DateTime.parse(date)).toUpperCase();
  }

  String getDate(String date) {
    return DateFormat('d MMMM').format(DateTime.parse(date));
  }

  String getDurationInHours(String startDate, String endDate) {
    final DateTime startDateTime = DateTime.parse(startDate);
    final DateTime endDateTime = DateTime.parse(endDate);

    final Duration difference = endDateTime.difference(startDateTime);
    final int hours = difference.inHours;

    return '$hours Hrs';
  }

  // @override
  // void initState() {
  //   swimController.addListener(() {
  //     if (needToListen) {
  //       final isNotEmpty = swimController.text.isNotEmpty;
  //       if (isNotEmpty && !isEditSwim.value) {
  //         isEditSwim.value = true;
  //       } else if (!isNotEmpty && isEditSwim.value) {
  //         isEditSwim.value = false;
  //       }
  //     }
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14),
        child: Column(
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  AppImages.sessionDetails,
                ),
                const SpaceHorizontal(14),
                Text(
                  'Session Details',
                  style: context.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SpaceVertical(14),
            ...List.generate(
              2,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        color: AppColors.cardColor,
                        child: SizedBox(
                          height: 40,
                          width: 86,
                          child: Center(
                            child: Text(
                              getTime(index == 0
                                  ? widget.sessionDetail.startTs!
                                  : widget.sessionDetail.endTs!),
                              style: context.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SpaceHorizontal(4),
                    Expanded(
                      flex: 3,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        color: AppColors.cardColor,
                        child: SizedBox(
                          height: 40,
                          width: 86,
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  getDay(index == 0
                                      ? widget.sessionDetail.startTs!
                                      : widget.sessionDetail.endTs!),
                                  style: context.textTheme.bodySmall?.copyWith(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  getDate(index == 0
                                      ? widget.sessionDetail.startTs!
                                      : widget.sessionDetail.endTs!),
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SpaceHorizontal(4),
                    Expanded(
                      flex: 4,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        color: AppColors.cardColor,
                        child: SizedBox(
                          height: 40,
                          child: Center(
                            child: index != 0
                                ? Text(
                                    'Total: ${getDurationInHours(widget.sessionDetail.startTs!, widget.sessionDetail.endTs!)}',
                                    style:
                                        context.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : DateTime.parse(widget.sessionDetail.endTs!)
                                        .isAfter(DateTime.now())
                                    ? Text(
                                        'Live',
                                        style: context.textTheme.bodyMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            AppImages.checked,
                                            width: 28,
                                            height: 28,
                                          ),
                                          const SpaceHorizontal(6),
                                          Text(
                                            'COMPLETE',
                                            style: context.textTheme.bodyMedium
                                                ?.copyWith(
                                              fontWeight: FontWeight.bold,
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
              ),
            ).toList(),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              color: AppColors.cardColor,
              child: SizedBox(
                height: 40,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text.rich(
                      TextSpan(
                        text: 'Venue:',
                        children: [
                          TextSpan(
                            text: ' ${widget.sessionDetail.fisheryName}',
                            style: context.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),
            const SpaceVertical(10),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              color: AppColors.cardColor,
              child: SizedBox(
                height: 40,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text.rich(
                      TextSpan(
                        text: 'Lake: ',
                        children: [
                          TextSpan(
                            text: widget.sessionDetail.lakeName ?? '',
                            style: context.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),
            // const SpaceVertical(10),
            // Card(
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(8),
            //   ),
            //   color: AppColors.cardColor,
            //   child: SizedBox(
            //     height: 40,
            //     width: double.infinity,
            //     child: Padding(
            //       padding: const EdgeInsets.only(left: 12.0),
            //       child: Align(
            //         alignment: Alignment.centerLeft,
            //         child: ValueListenableBuilder(
            //           valueListenable: isEditSwim,
            //           builder: (context, isEdit, _) {
            //             return Row(
            //               children: [
            //                 Text(
            //                   'Swim:',
            //                   style: context.textTheme.bodyMedium?.copyWith(
            //                     fontWeight: FontWeight.bold,
            //                   ),
            //                   maxLines: 1,
            //                   overflow: TextOverflow.ellipsis,
            //                 ),
            //                 Expanded(
            //                   child: TextFormField(
            //                     focusNode: focusNode,
            //                     onTap: () {
            //                       needToListen = true;
            //                     },
            //                     controller: swimController,
            //                     enabled:
            //                         swimController.text.isEmpty ? true : isEdit,
            //                     decoration: InputDecoration(
            //                       hintText: 'Enter swim',
            //                       contentPadding: const EdgeInsets.only(
            //                         bottom: 2,
            //                         left: 10,
            //                       ),
            //                       border: InputBorder.none,
            //                       enabledBorder: InputBorder.none,
            //                       errorBorder: InputBorder.none,
            //                       disabledBorder: InputBorder.none,
            //                       focusedBorder: InputBorder.none,
            //                       focusedErrorBorder: InputBorder.none,
            //                       hintStyle:
            //                           context.textTheme.bodySmall?.copyWith(
            //                         fontWeight: FontWeight.w300,
            //                         color: const Color(0xff868686),
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //                 ListenableBuilder(
            //                   listenable: swimController,
            //                   builder: (context, value) {
            //                     return Visibility(
            //                       visible: swimController.text.isNotEmpty,
            //                       child: GestureDetector(
            //                         onTap: () {
            //                           needToListen = false;
            //                           isEditSwim.value = !isEditSwim.value;
            //                           if (isEditSwim.value) {
            //                             Future.delayed(const Duration(
            //                                     milliseconds: 50))
            //                                 .then((value) {
            //                               focusNode.requestFocus();
            //                             });
            //                           }
            //                         },
            //                         child: FittedBox(
            //                           fit: BoxFit.scaleDown,
            //                           child: SizedBox(
            //                             width: isEdit ? 20 : 14,
            //                             height: isEdit ? 20 : 14,
            //                             child: SvgPicture.asset(
            //                               isEdit
            //                                   ? AppImages.checked
            //                                   : AppImages.editNotes,
            //                             ),
            //                           ),
            //                         ),
            //                       ),
            //                     );
            //                   },
            //                 ),
            //                 const SpaceHorizontal(10),
            //               ],
            //             );
            //           },
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
