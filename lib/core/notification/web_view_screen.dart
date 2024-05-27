import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/features/home_page/ui/views/bottom_bar_screen.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  final bool isGoBackToHomeScreen;
  final String title;
  const WebViewScreen({
    super.key,
    required this.url,
    required this.isGoBackToHomeScreen,
    required this.title,
  });

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.isGoBackToHomeScreen) {
      if (Platform.isAndroid) {
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
              statusBarColor: AppColors.blue,
              statusBarIconBrightness: Brightness.light),
        );
      } else {
        FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
        FlutterStatusbarcolor.setStatusBarColor(AppColors.blue);
      }
    }
  }

  @override
  void dispose() {
    if (widget.isGoBackToHomeScreen) {
      if (Platform.isAndroid) {
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark),
        );
      } else {
        FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
        FlutterStatusbarcolor.setStatusBarColor(Colors.white);
      }
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColors.blue,
        title: Text(widget.title),
        titleTextStyle: context.textTheme.titleLarge?.copyWith(
          color: AppColors.white,
        ),
        leading: IconButton(
          onPressed: () {
            if (widget.isGoBackToHomeScreen) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const BottomBarScreen(),
                ),
              );
            } else {
              Navigator.pop(context);
            }
          },
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.white,
          ),
          color: Colors.black,
        ),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: Uri.parse(widget.url),
        ),
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform:
              InAppWebViewOptions(javaScriptEnabled: true, supportZoom: false),
        ),
        // onLoadStart: (controller, url) async {},
        // onLoadError: (controller, url, code, message) {
        //   // print("Failed to load URL: $url\nError: $message");
        // },
        // onLoadStop: (controller, url) async {},
      ),
    );
  }
}
