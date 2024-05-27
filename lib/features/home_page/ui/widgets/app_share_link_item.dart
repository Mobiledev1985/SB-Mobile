import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:sb_mobile/core/widgets/space_horizontal.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';
import 'package:share_plus/share_plus.dart';

class AppShareLinkItem extends StatelessWidget {
  final String platformText;
  final String link;
  const AppShareLinkItem(
      {super.key, required this.platformText, required this.link});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: AutoSizeText(
            platformText,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SpaceVertical(4),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Share.share(link);
                },
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  height: 34,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border:
                        Border.all(color: const Color(0xffD6D6D6), width: 1),
                  ),
                  child: AutoSizeText(
                    link,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
            const SpaceHorizontal(12),
            IconButton(
              iconSize: 18,
              onPressed: () {
                Share.share(link);
              },
              icon: const Icon(
                Icons.share,
              ),
            ),
            // InkWell(
            //   onTap: () {
            //     Clipboard.setData(
            //       ClipboardData(text: link),
            //     );
            //   },
            //   child: SvgPicture.asset(
            //     AppImages.copy,
            //     width: 24,
            //     height: 24,
            //   ),
            // )
          ],
        ),
      ],
    );
  }
}
