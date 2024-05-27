import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_strings.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/validators/validators.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';
import 'package:sb_mobile/features/authentication/data/sources/api/sb_backend.dart';
import 'package:sb_mobile/features/authentication/ui/views/background.dart';

class ForgotPassword extends StatefulWidget {
  final bool isFromDialog;
  const ForgotPassword({Key? key, required this.isFromDialog})
      : super(key: key);

  @override
  State<ForgotPassword> createState() {
    return _ForgotPasswordState();
  }
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();
  bool isValidEmail = false;
  SwimbookerApiProvider apiProvider = SwimbookerApiProvider();
  final GlobalKey<FormState> form = GlobalKey<FormState>();

  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  @override
  void initState() {
    if (widget.isFromDialog) {
      if (Platform.isAndroid) {
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light),
        );
      } else {
        FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
        FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    if (widget.isFromDialog) {
      if (Platform.isAndroid) {
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light),
        );
      } else {
        FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
        FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
      }
    }
    isLoading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            SpaceVertical(MediaQuery.paddingOf(context).top + 30),
            SizedBox(
              height: 58,
              child: Stack(
                alignment: Alignment.center,
                fit: StackFit.expand,
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.dividerGreyColor,
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.white,
                          child: Align(
                            alignment: Alignment(0.6, 0.0),
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: AppColors.blue,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  FittedBox(
                    child: SizedBox(
                      width: 74,
                      height: 34,
                      child: Image.asset(
                        'assets/icons/fish.png',
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SpaceVertical(50),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Email:',
                style: context.textTheme.headlineMedium?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SpaceVertical(8),
            Form(
              key: form,
              child: TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: AppStrings.email,
                  filled: true,
                  fillColor: AppColors.white,
                ),
                validator: Validators.emailValidator,
              ),
            ),
            const SpaceVertical(40),
            ValueListenableBuilder(
              valueListenable: isLoading,
              builder: (context, loading, __) {
                return loading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.white,
                        ),
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff379bec),
                        ),
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          isLoading.value = true;
                          if (form.currentState!.validate()) {
                            bool isDone =
                                await apiProvider.resetPasswordByEmail(
                                    email: emailController.text);
                            if (isDone) {
                              emailController.clear();
                            }
                          }
                          isLoading.value = false;
                        },
                        child: const Text(
                          'Reset Password',
                        ),
                      );
              },
            ),
            const SpaceVertical(36),
          ],
        ),
      ),
    );
  }
}

void reset() {}
