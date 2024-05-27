import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:sb_mobile/core/config/server_config.dart';
import 'package:sb_mobile/core/widgets/alert.dart';

class InSessionWebView extends StatefulWidget {
  final String token;
  const InSessionWebView({
    Key? key,
    required this.token,
  }) : super(key: key);

  @override
  State<InSessionWebView> createState() => _InSessionWebViewState();
}

class _InSessionWebViewState extends State<InSessionWebView> {
  late InAppWebViewController _webViewController;
  ApiServerConfig apiServerConfig = ApiServerConfig();
  late String urlString;

  @override
  void initState() {
    super.initState();
    urlString = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.chevron_left),
          color: Colors.white,
        ),
        backgroundColor: appStyles.sbBlue,
      ),
      body: InAppWebView(
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform:
              InAppWebViewOptions(javaScriptEnabled: true, supportZoom: false),
        ),
        // initialUrlRequest: URLRequest(url: Uri.parse(url1)),
        onWebViewCreated: (InAppWebViewController webViewController) async {
          _webViewController = webViewController;
          await CookieManager.instance().setCookie(
            url: Uri.parse(urlString),
            name: 'access_token_cookie',
            value: widget.token,
            domain: '.swimbooker.com',
            isHttpOnly: true,
            sameSite: HTTPCookieSameSitePolicy.NONE,
            isSecure: true,
            path: "/",
          );
          await _webViewController.loadUrl(
              urlRequest: URLRequest(url: Uri.parse(urlString)));
        },
        onLoadStart: (controller, url) async {
          await CookieManager.instance().setCookie(
            url: Uri.parse(urlString),
            name: 'access_token_cookie',
            value: widget.token,
            domain: '.swimbooker.com',
            isHttpOnly: true,
            sameSite: HTTPCookieSameSitePolicy.NONE,
            isSecure: true,
            path: "/",
          );
          // print("Started to load: $url");
        },
        onLoadError: (controller, url, code, message) {
          // print("Failed to load URL: $url\nError: $message");
        },
        onLoadStop: (controller, url) async {
          await CookieManager.instance().setCookie(
            url: Uri.parse(urlString),
            name: 'access_token_cookie',
            value: widget.token,
            domain: '.swimbooker.com',
            isHttpOnly: true,
            sameSite: HTTPCookieSameSitePolicy.NONE,
            isSecure: true,
            path: "/",
          );
        },
      ),
    );
  }
}
