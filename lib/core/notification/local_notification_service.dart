import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:sb_mobile/core/notification/notification_handler.dart';
import 'package:sb_mobile/core/notification/web_view_screen.dart';
import 'package:sb_mobile/features/authentication/ui/views/sb_plus_purchase_screen.dart';
// import 'package:sb_mobile/features/authentication/ui/widgets/feature_list_screen.dart';
import 'package:sb_mobile/features/home_page/cubit/home_page_cubit.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class LocalNotificationService {
  static Future<void> initialize(BuildContext context) async {
    var androidSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSSettings = const DarwinInitializationSettings();
    var initSettings =
        InitializationSettings(android: androidSettings, iOS: iOSSettings);
    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        if (details.payload != null) {
          final data =
              details.payload!.substring(1, details.payload!.length - 1);

          List<String> keyValuePairs = data.split(', ');

          Map<String, String> dataMap = {};

          for (String pair in keyValuePairs) {
            List<String> parts = pair.split(': ');

            if (parts.length == 2) {
              String key = parts[0].trim();
              String value = parts[1].trim();

              dataMap[key] = value;
            }
          }
          if (dataMap.containsKey('article_id')) {
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
            Navigator.of(context).pushNamed(
              '/social/blog',
              arguments: {'id': dataMap['article_id']},
            );
          } else if (dataMap.containsKey('url')) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WebViewScreen(
                  url: dataMap['url']!,
                  isGoBackToHomeScreen: true,
                  title: '',
                ),
              ),
            );
          } else if (dataMap.containsKey('section')) {
            final NotificationHandler notificationHandler =
                NotificationHandler.getInstance();
            final String section = dataMap['section']!;
            if (notificationHandler.homeNavigationItems.contains(section)) {
              notificationHandler.homeScreenExtendedScreenNavigation(
                  context, section);
            } else if (section == 'sb_plus_signup') {
              // ignore: use_build_context_synchronously
              SbPlusPurchaseScreen.navigateTo(
                context,
                (
                  // ignore: use_build_context_synchronously
                  email: (context.read<HomePageCubit>().state as HomePageLoaded)
                          .profile
                          ?.email ??
                      '',
                  isLoggedIn:
                      // ignore: use_build_context_synchronously
                      (context.read<HomePageCubit>().state as HomePageLoaded)
                              .profile !=
                          null
                ),
              );
            } else if (notificationHandler.mySBNavigationItems
                .contains(section)) {
              notificationHandler.mySbNotificationHandler(context, section);
            } else if (notificationHandler.sbPlusNavigation.contains(section)) {
              notificationHandler
                  .sbPlusNotificationHandler(context, section)
                  .then((value) {
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
              });
            } else if (notificationHandler.bottomBarItems.contains(section)) {
              notificationHandler.bottomBarNotificationHandler(
                  context, section);
            }
          }
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  static void display(RemoteMessage message) async {
    try {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'swimbooker_mobile', // id
        'swimbooker_mobile channel', // title
        description: ' SwimBooker app push notification', // description
        importance: Importance.max,
      );

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      final NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            priority: Priority.high,
            importance: Importance.high,
            playSound: true,
          ),
          iOS: const DarwinNotificationDetails(presentSound: false));
      flutterLocalNotificationsPlugin.show(
        id,
        message.notification != null
            ? message.notification!.title
            : message.data['title'],
        message.notification != null
            ? message.notification!.body
            : message.data['body'],
        notificationDetails,
        payload: message.data.toString(),
      );
    } catch (e) {
      //
    }
  }
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}
