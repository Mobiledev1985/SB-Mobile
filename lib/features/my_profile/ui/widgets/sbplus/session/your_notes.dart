import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_images.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/widgets/space_horizontal.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';
import 'package:sb_mobile/features/my_profile/data/models/session_detail_model.dart';
import 'package:sb_mobile/features/my_profile/ui/view/subscription/session/view_note_screen.dart';

class YourNotes extends StatelessWidget {
  final List<SessionNotes>? sessionNotes;

  const YourNotes({
    Key? key,
    this.sessionNotes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
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
            child: Row(
              children: [
                SvgPicture.asset(
                  AppImages.notes,
                ),
                const SpaceHorizontal(14),
                Text(
                  'Your Notes',
                  style: context.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        ...sessionNotes!
            .map(
              (e) => Card(
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
                          Card(
                            color: AppColors.cardColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SizedBox(
                              width: 44,
                              height: 44,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    DateFormat('E').format(
                                      DateTime.parse(e.noteDate!),
                                    ),
                                    style:
                                        context.textTheme.bodySmall?.copyWith(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SpaceVertical(2),
                                  Text(
                                    DateFormat('d').format(
                                      DateTime.parse(e.noteDate!),
                                    ),
                                    style:
                                        context.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SpaceHorizontal(10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  e.title ?? '',
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SpaceVertical(4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      DateFormat('HH:mm').format(
                                        DateTime.parse(e.noteDate!),
                                      ),
                                      style:
                                          context.textTheme.bodySmall?.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xff8B8B8B),
                                      ),
                                    ),
                                    const SpaceHorizontal(6),
                                    SvgPicture.asset(
                                      AppImages.cameraPlus,
                                      width: 12,
                                      height: 12,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              ViewNoteScreen.navigateTo(context, e);
                            },
                            icon: SvgPicture.asset(
                              AppImages.eye,
                            ),
                          ),
                        ],
                      ),
                      const SpaceVertical(16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          e.detail ?? '',
                          style: context.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff8B8B8B),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList()
      ],
    );
  }
}
