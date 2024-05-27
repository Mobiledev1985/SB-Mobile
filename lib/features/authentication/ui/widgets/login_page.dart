import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sb_mobile/core/config/authenticator.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/utility/styles/app_styles.dart';
import 'package:sb_mobile/core/widgets/alert.dart';
import 'package:sb_mobile/features/authentication/cubit/auth_helper_cubit.dart';
import 'package:sb_mobile/features/authentication/cubit/authentication_status_cubit.dart';
import 'package:sb_mobile/features/authentication/data/sources/api/sb_backend.dart';
import 'package:sb_mobile/features/home_page/cubit/home_page_cubit.dart';

class LoginPage extends StatefulWidget {
  final bool isBackButton;
  const LoginPage({Key? key, required this.isBackButton}) : super(key: key);

  @override
  State<LoginPage> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AppStyles appStyles = AppStyles();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isValidEmail = true;
  bool isValidPassword = true;

  final ValueNotifier<bool> isPasswordVisible = ValueNotifier(true);

  SwimbookerApiProvider apiProvider = SwimbookerApiProvider();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    isPasswordVisible.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle defaultStyle = TextStyle(
      fontFamily: appStyles.fontGilroy,
      fontSize: 16.5,
      fontWeight: FontWeight.w400,
      color: Colors.black,
      letterSpacing: 0.1,
    );

    TextStyle linkStyle = TextStyle(
      fontFamily: appStyles.fontGilroy,
      fontSize: 16.5,
      fontWeight: FontWeight.bold,
      color: appStyles.sbBlue,
      letterSpacing: 0.1,
      decoration: TextDecoration.underline,
    );

    return Scaffold(
      body: PopScope(
        canPop: false,
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AuthHelperCubit(),
            ),
          ],
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  visible: widget.isBackButton,
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(
                        right: context.dynamicWidth(0.8),
                        top: context.dynamicHeight(0.05)),
                    child: GestureDetector(
                      child: CircleAvatar(
                        backgroundColor: appStyles.sbGrey,
                        child: const Icon(Icons.clear),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: context.dynamicHeight(0.1),
                ),
                Container(
                  margin: EdgeInsets.only(left: context.dynamicWidth(0.05)),
                  width: double.infinity,
                  child: Text(
                    "Your Profile",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: appStyles.fontGilroy,
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  margin: EdgeInsets.only(left: context.dynamicWidth(0.05)),
                  width: double.infinity,
                  child: Text(
                    "Login to book your next fishing session",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: appStyles.fontGilroy,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: appStyles.passwordTextColor,
                        letterSpacing: 0.1),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onChanged: (String value) {
                      if (value != "") {
                        setState(() {
                          isValidEmail = RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#//$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value);
                        });
                      } else {
                        setState(() {
                          isValidEmail = true;
                        });
                      }
                    },
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: appStyles.fontGilroy,
                        color: Colors.black),
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          // width: 0.0 produces a thin "hairline" border
                          borderSide: BorderSide(
                              color: isValidEmail ? Colors.black : Colors.red,
                              width: 0.0),
                        ),
                        border: const OutlineInputBorder(),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ImageIcon(
                            const AssetImage("assets/auth/mail.png"),
                            size: 10.0,
                            color: appStyles.sbBlue,
                          ),
                        ),
                        labelText: isValidEmail ? 'E-mail' : 'invalid e-mail',
                        hintText: 'Enter your email address'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: ValueListenableBuilder(
                      valueListenable: isPasswordVisible,
                      builder: (context, isVisible, _) {
                        return TextField(
                          controller: passwordController,
                          obscureText: isVisible,
                          onChanged: (String value) {
                            setState(() {
                              isValidPassword = passwordController.text != "" &&
                                  passwordController.text.length > 3;
                            });
                          },
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: appStyles.fontGilroy,
                              color: Colors.black),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                // width: 0.0 produces a thin "hairline" border
                                borderSide: BorderSide(
                                    color: isValidPassword
                                        ? Colors.black
                                        : Colors.red,
                                    width: isValidPassword ? 0.0 : 1.0),
                              ),
                              border: const OutlineInputBorder(),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ImageIcon(
                                  const AssetImage("assets/auth/lock.png"),
                                  size: 10.0,
                                  color: appStyles.sbBlue,
                                ),
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
                                    color: AppColors.blue,
                                  ),
                                ),
                              ),
                              suffixIconConstraints: const BoxConstraints(
                                maxHeight: 24,
                                maxWidth: 42,
                              ),
                              labelText: isValidPassword
                                  ? 'Password'
                                  : 'Invalid password',
                              hintText: 'Enter your secure password'),
                        );
                      }),
                ),
                GestureDetector(
                  child: Container(
                    height: context.dynamicHeight(0.065),
                    width: context.dynamicWidth(1.0),
                    margin: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 10.0),
                    decoration: BoxDecoration(
                        color: appStyles.sbBlue,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Center(
                      child: Text(
                        "Login",
                        style: TextStyle(
                            fontSize: 25,
                            fontFamily: appStyles.fontGilroy,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  onTap: () async {
                    if (isValidPassword &&
                            isValidEmail &&
                            emailController.text.isNotEmpty ||
                        passwordController.text.isNotEmpty) {
                      await auth
                          .login(
                        username: emailController.text,
                        password: passwordController.text,
                        aggresive: true,
                      )
                          .then((response) {
                        if (response) {
                          context
                              .read<AuthenticationStatusCubit>()
                              .reload()
                              .then((value) async {
                            if (widget.isBackButton) {
                              Navigator.pop(context, true);
                            }
                            await context.read<HomePageCubit>().refresh(false);
                            showAlert("Login Successful");

                            emailController.clear();
                            passwordController.clear();
                          });
                        }
                      });
                    } else {
                      showAlert("Please Enter valid credentials");
                    }
                  },
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: context.dynamicWidth(0.0),
                      right: context.dynamicWidth(0.0),
                      top: 25.0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    softWrap: true,
                    text: TextSpan(
                      style: defaultStyle,
                      children: <TextSpan>[
                        const TextSpan(text: 'Forgot your details? Click '),
                        TextSpan(
                            text: 'HERE',
                            style: linkStyle,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context).pushNamed(
                                    '/angler/reset/password',
                                    arguments: false);
                              }),
                        const TextSpan(text: ' to reset'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: context.dynamicWidth(0.0),
                      right: context.dynamicWidth(0.0),
                      top: 10.0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    softWrap: true,
                    text: TextSpan(
                      style: defaultStyle,
                      children: const <TextSpan>[
                        TextSpan(text: 'Don\'t have an account? '),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: context.dynamicWidth(0.0),
                      right: context.dynamicWidth(0.0),
                      top: 10.0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    softWrap: true,
                    text: TextSpan(
                      style: defaultStyle,
                      children: <TextSpan>[
                        TextSpan(
                            text: 'SIGN UP HERE',
                            style: linkStyle,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context).pushNamed(
                                    '/angler/signup',
                                    arguments: false);
                              }),
                      ],
                    ),
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.only(
                //       left: context.dynamicWidth(0.0),
                //       right: context.dynamicWidth(0.0),
                //       top: 10.0),
                //   child: RichText(
                //     textAlign: TextAlign.center,
                //     softWrap: true,
                //     text: TextSpan(
                //       style: defaultStyle,
                //       children: <TextSpan>[
                //         TextSpan(
                //           text: 'SB+',
                //           style: linkStyle,
                //           recognizer: TapGestureRecognizer()
                //             ..onTap = () {
                //               WelcomeScreen.navigateTo(context);
                //             },
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
