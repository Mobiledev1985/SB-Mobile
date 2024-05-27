import 'package:flutter/material.dart';
import 'package:sb_mobile/core/widgets/back_button.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';

class CommonBackBar extends StatelessWidget {
  final String title;
  const CommonBackBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SpaceVertical(12),
        const Padding(
          padding: EdgeInsets.only(left: 16, top: 20, bottom: 22),
          child: BackButtonWidget(),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 34,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ],
    );
  }
}
