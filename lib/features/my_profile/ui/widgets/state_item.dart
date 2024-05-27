import 'package:flutter/material.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';

class StateItem extends StatelessWidget {
  const StateItem({
    super.key,
    required this.value,
    required this.title,
    required this.onTap,
  });

  final String value;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AbsorbPointer(
          child: Column(
            children: [
              Text(
                value,
                style: textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.blue,
                ),
              ),
              const SpaceVertical(6),
              Text(
                title,
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
