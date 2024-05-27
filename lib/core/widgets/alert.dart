import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
// import 'package:platform_alert_dialog/platform_alert_dialog.dart';
import 'package:sb_mobile/core/utility/styles/app_styles.dart';

AppStyles appStyles = AppStyles();

void showAlert(String message, {Color color = const Color(0XFF2772AF)}) {
  showSimpleNotification(
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        message,
        style: TextStyle(
            fontFamily: appStyles.fontGilroy,
            fontWeight: FontWeight.bold,
            fontSize: 22),
      ),
    ),
    slideDismissDirection: DismissDirection.horizontal,
    duration: const Duration(seconds: 4),
    background: color,
    elevation: 0,
    position: NotificationPosition.top,
  );
}

void showContextInfo(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      AppStyles appStyle = AppStyles();
      return AlertDialog(
        title: Text(
          'Info!',
          style: TextStyle(
              fontFamily: appStyle.fontGilroy,
              fontSize: 15,
              color: Colors.black),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Your search filters will be applied from your next search',
                  style: TextStyle(
                    fontFamily: appStyle.fontGilroy,
                    fontSize: 13,
                  )),
            ],
          ),
        ),
        actions: const <Widget>[
          // DialogAction(
          //   child: Text('Dismiss'),
          //   actionType: ActionType.Preferred,
          //   onPressed: () {
          //     Navigator.pop(context);
          //   },
          // ),
        ],
      );
    },
  );
}

void showBackendErrorResponse(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      AppStyles appStyle = AppStyles();
      return AlertDialog(
        title: Text(
          'Oops!',
          style: TextStyle(
              fontFamily: appStyle.fontGilroy,
              fontSize: 15,
              color: Colors.black),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Error fetching data from server.',
                  style: TextStyle(
                    fontFamily: appStyle.fontGilroy,
                    fontSize: 13,
                  )),
              Text('Check your internet connection and try again',
                  style: TextStyle(
                    fontFamily: appStyle.fontGilroy,
                    fontSize: 13,
                  )),
            ],
          ),
        ),
        actions: const <Widget>[
          // PlatformDialogAction(
          //   child: Text('Dismiss'),
          //   actionType: ActionType.Preferred,
          //   onPressed: () {
          //       Navigator.pop(context);
          //   },
          // ),
        ],
      );
    },
  );
}

void selectBookingParams(BuildContext context, String msg) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      AppStyles appStyle = AppStyles();

      return AlertDialog(
        title: Text(
          'Oops!',
          style: TextStyle(
              fontFamily: appStyle.fontGilroy,
              fontSize: 15,
              color: Colors.black),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Invalid Booking Parameter(s)',
                  style: TextStyle(
                      fontFamily: appStyle.fontGilroy,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              Text(msg,
                  style: TextStyle(
                      fontFamily: appStyle.fontGilroy,
                      fontSize: 13,
                      fontWeight: FontWeight.w100,
                      color: Colors.red)),
            ],
          ),
        ),
        actions: const <Widget>[
          // PlatformDialogAction(
          //   child: Text('Dismiss'),
          //   actionType: ActionType.Preferred,
          //   onPressed: () {
          //     Navigator.pop(context);
          //   },
          // ),
        ],
      );
    },
  );
}
