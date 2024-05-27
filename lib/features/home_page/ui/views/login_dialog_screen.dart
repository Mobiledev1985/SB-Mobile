import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sb_mobile/core/config/authenticator.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_images.dart';
import 'package:sb_mobile/core/constant/app_strings.dart';
import 'package:sb_mobile/core/constant/ui_constant.dart';
import 'package:sb_mobile/core/validators/validators.dart';
import 'package:sb_mobile/core/widgets/alert.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';
import 'package:sb_mobile/features/home_page/cubit/home_page_cubit.dart';
import 'package:sb_mobile/features/home_page/ui/widgets/common_bar.dart';
import 'package:sb_mobile/features/home_page/ui/widgets/sb_promo_banner.dart';
import 'package:sb_mobile/main.dart';
import 'package:sb_mobile/features/authentication/data/sources/api/sb_backend.dart';

class LoginDialogScreen extends StatefulWidget {
  final double topPadding;
  final bool isFromBottomBar360;

  const LoginDialogScreen({
    super.key,
    required this.topPadding,
    required this.isFromBottomBar360,
  });

  @override
  State<LoginDialogScreen> createState() => _LoginDialogScreenState();
}

class _LoginDialogScreenState extends State<LoginDialogScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> form = GlobalKey<FormState>();

  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<bool> isPasswordVisible = ValueNotifier(true);

  SwimbookerApiProvider apiProvider = SwimbookerApiProvider();

  @override
  void dispose() {
    isLoading.dispose();
    isPasswordVisible.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Transform(
      transform: Matrix4.translationValues(
          0, Platform.isIOS ? -widget.topPadding : 0, 0),
      child: Dialog(
        alignment: Alignment.topCenter,
        insetPadding: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(defaultBorderRadius),
            bottomRight: Radius.circular(defaultBorderRadius),
          ),
        ),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (Platform.isIOS) SpaceVertical(widget.topPadding),
              CommonBar(
                topPadding: 0,
                isFromDialog: true,
                anglerProfile: null,
                isExclusiveMediaScreen: false,
                isFromBottomBar360: widget.isFromBottomBar360,
              ),
              const Divider(
                height: 0,
                color: Color(0xffEFEFEF),
              ),
              const SpaceVertical(14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Form(
                  key: form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.hiAngler,
                        style: textTheme.displaySmall
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SpaceVertical(5),
                      Text(
                        AppStrings.freeAccount,
                        style: textTheme.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w400),
                      ),
                      const SpaceVertical(24),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: AppStrings.email,
                          prefixIcon: Padding(
                            padding:
                                const EdgeInsets.only(left: 6.0, right: 12),
                            child: SvgPicture.asset(
                              AppImages.email,
                              width: 24,
                              height: 24,
                              fit: BoxFit.fill,
                              colorFilter: const ColorFilter.mode(
                                AppColors.secondaryBlue,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          prefixIconConstraints: const BoxConstraints(
                            maxHeight: 24,
                            maxWidth: 42,
                          ),
                        ),
                        validator: Validators.emailValidator,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: ValueListenableBuilder(
                            valueListenable: isPasswordVisible,
                            builder: (context, isVisible, _) {
                              return TextFormField(
                                controller: passwordController,
                                obscureText: isVisible,
                                decoration: InputDecoration(
                                  hintText: AppStrings.password,
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 6.0, right: 12),
                                    child: SvgPicture.asset(
                                      AppImages.password,
                                      width: 24,
                                      height: 24,
                                      fit: BoxFit.fill,
                                      colorFilter: const ColorFilter.mode(
                                        AppColors.secondaryBlue,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                  prefixIconConstraints: const BoxConstraints(
                                    maxHeight: 24,
                                    maxWidth: 42,
                                  ),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      isPasswordVisible.value =
                                          !isPasswordVisible.value;
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 6.0, right: 12),
                                      child: Icon(
                                        isVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        size: 24,
                                        color: AppColors.secondaryBlue,
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
                            }),
                      ),
                      ValueListenableBuilder(
                        valueListenable: isLoading,
                        builder: (context, loading, __) {
                          return loading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.blue,
                                  ),
                                )
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.blue,
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
                                        (response) async {
                                          if (response) {
                                            final String? subscriptionLevel =
                                                await apiProvider
                                                    .getSubscriptionLevel();

                                            isLoading.value = false;
                                            showAlert("Login Successful");
                                            emailController.clear();
                                            passwordController.clear();
                                            // ignore: use_build_context_synchronously
                                            Navigator.pop(context);

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

                                            // ignore: use_build_context_synchronously
                                            context
                                                .read<HomePageCubit>()
                                                .refresh(false)
                                                .then(
                                                  (value) {},
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
                      const SpaceVertical(12),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                  text: AppStrings.forgotPasswordText),
                              TextSpan(
                                text: AppStrings.here,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: AppColors.blue,
                                  fontWeight: FontWeight.w600,
                                  height: 1.0,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    FocusScope.of(context).unfocus();

                                    Navigator.of(context).pushNamed(
                                        '/angler/reset/password',
                                        arguments: true);
                                  },
                              ),
                              const TextSpan(text: AppStrings.toReset),
                            ],
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      const SpaceVertical(24),
                      Center(
                        child: Text(
                          AppStrings.dontHaveAccount,
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SpaceVertical(5),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.green),
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          Navigator.of(context)
                              .pushNamed('/angler/signup', arguments: true);
                        },
                        child: const Text(AppStrings.signUp),
                      ),
                      const SpaceVertical(8),
                      FutureBuilder(
                        future: PackageInfo.fromPlatform(),
                        builder: (context, sp) {
                          return Center(
                            child: Text(
                              'Version : ${sp.data?.version}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          );
                        },
                      ),
                      const SpaceVertical(8),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
