import 'dart:io';

import 'package:avoid_keyboard/avoid_keyboard.dart';
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
import 'package:sb_mobile/core/widgets/space_horizontal.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';
import 'package:sb_mobile/features/authentication/cubit/auth_helper_cubit.dart';
import 'package:sb_mobile/features/authentication/data/models/signup_model.dart';
// import 'package:sb_mobile/features/authentication/providers/subscription_provider.dart';
import 'package:sb_mobile/features/authentication/ui/views/background.dart';
import 'package:sb_mobile/features/authentication/data/sources/api/sb_backend.dart';
// import 'package:sb_mobile/features/authentication/ui/widgets/tier_section_screen.dart';
import 'package:sb_mobile/features/home_page/cubit/home_page_cubit.dart';
import 'package:sb_mobile/features/home_page/ui/views/bottom_bar_provider.dart';
import 'package:sb_mobile/features/home_page/ui/views/bottom_bar_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key, required this.isFromDialog});

  final bool isFromDialog;

  static MaterialPageRoute<dynamic> buildRouter(bool isFromDialog) {
    return MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (context) => AuthHelperCubit(),
        child: SignUpScreen(isFromDialog: isFromDialog),
      ),
    );
  }

  static void navigateTo(
    BuildContext context,
    bool isFromDialog,
  ) {
    Navigator.pushNamed(
      context,
      RoutePaths.signupScreen,
      arguments: isFromDialog,
    );
  }

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController confirmEmailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  SwimbookerApiProvider apiProvider = SwimbookerApiProvider();

  final GlobalKey<FormState> form = GlobalKey<FormState>();

  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<bool> isPasswordVisible = ValueNotifier(true);
  final ValueNotifier<bool> isConfirmPasswordVisible = ValueNotifier(true);

  final ValueNotifier<bool> isAgree = ValueNotifier(false);
  final ValueNotifier<bool> isKeepMe = ValueNotifier(false);

  @override
  void initState() {
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

    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    confirmEmailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    isKeepMe.dispose();
    isLoading.dispose();
    isAgree.dispose();
    isConfirmPasswordVisible.dispose();
    isPasswordVisible.dispose();
    isLoading.dispose();
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
    super.dispose();
  }

  Future<void> onSignUp() async {
    try {
      if (form.currentState!.validate()) {
        if (!isAgree.value) {
          showAlert('You must accept the terms and conditions to continue');
          return;
        }
        FocusScope.of(context).unfocus();
        isLoading.value = true;
        final SignupRecord signupRecord = SignupRecord();
        signupRecord.email = emailController.text;
        signupRecord.lastName = lastNameController.text;
        signupRecord.firstName = firstNameController.text;
        signupRecord.password = passwordController.text;
        signupRecord.isNewsSubscribed = isKeepMe.value;
        final bool isRegister =
            await apiProvider.registerUser(signUp: signupRecord);
        if (isRegister) {
          // BottomBarProvider.of(context)
          //     .selectedBottomBarItem
          //     .value = 0;
          // Navigator.pushAndRemoveUntil(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) =>
          //           const BottomBarScreen(),
          //     ),
          //     (route) => false);
          final bool isLoaggedIn = await auth.login(
            username: emailController.text,
            password: passwordController.text,
            aggresive: true,
          );

          if (isLoaggedIn) {
            // ignore: use_build_context_synchronously
            await context.read<HomePageCubit>().refresh(false);
            // ignore: use_build_context_synchronously
            // if (context.read<SubscriptionProvider>().isFromBanner) {
            //   // ignore: use_build_context_synchronously
            //   TierSectionScreen.navigateTo(
            //     context,
            //     (email: emailController.text, isFromFeatureScreen: false),
            //     true,
            //   );
            // } else {
            // ignore: use_build_context_synchronously
            BottomBarProvider.of(context).selectedBottomBarItem.value = 0;

            // ignore: use_build_context_synchronously
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const BottomBarScreen(),
                ),
                (route) => false);
            // }

            emailController.clear();
            passwordController.clear();
          }

          // ignore: use_build_context_synchronously
          await context.read<AuthHelperCubit>().fetchAuthStatus();
        }

        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Background(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Form(
              key: form,
              child: AvoidKeyboard(
                spacing: 40,
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'First Name',
                                  style: context.textTheme.headlineMedium
                                      ?.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SpaceVertical(8),
                              TextFormField(
                                controller: firstNameController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                  hintText: 'First Name',
                                  filled: true,
                                  fillColor: AppColors.white,
                                ),
                                validator: Validators.nameValidator,
                              ),
                            ],
                          ),
                        ),
                        const SpaceHorizontal(12),
                        Expanded(
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Last Name',
                                  style: context.textTheme.headlineMedium
                                      ?.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SpaceVertical(8),
                              TextFormField(
                                controller: lastNameController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                  hintText: "Last Name",
                                  filled: true,
                                  fillColor: AppColors.white,
                                ),
                                validator: Validators.nameValidator,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SpaceVertical(40),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Email',
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: AppStrings.email,
                        filled: true,
                        fillColor: AppColors.white,
                      ),
                      validator: Validators.emailValidator,
                    ),
                    const SpaceVertical(12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Confirm Email',
                        style: context.textTheme.headlineMedium?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SpaceVertical(8),
                    TextFormField(
                      controller: confirmEmailController,
                      keyboardType: TextInputType.emailAddress,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: 'Confirm Email',
                        filled: true,
                        fillColor: AppColors.white,
                      ),
                      validator: (value) => Validators.emailConfirmValidator(
                        emailController.text.trim(),
                        value,
                      ),
                    ),
                    const SpaceVertical(40),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Password',
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
                            obscureText: isVisible,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              hintText: AppStrings.password,
                              filled: true,
                              fillColor: AppColors.white,
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
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Confirm Password',
                        style: context.textTheme.headlineMedium?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: ValueListenableBuilder(
                        valueListenable: isConfirmPasswordVisible,
                        builder: (context, isVisible, _) {
                          return TextFormField(
                            controller: confirmPasswordController,
                            obscureText: isVisible,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              hintText: 'Confirm Password',
                              filled: true,
                              fillColor: AppColors.white,
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  isConfirmPasswordVisible.value =
                                      !isConfirmPasswordVisible.value;
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 6.0, right: 12),
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
                            validator: (value) =>
                                Validators.passwordConfirmValidator(
                                    passwordController.text.trim(), value),
                          );
                        },
                      ),
                    ),
                    const SpaceVertical(10),
                    Row(
                      children: [
                        ValueListenableBuilder(
                          valueListenable: isAgree,
                          builder: (context, agree, _) {
                            return Checkbox(
                              value: agree,
                              fillColor: const MaterialStatePropertyAll(
                                  AppColors.white),
                              checkColor: AppColors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              side: const BorderSide(
                                color: Color(0xff379BEC),
                                width: 2,
                              ),
                              onChanged: (value) {
                                isAgree.value = !isAgree.value;
                              },
                            );
                          },
                        ),
                        Expanded(
                          child: Text(
                            'By creating an account I verify that I agree with swimbooker’s data policy and terms and conditions.',
                            style: context.textTheme.bodySmall?.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        ValueListenableBuilder(
                          valueListenable: isKeepMe,
                          builder: (context, keepme, _) {
                            return Checkbox(
                              value: keepme,
                              fillColor: const MaterialStatePropertyAll(
                                  AppColors.white),
                              checkColor: AppColors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              side: const BorderSide(
                                color: Color(0xff379BEC),
                                width: 2,
                              ),
                              onChanged: (value) {
                                isKeepMe.value = !isKeepMe.value;
                              },
                            );
                          },
                        ),
                        Expanded(
                          child: Text(
                            "Keep me up to date with swimbooker's new fisheries, updates, news and content.",
                            style: context.textTheme.bodySmall?.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SpaceVertical(20),
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
                                  onSignUp();
                                },
                                child: const Text(
                                  'SIGN ME UP!',
                                ),
                              );
                      },
                    ),
                    const SpaceVertical(34),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
