import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sb_mobile/core/utility/styles/app_styles.dart';

import 'image_picker_handler.dart';

// ignore: must_be_immutable
class ImagePickerDialog extends StatelessWidget {
  AppStyles appStyles = AppStyles();

  late final ImagePickerHandler _listener;
  late final AnimationController _controller;
  BuildContext? context;
  ImagePickerDialog(this._listener, this._controller, {super.key});
  Animation<double>? _drawerContentsOpacity;
  Animation<Offset>? _drawerDetailsPosition;

  void initState() {
    _drawerContentsOpacity = CurvedAnimation(
      parent: ReverseAnimation(_controller),
      curve: Curves.fastOutSlowIn,
    );
    _drawerDetailsPosition = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    ));
  }

  getImage(BuildContext context) {
    if (_drawerDetailsPosition == null || _drawerContentsOpacity == null) {
      return;
    }
    _controller.forward();
    showDialog(
      context: context,
      builder: (BuildContext context) => SlideTransition(
        position: _drawerDetailsPosition!,
        child: FadeTransition(
          opacity: ReverseAnimation(_drawerContentsOpacity!),
          child: this,
        ),
      ),
    );
  }

  void dispose() {
    _controller.dispose();
  }

  startTime() async {
    var duration = const Duration(milliseconds: 200);
    return Timer(duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pop(context!);
  }

  dismissDialog() {
    _controller.reverse();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Material(
        type: MaterialType.transparency,
        child: Opacity(
          opacity: 1.0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                GestureDetector(
                  onTap: () => _listener.openGallery(),
                  child: roundedButton(
                    "Gallery",
                    const EdgeInsets.fromLTRB(50.0, 50.0, 50.0, 5.0),
                  ),
                ),
                const SizedBox(height: 15.0),
                GestureDetector(
                  onTap: () => dismissDialog(),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                    child: roundedButton(
                      "Cancel",
                      const EdgeInsets.fromLTRB(50.0, 50.0, 50.0, 5.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget roundedButton(String buttonLabel, EdgeInsets margin) {
    var loginBtn = Container(
      margin: margin,
      padding: const EdgeInsets.all(15.0),
      alignment: FractionalOffset.center,
      decoration: BoxDecoration(
        color: appStyles.sbBlue,
        borderRadius: const BorderRadius.all(Radius.circular(100.0)),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0xFF696969),
            offset: Offset(1.0, 6.0),
            blurRadius: 0.001,
          ),
        ],
      ),
      child: Text(
        buttonLabel,
        style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            fontFamily: appStyles.fontGilroy),
      ),
    );
    return loginBtn;
  }
}
