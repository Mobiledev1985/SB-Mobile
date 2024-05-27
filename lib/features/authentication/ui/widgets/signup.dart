import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/utility/styles/app_styles.dart';
import 'package:sb_mobile/core/widgets/alert.dart';
import 'package:sb_mobile/features/authentication/data/models/signup_model.dart';
import 'package:sb_mobile/features/authentication/data/sources/api/sb_backend.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({Key? key}) : super(key: key);
  @override
  State<SignupForm> createState() {
    return _SignupFormState();
  }
}

class _SignupFormState extends State<SignupForm> {
  AppStyles appStyles = AppStyles();
  SignupRecord signUp = SignupRecord();
  SwimbookerApiProvider apiProvider = SwimbookerApiProvider();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final firstNameController = TextEditingController();
  final surNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Map<String, bool> validity = {
    'firstName': false,
    'lastName': false,
    'email': false,
    'password': false,
    'password_match': false
  };
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void clearTextFileds() {
    firstNameController.clear();
    surNameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    const EdgeInsets boxPadding =
        EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20);
    final TextStyle boxStyle = TextStyle(
        fontSize: 18, fontFamily: appStyles.fontGilroy, color: Colors.black);
    return Scaffold(
      key: scaffoldKey,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: context.dynamicWidth(0.0),
                      top: context.dynamicHeight(0.03)),
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: 'swim',
                            style: TextStyle(
                                fontSize: 30,
                                fontFamily: appStyles.fontGilroy,
                                color: appStyles.sbBlue,
                                fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: 'booker',
                            style: TextStyle(
                                fontSize: 30,
                                fontFamily: appStyles.fontGilroy,
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: context.dynamicWidth(0.0), top: 20),
                  child: Column(
                    children: [
                      AutoSizeText(
                        "Signup for swimbooker and find fisheries",
                        minFontSize: 15,
                        maxFontSize: 22,
                        maxLines: 1,
                        style: TextStyle(
                            height: 1.3,
                            color: Colors.black,
                            fontFamily: appStyles.fontGilroy,
                            fontSize: 17),
                      ),
                      AutoSizeText(
                        "near you now - its completely FREE!",
                        minFontSize: 15,
                        maxFontSize: 22,
                        maxLines: 1,
                        style: TextStyle(
                            height: 1.3,
                            color: Colors.black,
                            fontFamily: appStyles.fontGilroy,
                            fontSize: 17),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: boxPadding,
                  child: TextField(
                    controller: firstNameController,
                    onChanged: (String value) {
                      if (value != "" && value != " ") {
                        setState(() {
                          signUp.firstName = value;
                          validity['firstName'] = true;
                        });
                      } else {
                        setState(() {
                          validity['firstName'] = false;
                        });
                      }
                    },
                    style: boxStyle,
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      border: const OutlineInputBorder(),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ImageIcon(
                          const AssetImage("assets/auth/name_user.png"),
                          size: 10.0,
                          color: appStyles.sbBlue,
                        ),
                      ),
                      labelText: 'First Name',
                    ),
                  ),
                ),
                Padding(
                  padding: boxPadding,
                  child: TextField(
                    controller: surNameController,
                    onChanged: (String value) {
                      if (value != "" && value != " ") {
                        setState(() {
                          signUp.lastName = value;
                          validity['lastName'] = true;
                        });
                      } else {
                        setState(() {
                          validity['lastName'] = false;
                        });
                      }
                    },
                    style: boxStyle,
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      border: const OutlineInputBorder(),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ImageIcon(
                          const AssetImage("assets/auth/name_user.png"),
                          size: 10.0,
                          color: appStyles.sbBlue,
                        ),
                      ),
                      labelText: 'Last Name',
                    ),
                  ),
                ),
                Padding(
                  padding: boxPadding,
                  child: TextField(
                    controller: emailController,
                    onChanged: (String value) {
                      if (value != "" && value != " ") {
                        setState(() {
                          bool isValidEmail = RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value);
                          if (isValidEmail) {
                            validity['email'] = true;
                            signUp.email = value;
                          }
                        });
                      } else {
                        setState(() {
                          validity['email'] = false;
                        });
                      }
                    },
                    style: boxStyle,
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.0),
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
                      labelText: 'E-mail',
                    ),
                  ),
                ),
                Padding(
                  padding: boxPadding,
                  child: TextField(
                    obscureText: true,
                    controller: passwordController,
                    onChanged: (String value) {
                      if (value != "" && value != " ") {
                        setState(() {
                          validity['password'] = true;
                        });
                      } else {
                        setState(() {
                          validity['password'] = false;
                        });
                      }
                    },
                    style: boxStyle,
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.0),
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
                      labelText: 'Password',
                    ),
                  ),
                ),
                Padding(
                  padding: boxPadding,
                  child: TextField(
                    obscureText: true,
                    controller: confirmPasswordController,
                    onSubmitted: (String value) {
                      if (value != "" &&
                          value != " " &&
                          value == passwordController.text) {
                      } else {
                        showAlert("Passwords Don't match");
                      }
                    },
                    onChanged: (String value) {
                      if (value != "" &&
                          value != " " &&
                          value == passwordController.text) {
                        setState(() {
                          signUp.password = value;
                          validity['password_match'] = true;
                        });
                      } else {
                        setState(() {
                          validity['password_match'] = false;
                        });
                      }
                    },
                    style: boxStyle,
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.0),
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
                      labelText: 'Confirm Password',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: EdgeInsets.only(left: context.dynamicWidth(0)),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        backgroundColor: appStyles.sbBlue,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 20),
                        textStyle: TextStyle(
                            fontFamily: appStyles.fontGilroy,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    onPressed: () async {
                      performSignup();
                    },
                    child: const Text('SIGN ME UP!'),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> performSignup() async {
    var allValidItems = true;
    Map<String, String> nameMapping = {
      'firstName': "First Name",
      'lastName': "Last Name",
      'email': "E-mail",
      'password': "Password",
      'password_match': "Confirmed Password"
    };
    for (var key in validity.keys) {
      bool? item = validity[key];

      if (item == true) {
        allValidItems = allValidItems && true;
      } else {
        showAlert("Invalid ${nameMapping[key]} value");
        if (["firstName", "lastName", "email", "password"].contains(key)) {
          showAlert("Invalid ${nameMapping[key]} value");
        }
        if (["password_match"].contains(key)) {
          showAlert("Passwords Don't match");
        }
        allValidItems = allValidItems && false;
      }
    }
    if (allValidItems) {
      // bool response = await auth.login(
      //     username: emailController.text,
      //     password: passwordController.text,
      //     aggresive: true
      // );
      // if(response){
      //   showAlert("Login Successful");
      //   emailController.clear();
      //   passwordController.clear();
      //   Navigator.of(context).pushNamed('/angler/profile');
      // }
      apiProvider.registerUser(signUp: signUp).then((response) async {
        if (response) {
          firstNameController.clear();
          surNameController.clear();
          emailController.clear();
          passwordController.clear();
          confirmPasswordController.clear();
          Navigator.of(context).pushNamed('/angler/login/home');
        }
      });
    } else {
      // showAlert("Please complete all the fields with relevant values");
    }
  }
}
