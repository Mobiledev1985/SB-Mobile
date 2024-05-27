import 'package:flutter/material.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';

class BackButtonWidget extends StatelessWidget {
  final bool? isCloseIcon;
  const BackButtonWidget({
    super.key,
    this.isCloseIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        onTap: () {
          Navigator.pop(context);
        },
        child: Ink(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.white,
            border: Border.all(
              color: AppColors.dividerGreyColor,
              width: 0.2,
            ),
          ),
          child: Align(
            alignment: isCloseIcon != null
                ? Alignment.center
                : const Alignment(0.6, 0.0),
            child: Icon(
              isCloseIcon != null ? Icons.close : Icons.arrow_back_ios,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
