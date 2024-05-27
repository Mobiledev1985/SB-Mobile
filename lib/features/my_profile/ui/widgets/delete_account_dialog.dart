import 'package:flutter/material.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/ui_constant.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/notification/web_view_screen.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';
import 'package:url_launcher/url_launcher.dart';

class DeleteAccountDialog extends StatelessWidget {
  final String email;
  final int? publicId;
  const DeleteAccountDialog(
      {super.key, required this.email, required this.publicId});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(defaultBorderRadius),
        side: const BorderSide(
          color: AppColors.blue,
          width: 5,
        ),
      ),
      child: IntrinsicHeight(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.topRight,
                child: CloseButton(),
              ),
              Text(
                "We're sad to see you go!",
                textAlign: TextAlign.center,
                style: context.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SpaceVertical(24),
              Text(
                "Are you sure you want to delete your account? You will lose access to your catch reports, ability to book online and angling statistics. If you are experiencing an issue, please click contact us below instead and we'd be more than happy to help answer your questions.",
                style: context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SpaceVertical(18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 124,
                    height: 36,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        backgroundColor: AppColors.green,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WebViewScreen(
                              url: '',
                              isGoBackToHomeScreen: false,
                              title: 'Contact us',
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Contact us',
                        style: context.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 124,
                    height: 36,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        backgroundColor: const Color(0xffC14F40),
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        try {
                          if (await launchUrl(Uri.parse(
                              'mailto:info@swimbooker.com?subject=Delete Account&body=Please delete my account $email  with immediate effect. My user ID is $publicId'))) {
                          } else {
                            throw Exception('Could not launch ');
                          }
                        } catch (e) {
                          // print('Error launching URL: $e');
                        }
                      },
                      child: Text(
                        'Delete',
                        style: context.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SpaceVertical(18),
            ],
          ),
        ),
      ),
    );
  }
}
