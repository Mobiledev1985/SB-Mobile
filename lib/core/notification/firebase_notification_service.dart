import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:sb_mobile/core/notification/notification_handler.dart';
import 'package:sb_mobile/core/notification/web_view_screen.dart';
import 'package:sb_mobile/features/authentication/ui/views/sb_plus_purchase_screen.dart';
import 'package:sb_mobile/features/home_page/cubit/home_page_cubit.dart';
import 'local_notification_service.dart';

class FirebaseNotificationService {
  static Future<void> firebaseMessagingInitialization(
      BuildContext context) async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    ///App is terminated or close and user taps and it open app from terminated state
    messaging.getInitialMessage().then(
      (message) async {
        if (Platform.isIOS && message != null) {
          if (message.data.containsKey('article_id')) {
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
              arguments: {'id': message.data['article_id']},
            );
          } else if (message.data.containsKey('url')) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WebViewScreen(
                  url: message.data['url'],
                  isGoBackToHomeScreen: true,
                  title: message.notification?.title ?? '',
                ),
              ),
            );
          } else if (message.data.containsKey('section')) {
            await Future.delayed(const Duration(seconds: 2));
            final NotificationHandler notificationHandler =
                NotificationHandler.getInstance();
            final String section = message.data['section']!;
            if (notificationHandler.homeNavigationItems.contains(section)) {
              // ignore: use_build_context_synchronously
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
              // FeatureListScreen.navigateTo(
              //     context,
              //     // ignore: use_build_context_synchronously
              //     (context.read<HomePageCubit>().state as HomePageLoaded)
              //         .profile
              //         ?.email);
            } else if (notificationHandler.mySBNavigationItems
                .contains(section)) {
              // ignore: use_build_context_synchronously
              notificationHandler.mySbNotificationHandler(context, section);
            } else if (notificationHandler.sbPlusNavigation.contains(section)) {
              // ignore: use_build_context_synchronously
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
              // ignore: use_build_context_synchronously
              notificationHandler.bottomBarNotificationHandler(
                  context, section);
            }
          }
        }
      },
    );

    ///App in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      if (message != null) {
        if (Platform.isAndroid) {
          ///Firebase not send heads up notification when app in foreground, for that use flutter local notification to display heads up notification
          LocalNotificationService.display(message);
        }
      }
    });

    ///App in background and user taps on notification
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) async {
        if (message.data.containsKey('article_id')) {
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
            arguments: {'id': message.data['article_id']},
          );
        } else if (message.data.containsKey('url')) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WebViewScreen(
                url: message.data['url'],
                isGoBackToHomeScreen: true,
                title: message.notification?.title ?? '',
              ),
            ),
          );
        } else if (message.data.containsKey('section')) {
          await Future.delayed(const Duration(seconds: 2));
          final NotificationHandler notificationHandler =
              NotificationHandler.getInstance();
          final String section = message.data['section']!;
          if (notificationHandler.homeNavigationItems.contains(section)) {
            // ignore: use_build_context_synchronously
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
            // ignore: use_build_context_synchronously
            notificationHandler.mySbNotificationHandler(context, section);
          } else if (notificationHandler.sbPlusNavigation.contains(section)) {
            // ignore: use_build_context_synchronously
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
            // ignore: use_build_context_synchronously
            notificationHandler.bottomBarNotificationHandler(context, section);
          }
        }
      },
    );

    ///Heads ap notification for iOS
    messaging.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
    enableIOSNotifications();

    await messaging.requestPermission(
      announcement: false,
      criticalAlert: true,
      provisional: false,
    );
  }

  static enableIOSNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }
}

/// This function called when app is in the background or terminated.
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {}
