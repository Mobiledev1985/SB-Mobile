import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/utility/styles/app_styles.dart';
import 'package:sb_mobile/features/authentication/ui/widgets/login_page.dart';

class LoginHomePage extends StatefulWidget {
  const LoginHomePage({Key? key}) : super(key: key);

  @override
  State<LoginHomePage> createState() {
    return _LoginHomePageState();
  }
}

class _LoginHomePageState extends State<LoginHomePage> {
  final LoginPage loginPage = const LoginPage(isBackButton: false);
  AppStyles appStyles = AppStyles();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle defaultStyle = TextStyle(
      fontFamily: appStyles.fontGilroy,
      fontSize: 17,
      fontWeight: FontWeight.w100,
      color: Colors.black,
      letterSpacing: 0.1,
    );

    TextStyle linkStyle = TextStyle(
      fontFamily: appStyles.fontGilroy,
      fontSize: 17,
      fontWeight: FontWeight.bold,
      color: Colors.black,
      letterSpacing: 0.1,
      decoration: TextDecoration.underline,
    );

    return Scaffold(
      key: scaffoldKey,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: context.dynamicHeight(0.1),
            ),
            Container(
              margin: EdgeInsets.only(left: context.dynamicWidth(0.05)),
              child: Text(
                "Your Profile",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: appStyles.fontGilroy,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              margin: EdgeInsets.only(left: context.dynamicWidth(0.05)),
              child: Text(
                "Login to book your next fishing session",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontFamily: appStyles.fontGilroy,
                    fontSize: 16.5,
                    fontWeight: FontWeight.w400,
                    color: Colors.black38,
                    letterSpacing: 0.1),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            GestureDetector(
              child: Container(
                height: context.dynamicHeight(0.065),
                width: context.dynamicWidth(1.0),
                margin:
                    const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => loginPage),
                );
                // Navigator.of(context).pushNamed('/angler/login');
              },
            ),
            const SizedBox(
              height: 10.0,
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 20.0, left: 20.0, right: 50.0),
              child: RichText(
                textAlign: TextAlign.center,
                softWrap: true,
                text: TextSpan(
                  style: defaultStyle,
                  children: <TextSpan>[
                    const TextSpan(text: 'Don\'t have an account? '),
                    TextSpan(
                        text: 'Sign Up',
                        style: linkStyle,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context)
                                .pushNamed('/angler/signup', arguments: false);
                          }),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
