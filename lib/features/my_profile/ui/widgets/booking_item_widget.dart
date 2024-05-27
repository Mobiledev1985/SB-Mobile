import 'package:flutter/material.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/widgets/space_horizontal.dart';

class BookingItemWidget extends StatelessWidget {
  final String title;
  final String value;
  final bool isFromTicketView;
  const BookingItemWidget({
    super.key,
    required this.title,
    required this.value,
    required this.isFromTicketView,
  });

  @override
  Widget build(BuildContext context) {
    final Color? titleColor = isFromTicketView ? const Color(0xff174A73) : null;
    final Color valueColor =
        isFromTicketView ? const Color(0xff174A73) : AppColors.blue;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(
            flex: 9,
            child: Text(
              "$title:",
              textAlign: TextAlign.left,
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight:
                    isFromTicketView ? FontWeight.w500 : FontWeight.w600,
                color: titleColor,
              ),
            ),
          ),
          const SpaceHorizontal(40),
          Expanded(
            flex: 10,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: context.textTheme.headlineSmall?.copyWith(
                color: valueColor,
                fontWeight: isFromTicketView ? null : FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
