import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:sb_mobile/core/constant/app_images.dart';
import 'package:sb_mobile/core/constant/app_strings.dart';
import 'package:sb_mobile/core/constant/ui_constant.dart';
import 'package:sb_mobile/core/utility/utils/utils.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';
import 'package:sb_mobile/features/home_page/data/models/articles_model.dart';
import 'package:sb_mobile/features/home_page/ui/views/bottom_bar_provider.dart';
import 'package:sb_mobile/features/home_page/ui/widgets/list_header.dart';

class AnglingSocialWidget extends StatelessWidget {
  final List<Article> articles;

  const AnglingSocialWidget({super.key, required this.articles});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(defaultBorderRadius),
        ),
        child: Column(
          children: [
            const SpaceVertical(12),
            ListHeader(
              icon: AppImages.bell,
              title: AppStrings.theAnglingSocial,
              trailing: AppStrings.seeMore,
              onPressed: () {
                final selectedBottomBarItem =
                    BottomBarProvider.of(context).selectedBottomBarItem;
                selectedBottomBarItem.value = 3;
              },
            ),
            if (articles.length > 3)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22.0,
                ),
                child: Column(
                  children: List.generate(3, (index) {
                    final article = articles[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: GestureDetector(
                        onTap: () {
                          if (Platform.isAndroid) {
                            SystemChrome.setSystemUIOverlayStyle(
                              const SystemUiOverlayStyle(
                                  statusBarColor: Colors.transparent,
                                  statusBarIconBrightness: Brightness.light),
                            );
                          } else {
                            FlutterStatusbarcolor.setStatusBarWhiteForeground(
                                true);
                            FlutterStatusbarcolor.setStatusBarColor(
                                Colors.transparent);
                          }
                          Navigator.of(context).pushNamed(
                            '/social/blog',
                            arguments: {'id': article.id},
                          );
                        },
                        child: Row(
                          children: [
                            Container(
                              width: 160,
                              height: 110,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: CachedNetworkImageProvider(
                                    article.image,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      article.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SpaceVertical(10),
                                    Text(
                                      timeAgoSinceDate(
                                          dateString: article.postedAt),
                                      style: textTheme.bodySmall?.copyWith(
                                        fontWeight: FontWeight.w300,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            const SpaceVertical(12),
          ],
        ),
      ),
    );
  }
}
