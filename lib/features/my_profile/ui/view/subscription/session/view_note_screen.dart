import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_images.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/routes/route_paths.dart';
import 'package:sb_mobile/core/widgets/back_button.dart';
import 'package:sb_mobile/core/widgets/space_horizontal.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';
import 'package:sb_mobile/features/my_profile/cubit/my_profile_cubit.dart';
import 'package:sb_mobile/features/my_profile/cubit/session/session_cubit.dart';
import 'package:sb_mobile/features/my_profile/data/models/session_detail_model.dart';
import 'package:sb_mobile/features/my_profile/ui/widgets/profile_bar.dart';

class ViewNoteScreen extends StatefulWidget {
  final SessionNotes sessionNotes;
  const ViewNoteScreen({super.key, required this.sessionNotes});

  static PageRouteBuilder<dynamic> buildRouter(SessionNotes sessionNotes) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          ViewNoteScreen(sessionNotes: sessionNotes),
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

  static void navigateTo(BuildContext context, SessionNotes sessionNotes) {
    Navigator.pushNamed(context, RoutePaths.yourNoteScreen,
        arguments: sessionNotes);
  }

  @override
  State<ViewNoteScreen> createState() => _ViewNoteScreenState();
}

class _ViewNoteScreenState extends State<ViewNoteScreen> {
  final TextEditingController noteController = TextEditingController();
  final TextEditingController noteDetailController = TextEditingController();

  final ValueNotifier<bool> isEditNote = ValueNotifier(false);
  final ValueNotifier<bool> isEditNoteDetail = ValueNotifier(false);

  bool needToListenNote = true;
  bool needToListenNoteDetail = true;

  FocusNode focusNodeNote = FocusNode();
  FocusNode focusNodeNoteDetail = FocusNode();

  @override
  void initState() {
    noteController.text = widget.sessionNotes.title ?? '';
    noteDetailController.text = widget.sessionNotes.detail ?? '';
    noteController.addListener(() {
      if (needToListenNote) {
        final isNotEmpty = noteController.text.isNotEmpty;
        if (isNotEmpty && !isEditNote.value) {
          isEditNote.value = true;
        } else if (!isNotEmpty && isEditNote.value) {
          isEditNote.value = false;
        }
      }
    });
    noteDetailController.addListener(() {
      if (needToListenNoteDetail) {
        final isNotEmpty = noteDetailController.text.isNotEmpty;
        if (isNotEmpty && !isEditNoteDetail.value) {
          isEditNoteDetail.value = true;
        } else if (!isNotEmpty && isEditNoteDetail.value) {
          isEditNoteDetail.value = false;
        }
      }
    });
    super.initState();
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
                    const SpaceVertical(12),
                    Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 14,
                        ),
                        child: Row(
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
                                        DateTime.parse(
                                            widget.sessionNotes.noteDate!),
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
                                        DateTime.parse(
                                            widget.sessionNotes.noteDate!),
                                      ),
                                      style: context.textTheme.bodyMedium
                                          ?.copyWith(
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
                                  ValueListenableBuilder(
                                      valueListenable: isEditNote,
                                      builder: (context, isEdit, _) {
                                        return TextFormField(
                                          focusNode: focusNodeNote,
                                          onTap: () {
                                            needToListenNote = true;
                                          },
                                          style: context.textTheme.bodyMedium
                                              ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.black,
                                          ),
                                          controller: noteController,
                                          enabled: noteController.text.isEmpty
                                              ? true
                                              : isEdit,
                                          decoration: InputDecoration(
                                            hintText: 'Enter Note',
                                            contentPadding:
                                                const EdgeInsets.only(),
                                            border: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            focusedErrorBorder:
                                                InputBorder.none,
                                            hintStyle: context
                                                .textTheme.bodySmall
                                                ?.copyWith(
                                              fontWeight: FontWeight.w300,
                                              color: const Color(0xff868686),
                                            ),
                                          ),
                                        );
                                      }),
                                  const SpaceVertical(4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        DateFormat('HH:mm').format(
                                          DateTime.parse(
                                              widget.sessionNotes.noteDate!),
                                        ),
                                        style: context.textTheme.bodySmall
                                            ?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xff8B8B8B),
                                        ),
                                      ),
                                      const SpaceHorizontal(6),
                                      const Icon(
                                        CupertinoIcons.photo_camera,
                                        size: 13,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            ValueListenableBuilder(
                              valueListenable: isEditNote,
                              builder: (context, isEdit, _) {
                                return ListenableBuilder(
                                  listenable: noteController,
                                  builder: (context, value) {
                                    return Visibility(
                                      visible: noteController.text.isNotEmpty,
                                      child: IconButton(
                                        onPressed: () {
                                          needToListenNote = false;
                                          isEditNote.value = !isEditNote.value;
                                          if (isEditNote.value) {
                                            Future.delayed(
                                              const Duration(milliseconds: 50),
                                            ).then(
                                              (value) {
                                                focusNodeNote.requestFocus();
                                              },
                                            );
                                          } else {
                                            widget.sessionNotes.title =
                                                noteController.text.trim();
                                            context
                                                .read<SessionCubit>()
                                                .updateNotes(
                                                    widget.sessionNotes);
                                          }
                                        },
                                        icon: SvgPicture.asset(
                                          isEdit
                                              ? AppImages.checked
                                              : AppImages.editNotes,
                                          width: isEdit ? 26 : 20,
                                          height: isEdit ? 26 : 20,
                                          colorFilter: isEdit
                                              ? null
                                              : const ColorFilter.mode(
                                                  Color(0xff3B8ED1),
                                                  BlendMode.srcIn,
                                                ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SpaceVertical(12),
                    Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Note Details:',
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                ValueListenableBuilder(
                                  valueListenable: isEditNoteDetail,
                                  builder: (__, isEdit, _) {
                                    return ListenableBuilder(
                                      listenable: noteDetailController,
                                      builder: (_, value) {
                                        return Visibility(
                                          visible: noteDetailController
                                              .text.isNotEmpty,
                                          child: IconButton(
                                            onPressed: () {
                                              needToListenNoteDetail = false;
                                              isEditNoteDetail.value =
                                                  !isEditNoteDetail.value;
                                              if (isEditNoteDetail.value) {
                                                Future.delayed(const Duration(
                                                        milliseconds: 50))
                                                    .then((value) {
                                                  focusNodeNoteDetail
                                                      .requestFocus();
                                                });
                                              } else {
                                                widget.sessionNotes.detail =
                                                    noteDetailController.text
                                                        .trim();
                                                context
                                                    .read<SessionCubit>()
                                                    .updateNotes(
                                                        widget.sessionNotes);
                                              }
                                            },
                                            icon: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: SizedBox(
                                                width: isEdit ? 26 : 20,
                                                height: isEdit ? 26 : 20,
                                                child: SvgPicture.asset(
                                                  isEdit
                                                      ? AppImages.checked
                                                      : AppImages.editNotes,
                                                  colorFilter: isEdit
                                                      ? null
                                                      : const ColorFilter.mode(
                                                          Color(0xff3B8ED1),
                                                          BlendMode.srcIn,
                                                        ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SpaceVertical(8),
                            ValueListenableBuilder(
                              valueListenable: isEditNoteDetail,
                              builder: (context, isEdit, _) {
                                return !isEdit
                                    ? Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          widget.sessionNotes.detail ?? '',
                                          style: context.textTheme.bodyMedium
                                              ?.copyWith(
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xff535353),
                                          ),
                                        ),
                                      )
                                    : TextFormField(
                                        focusNode: focusNodeNoteDetail,
                                        onTap: () {
                                          needToListenNoteDetail = true;
                                        },
                                        style: context.textTheme.bodyMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xff535353),
                                        ),
                                        maxLines: 5,
                                        controller: noteDetailController,
                                        enabled:
                                            noteDetailController.text.isEmpty
                                                ? true
                                                : isEdit,
                                        decoration: InputDecoration(
                                          hintText: 'Enter Note',
                                          contentPadding:
                                              const EdgeInsets.only(),
                                          border: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          focusedErrorBorder: InputBorder.none,
                                          hintStyle: context.textTheme.bodySmall
                                              ?.copyWith(
                                            fontWeight: FontWeight.w300,
                                            color: const Color(0xff868686),
                                          ),
                                        ),
                                      );
                              },
                            ),
                            const SpaceVertical(12),
                          ],
                        ),
                      ),
                    ),
                    const SpaceVertical(16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: widget.sessionNotes.imageUpload ?? '',
                        width: double.infinity,
                        errorWidget: (context, url, error) => Image.asset(
                          AppImages.noImageUploaded,
                          fit: BoxFit.cover,
                        ),
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SpaceVertical(8),
                    Row(
                      children: [
                        Expanded(
                          child: Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Text(
                                    'Lake:',
                                    style:
                                        context.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SpaceHorizontal(8),
                                  Expanded(
                                    child: Text(
                                      widget.sessionNotes.lake ?? '',
                                      style: context.textTheme.bodyMedium
                                          ?.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SpaceHorizontal(10),
                        Expanded(
                          child: Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Text(
                                    'Swim:',
                                    style:
                                        context.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SpaceHorizontal(8),
                                  Expanded(
                                    child: Text(
                                      widget.sessionNotes.swim ?? '',
                                      style: context.textTheme.bodyMedium
                                          ?.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SpaceVertical(40),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
