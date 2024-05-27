import 'package:flutter/material.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_strings.dart';

class OverlayAnimationWidget extends StatelessWidget {
  final GlobalKey editDetailsButtonKey;
  final GlobalKey saveChangesButtonKey;
  final bool isClickOnEditButton;
  final VoidCallback onEnd;
  const OverlayAnimationWidget({
    super.key,
    required this.editDetailsButtonKey,
    required this.saveChangesButtonKey,
    required this.isClickOnEditButton,
    required this.onEnd,
  });

  @override
  Widget build(BuildContext context) {
    RenderBox editButton =
        editDetailsButtonKey.currentContext?.findRenderObject() as RenderBox;
    RenderBox saveButton =
        saveChangesButtonKey.currentContext?.findRenderObject() as RenderBox;

    Offset editButtonPosition = editButton.localToGlobal(Offset.zero);
    Offset saveButtonPosition = saveButton.localToGlobal(Offset.zero);

    return Positioned(
      top: isClickOnEditButton ? editButtonPosition.dy : saveButtonPosition.dy,
      left: isClickOnEditButton ? editButtonPosition.dx : saveButtonPosition.dx,
      child: TweenAnimationBuilder(
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
        tween: Tween<Offset>(
          begin: Offset.zero,
          end: isClickOnEditButton
              ? (saveButtonPosition - editButtonPosition)
              : (editButtonPosition - saveButtonPosition),
        ),
        builder: (context, Offset offset, child) {
          return Transform.translate(
            offset: offset,
            child: SizedBox(
              width: 140,
              height: 32,
              child: Material(
                color: Colors.transparent,
                child: child,
              ),
            ),
          );
        },
        onEnd: onEnd,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          child: Text(
            AppStrings.editDetails,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
          ),
        ),
      ),
    );
  }
}
