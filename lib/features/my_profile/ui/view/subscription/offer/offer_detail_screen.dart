import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_images.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/notification/web_view_screen.dart';
import 'package:sb_mobile/core/routes/route_paths.dart';
import 'package:sb_mobile/core/widgets/alert.dart';
import 'package:sb_mobile/core/widgets/space_horizontal.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';
import 'package:sb_mobile/features/my_profile/data/models/perks_model.dart';
import 'package:url_launcher/url_launcher.dart';

typedef OfferDetailData = ({bool isFromList, Perk perk});

class OfferDetailScreen extends StatefulWidget {
  final OfferDetailData offerDetailData;
  const OfferDetailScreen({
    super.key,
    required this.offerDetailData,
  });

  static MaterialPageRoute<dynamic> buildRouter(
      OfferDetailData offerDetailData) {
    return MaterialPageRoute(
      builder: (context) => OfferDetailScreen(
        offerDetailData: (
          isFromList: offerDetailData.isFromList,
          perk: offerDetailData.perk
        ),
      ),
    );
  }

  static void navigateTo(
      BuildContext context, OfferDetailData offerDetailData) {
    Navigator.pushNamed(context, RoutePaths.offerDetailScreen,
        arguments: offerDetailData);
  }

  @override
  State<OfferDetailScreen> createState() => _OfferDetailScreenState();
}

class _OfferDetailScreenState extends State<OfferDetailScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.offerDetailData.isFromList) {
      if (Platform.isAndroid) {
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
        );
      } else {
        FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
        FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.offerDetailData.isFromList) {
      if (Platform.isAndroid) {
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
          ),
        );
      } else {
        FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
        FlutterStatusbarcolor.setStatusBarColor(Colors.white);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Perk perk = widget.offerDetailData.perk;
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => _FullScreenSingleImage(
                //           imageurl: catchReport.imageUpload ?? ""),
                //     ));
              },
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: perk.headerImage ?? '',
                    width: double.infinity,
                    height: 280,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: MediaQuery.paddingOf(context).top,
                    left: 10,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        child: const Icon(
                          Icons.chevron_left,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SpaceVertical(20),
                  Text(
                    perk.title ?? '',
                    style: context.textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SpaceVertical(8),
                  Text(
                    perk.discountLine ?? '',
                    style: context.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff909090),
                    ),
                  ),
                  const SpaceVertical(20),
                  Text(
                    perk.offerDescription ?? '',
                    style: context.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Visibility(
                    visible: (perk.discountCode != null &&
                        perk.discountCode!.isNotEmpty),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30.0),
                      child: Row(
                        children: [
                          SvgPicture.asset(AppImages.percentIcon),
                          const SpaceHorizontal(8),
                          Text(
                            'Discount Code',
                            style: context.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Clipboard.setData(
                        ClipboardData(text: perk.discountCode ?? ''),
                      ).then((value) {
                        showAlert('Copied to the clipboard!');
                      });
                    },
                    child: Ink(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xffEFFBFF),
                        border: Border.all(color: AppColors.blue),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Text(
                        perk.discountCode ?? '',
                        textAlign: TextAlign.center,
                        style: context.textTheme.displayLarge?.copyWith(
                          fontSize: 40.0,
                          fontWeight: FontWeight.w500,
                          color: AppColors.blue,
                        ),
                      ),
                    ),
                  ),
                  const SpaceVertical(10),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
            left: 20, right: 20, bottom: MediaQuery.paddingOf(context).bottom),
        child: ElevatedButton(
          onPressed: () async {
            if (perk.linkValue == null || perk.linkValue!.isEmpty) {
              return;
            } else if (perk.linkType == 'absolute') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WebViewScreen(
                    url: perk.linkValue ?? '',
                    isGoBackToHomeScreen: false,
                    title: perk.title ?? '',
                  ),
                ),
              );
            } else if (perk.linkType == 'phone') {
              try {
                if (await launchUrl(Uri.parse('tel:${perk.linkValue}'))) {
                } else {
                  throw Exception('Could not launch ');
                }
              } catch (e) {
                // print('Error launching URL: $e');
              }
            } else {
              try {
                if (await launchUrl(Uri.parse('mailto:${perk.linkValue}'))) {
                } else {
                  throw Exception('Could not launch ');
                }
              } catch (e) {
                // print('Error launching URL: $e');
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.green,
          ),
          child: Text(perk.linkText ?? ''),
        ),
      ),
    );
  }
}
