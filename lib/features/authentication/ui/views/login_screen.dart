import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:sb_mobile/core/config/authenticator.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_strings.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/routes/route_paths.dart';
import 'package:sb_mobile/core/validators/validators.dart';
import 'package:sb_mobile/core/widgets/alert.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';
import 'package:sb_mobile/features/authentication/cubit/auth_helper_cubit.dart';
import 'package:sb_mobile/features/authentication/cubit/authentication_status_cubit.dart';
import 'package:sb_mobile/features/authentication/providers/subscription_provider.dart';
import 'package:sb_mobile/features/authentication/ui/views/background.dart';
import 'package:sb_mobile/features/authentication/ui/views/sign_up_screen.dart';
import 'package:sb_mobile/features/home_page/cubit/home_page_cubit.dart';
import 'package:sb_mobile/features/home_page/ui/views/bottom_bar_provider.dart';
import 'package:sb_mobile/features/home_page/ui/views/bottom_bar_screen.dart';
import 'package:sb_mobile/features/authentication/data/sources/api/sb_backend.dart';
import 'package:sb_mobile/features/home_page/ui/widgets/sb_promo_banner.dart';
import 'package:sb_mobile/main.dart';

class LoginScreen extends StatefulWidget {
  final bool isBackButton;

  const LoginScreen({super.key, required this.isBackButton});

  static MaterialPageRoute<dynamic> buildRouter(bool isBackButton) {
    return MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (context) => AuthHelperCubit(),
        child: LoginScreen(isBackButton: isBackButton),
      ),
    );
  }

  static Future<dynamic> navigateTo(
    BuildContext context,
    bool isBackButton,
  ) async {
    return await Navigator.pushNamed(
      context,
      RoutePaths.loginScreen,
      arguments: isBackButton,
    );
  }

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  SwimbookerApiProvider apiProvider = SwimbookerApiProvider();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> form = GlobalKey<FormState>();

  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<bool> isPasswordVisible = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
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

  @override
  void dispose() {
    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark),
      );
    } else {
      FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
      FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    }

    isLoading.dispose();
    isPasswordVisible.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Background(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Form(
              key: form,
              child: Column(
                children: [
                  SpaceVertical(MediaQuery.paddingOf(context).top + 30),
                  SizedBox(
                    height: 58,
                    child: Stack(
                      alignment: Alignment.center,
                      fit: StackFit.expand,
                      children: [
                        Visibility(
                          visible: widget.isBackButton,
                          child: Positioned(
                            left: 0,
                            top: 0,
                            bottom: 0,
                            child: DecoratedBox(
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
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    style: const TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.normal,
                    ),
                    decoration: const InputDecoration(
                      hintText: AppStrings.email,
                      hintStyle: TextStyle(
                        fontSize: 16,
                        color: Color(0xff787878),
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.normal,
                      ),
                      filled: true,
                      fillColor: AppColors.white,
                    ),
                    validator: Validators.emailValidator,
                  ),
                  const SpaceVertical(14),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Password:',
                      style: context.textTheme.headlineMedium?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: ValueListenableBuilder(
                      valueListenable: isPasswordVisible,
                      builder: (context, isVisible, _) {
                        return TextFormField(
                          controller: passwordController,
                          style: const TextStyle(
                            fontSize: 18,
                            fontStyle: FontStyle.normal,
                          ),
                          obscureText: isVisible,
                          decoration: InputDecoration(
                            hintText: AppStrings.password,
                            filled: true,
                            hintStyle: const TextStyle(
                              fontSize: 16,
                              color: Color(0xff787878),
                              fontWeight: FontWeight.w300,
                              fontStyle: FontStyle.normal,
                            ),
                            fillColor: AppColors.white,
                            suffixIcon: GestureDetector(
                              onTap: () {
                                isPasswordVisible.value =
                                    !isPasswordVisible.value;
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 6.0, right: 12),
                                child: Icon(
                                  isVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  size: 24,
                                  color: const Color(0xff7B7B7B),
                                ),
                              ),
                            ),
                            suffixIconConstraints: const BoxConstraints(
                              maxHeight: 24,
                              maxWidth: 42,
                            ),
                          ),
                          validator: Validators.passwordValidator,
                        );
                      },
                    ),
                  ),
                  const SpaceVertical(24),
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
                                if (form.currentState!.validate()) {
                                  FocusScope.of(context).unfocus();
                                  isLoading.value = true;
                                  await auth
                                      .login(
                                          username: emailController.text,
                                          password: passwordController.text,
                                          aggresive: true)
                                      .then(
                                    (response) {
                                      if (response) {
                                        context
                                            .read<AuthenticationStatusCubit>()
                                            .reload()
                                            .then(
                                          (value) async {
                                            final String? subscriptionLevel =
                                                await apiProvider
                                                    .getSubscriptionLevel();
                                            // ignore: use_build_context_synchronously
                                            if (navigatorKey.currentContext!
                                                .read<SubscriptionProvider>()
                                                .isFromBanner) {
                                              showAlert("Login Successful");

                                              if (subscriptionLevel != null &&
                                                  (subscriptionLevel
                                                          .toLowerCase()
                                                          .contains('pro') ||
                                                      subscriptionLevel
                                                          .toLowerCase()
                                                          .contains('plus'))) {
                                                showAlert(
                                                    'You already have a subscription!');
                                                // ignore: use_build_context_synchronously
                                                BottomBarProvider.of(context)
                                                    .selectedBottomBarItem
                                                    .value = 2;
                                                // ignore: use_build_context_synchronously
                                                Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const BottomBarScreen(),
                                                  ),
                                                  (route) => false,
                                                );
                                              } else {
                                                // ignore: use_build_context_synchronously
                                                Navigator.pop(
                                                  context,
                                                  {
                                                    'email': emailController
                                                        .text
                                                        .trim(),
                                                    'isLoggedIn': true,
                                                  },
                                                );
                                              }
                                            } else {
                                              if (subscriptionLevel == null ||
                                                  !(subscriptionLevel
                                                          .toLowerCase()
                                                          .contains('pro') ||
                                                      subscriptionLevel
                                                          .toLowerCase()
                                                          .contains('plus'))) {
                                                // ignore: use_build_context_synchronously
                                                showDialog(
                                                  context: navigatorKey
                                                      .currentState!.context,
                                                  barrierDismissible: false,
                                                  builder: (_) => SBPromoBanner(
                                                    isFromInSession: false,
                                                    email: emailController.text
                                                        .trim(),
                                                  ),
                                                );
                                              }
                                            }
                                            // ignore: use_build_context_synchronously
                                            await navigatorKey.currentContext!
                                                .read<HomePageCubit>()
                                                .refresh(false);
                                          },
                                        );
                                      }
                                    },
                                  );
                                  isLoading.value = false;
                                }
                              },
                              child: const Text(
                                AppStrings.login,
                              ),
                            );
                    },
                  ),
                  const SpaceVertical(36),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: AppStrings.forgotPasswordText,
                          ),
                          TextSpan(
                            text: AppStrings.here,
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                              height: 1.0,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                FocusScope.of(context).unfocus();
                                Navigator.of(context).pushNamed(
                                    '/angler/reset/password',
                                    arguments: false);
                              },
                          ),
                          const TextSpan(text: AppStrings.toReset),
                        ],
                        style: context.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                  const SpaceVertical(24),
                  Center(
                    child: Text(
                      'Don’t have a swimbooker account?',
                      style: context.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        SignUpScreen.navigateTo(context, false);
                      },
                      child: Text(
                        AppStrings.signUp,
                        style: context.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
