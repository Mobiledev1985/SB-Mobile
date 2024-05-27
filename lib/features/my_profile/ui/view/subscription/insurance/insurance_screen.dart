import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_images.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/routes/route_paths.dart';
import 'package:sb_mobile/core/widgets/back_button.dart';
import 'package:sb_mobile/core/widgets/space_horizontal.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';
import 'package:sb_mobile/features/authentication/data/models/angler_profile_details_model.dart';
import 'package:sb_mobile/features/my_profile/ui/view/subscription/insurance/pdf_screen.dart';
import 'package:sb_mobile/features/my_profile/ui/widgets/profile_bar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

typedef InsuranceData = ({AnglerProfile? profile, String? subscriptionLevel});

class InsuranceScreen extends StatefulWidget {
  const InsuranceScreen({super.key, required this.insuranceData});

  final InsuranceData insuranceData;

  static PageRouteBuilder<dynamic> buildRouter(InsuranceData insuranceData) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          InsuranceScreen(insuranceData: insuranceData),
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

  static Future<void> navigateTo(
      BuildContext context, InsuranceData insuranceData) async {
    await Navigator.pushNamed(context, RoutePaths.insuranceScreen,
        arguments: insuranceData);
  }

  @override
  State<InsuranceScreen> createState() => _InsuranceScreenState();
}

class _InsuranceScreenState extends State<InsuranceScreen> {
  String pathPDF = "";

  @override
  void initState() {
    super.initState();
    fromAsset('assets/pdf/insurance_policy.pdf', 'insurance_policy.pdf')
        .then((f) {
      pathPDF = f.path;
    });
  }

  Future<File> fromAsset(String asset, String filename) async {
    // To open from assets, you can copy them to the app storage folder, and the access them "locally"
    Completer<File> completer = Completer();

    try {
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  bool isPro() {
    final String? subscriptionLevel = widget.insuranceData.subscriptionLevel;
    if (subscriptionLevel != null &&
        subscriptionLevel.toLowerCase().contains('pro')) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileBar(
              profile: widget.insuranceData.profile,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SpaceVertical(20),
                  const BackButtonWidget(),
                  const SpaceVertical(20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Insurance',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontSize: 34,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const Spacer(),
                      Image.asset(
                        AppImages.avivaLogo,
                        width: 84,
                        height: 60,
                      ),
                    ],
                  ),
                  const SpaceVertical(24),
                  Row(
                    children: [
                      Text(
                        'Summary',
                        style: context.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      const CircleAvatar(
                        radius: 5,
                        backgroundColor: AppColors.green,
                      ),
                      const SpaceHorizontal(8),
                      Text(
                        'Active',
                        style: context.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SpaceVertical(24),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xff292828),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    child: Column(
                      children: [
                        InsuranceItem(
                          title: 'Policy Level',
                          value: isPro() ? "SB+ Pro" : 'SB+',
                        ),
                        const SpaceVertical(24),
                        const InsuranceItem(
                          title: 'Type',
                          value: 'Personal & Equipment',
                        ),
                        const SpaceVertical(24),
                        InsuranceItem(
                          title: 'Equipment Cover',
                          value: isPro() ? '£1000.00' : '£350.00',
                        ),
                      ],
                    ),
                  ),
                  const SpaceVertical(24),
                  Material(
                    type: MaterialType.transparency,
                    child: InkWell(
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onTap: () {
                        if (pathPDF.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PdfScreen(filePath: pathPDF),
                            ),
                          );
                        }
                      },
                      child: Ink(
                        decoration: BoxDecoration(
                          color: AppColors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.white),
                              ),
                              child: SvgPicture.asset(
                                AppImages.captureIcon,
                                width: 16,
                                height: 20,
                              ),
                            ),
                            const SpaceHorizontal(24),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'View Summary Document',
                                    style:
                                        context.textTheme.bodyLarge?.copyWith(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SpaceVertical(4),
                                  Text(
                                    'See what’s included in your insurance package.',
                                    style:
                                        context.textTheme.bodySmall?.copyWith(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SpaceHorizontal(24),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: AppColors.white,
                              size: 18,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SpaceVertical(32),
                  // RichText(
                  //   text: TextSpan(
                  //     text: 'When claiming via ',
                  //     style: context.textTheme.bodySmall?.copyWith(
                  //       fontWeight: FontWeight.w300,
                  //       height: 1.6,
                  //       fontSize: 13,
                  //     ),
                  //     children: [
                  //       TextSpan(
                  //         text: 'SB+ Insurance,',
                  //         style: context.textTheme.bodySmall?.copyWith(
                  //           fontWeight: FontWeight.w600,
                  //           fontSize: 13,
                  //         ),
                  //       ),
                  //       TextSpan(
                  //         text:
                  //             ' please ensure you have read the policy documentation. All claims are handled directly via the secure Insure Portal by clicking on ',
                  //         style: context.textTheme.bodySmall?.copyWith(
                  //           fontWeight: FontWeight.w300,
                  //           fontSize: 13,
                  //         ),
                  //       ),
                  //       TextSpan(
                  //         text: 'Make Claim',
                  //         style: context.textTheme.bodySmall?.copyWith(
                  //           fontWeight: FontWeight.w600,
                  //           fontSize: 13,
                  //         ),
                  //       ),
                  //       TextSpan(
                  //         text: ' below',
                  //         style: context.textTheme.bodySmall?.copyWith(
                  //           fontWeight: FontWeight.w300,
                  //           fontSize: 13,
                  //           height: 1.6,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  const SpaceVertical(28),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      onPressed: () async {
                        try {
                          if (await launchUrl(Uri.parse(
                              'https://www.marshsport.co.uk/ngb-schemes/swimbooker-insurance-zone.html'))) {
                          } else {
                            throw Exception('Could not launch ');
                          }
                        } catch (e) {
                          // print('Error launching URL: $e');
                        }
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => const WebViewScreen(
                        //       url:
                        //           'https://www.marshsport.co.uk/ngb-schemes/swimbooker-insurance-zone.html',
                        //       isGoBackToHomeScreen: false,
                        //     ),
                        //   ),
                        // ).then((value) {
                        //   if (Platform.isAndroid) {
                        //     SystemChrome.setSystemUIOverlayStyle(
                        //       const SystemUiOverlayStyle(
                        //           statusBarColor: Colors.transparent,
                        //           statusBarIconBrightness: Brightness.light),
                        //     );
                        //   } else {
                        //     FlutterStatusbarcolor.setStatusBarWhiteForeground(
                        //         true);
                        //     FlutterStatusbarcolor.setStatusBarColor(
                        //         Colors.transparent);
                        //   }
                        // });
                      },
                      child: const Text('Make Claim'),
                    ),
                  ),
                  const SpaceVertical(28),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InsuranceItem extends StatelessWidget {
  const InsuranceItem({super.key, required this.title, required this.value});

  final String title;

  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "$title:",
          style: context.textTheme.bodyLarge
              ?.copyWith(fontWeight: FontWeight.bold, color: AppColors.white),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: context.textTheme.bodyLarge
                ?.copyWith(fontWeight: FontWeight.w500, color: AppColors.white),
          ),
        ),
      ],
    );
  }
}
