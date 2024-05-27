import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sb_mobile/core/config/authenticator.dart';
import 'package:sb_mobile/core/config/user_model.dart';
import 'package:sb_mobile/core/widgets/alert.dart';

class ApiServerConfig {
  ApiServerConfig() {
    propertySearchEndpoint = "/api/$apiVersion/search/term?ba=True";
    searchEndpoint = "/api/$apiVersion/search";
    metaSearchEndpoint = "/api/$apiVersion/search/meta";
    adminTagIDs = "/api/$apiVersion/ops/search_tags/active";
    boundarySearchEndpoint = "/api/$apiVersion/search/boundary";
    fisheryDetailsEndpoint = "/api/$apiVersion/fishery";
    quickFacts = "$fisheryDetailsEndpoint/quick_facts";
    facilities = "$fisheryDetailsEndpoint/facilities";
    catchReportImageEndpoint = "/api/$apiVersion/fishery/catch/report/image";
    catchReportEndpoint = "/api/$apiVersion/fishery/catch/report";
    getCatchReportListEndpoint = "$catchReportEndpoint/list";
    getCreditHistoryEndpoint = "/api/$apiVersion/credit-history";
    getMyMembershipsEndpoint = "/api/$apiVersion/user/memberships";
    fisherySearchEndpoint = "/api/$apiVersion/fishery/fisheries";
    lakeAvailabilityEndpoint = "/api/$apiVersion/fishery/lake/bookings/mobile";
    bookingsFisheryDetailsEndpoint = "/api/$apiVersion/booking/details";
    loginUrl = "/api/$apiVersion/login";
    bookingsLakeAvailabilityEndpoint =
        "/api/$apiVersion/booking/lake/availability";
    bookingsSwimAvailabilityEndpoint =
        "/api/$apiVersion/booking/swim/availability";
    createBookingEndpoint = "/api/$apiVersion/booking/new";
    favEndpoint = "/api/$apiVersion/fav";
    userBookingsEndpoint = "/api/$apiVersion/user/bookings";
    perksEndpoint = "/api/$apiVersion/perks/users-perks";
    promotionEndpoint = "/api/$apiVersion/fishery/all/promotions";
    giveawayQuizEndpoint = "/api/$apiVersion/giveaway/users-quizzes";
    quizSubmitionEndpoint = "/api/$apiVersion/giveaway/quiz-submission";
    listAllWinnersEndpoint = "/api/$apiVersion/winner/list-all-winners";
    getSessions = "/api/$apiVersion/sessions";
    achievements = "/api/$apiVersion/user/achievements";
    sessionDetail = "$getSessions/detail";
    updateSession = "/api/$apiVersion/session_notes/update";
    fisheryRatingEndpoint = "/api/$apiVersion/fishery/rating";
    fisheryReviewEndpoint = "/api/$apiVersion/fishery/comment";
    authEndpoint = "/api/$apiVersion/auth";
    anglerProfileEndpoint = "/api/$apiVersion/user";
    nextSessionStartEndpoint = "$anglerProfileEndpoint/next-session-start";
    subscriptionLevelEndpoint = "$anglerProfileEndpoint/subscription-level";
    walletEndpoint = "/api/$apiVersion/wallet";
    identitiesEndpint = "/api/$apiVersion/identities";
    getUserStatisticsEndpoint = "/api/$apiVersion/get_user_statistics";
    getNotificationsEndpoint = "/api/$apiVersion/notifications";
    signUpEndpoint = "/api/$apiVersion/signup";
    signOut1Endpoint = "/api/$apiVersion/angler/refresh-revoke";
    signOut2Endpoint = "/api/$apiVersion/angler/access-revoke";
    passwordResetEndpoint = "/api/$apiVersion/login/reset";
    forgotPasswordEndpoint = "/api/$apiVersion/angler/reset";
    registerNewSubscriberEndpoint =
        "/api/$apiVersion/register/new-app-subscriber";
    verifySubscriptionEndPoint = '/api/$apiVersion/register/verify-app-receipt';
    uploadPicEndpoint = "/api/$apiVersion/users/image";
    uploadBackgroundEndpoint = "/api/$apiVersion/users/bg_image";
    featuredFisheryEndpoint = "/api/$apiVersion/featured";
    socialEndpoint = "/api/$apiVersion/social/mobile";
    homeEndpoint = "/api/$apiVersion/home/mobile";
    sbFlythroughs = "/api/$apiVersion/sb_flythroughs/mobile";
    sbVirtuals = "/api/$apiVersion/sb_virtuals/mobile";
    sbDiaries = "/api/$apiVersion/sb_diaries/mobile";
    blogEndpoint = "/api/$apiVersion/social/blog";
    luckyEndpoint = "/api/$apiVersion/lucky";
    liveReports = "/api/$apiVersion/live_reports";
  }
  final String apiVersion = "v1";
  final String baseUrl = "";

  final String proUrl = "";

  late String propertySearchEndpoint;
  late String searchEndpoint;
  late String quickFacts;
  late String facilities;
  late String metaSearchEndpoint;
  late String adminTagIDs;
  late String boundarySearchEndpoint;
  late String fisheryDetailsEndpoint;
  late String lakeAvailabilityEndpoint;
  late String bookingsFisheryDetailsEndpoint;
  late String bookingsLakeAvailabilityEndpoint;
  late String bookingsSwimAvailabilityEndpoint;
  late String createBookingEndpoint;
  late String loginUrl;
  late String favEndpoint;
  late String userBookingsEndpoint;
  late String perksEndpoint;
  late String promotionEndpoint;
  late String giveawayQuizEndpoint;
  late String quizSubmitionEndpoint;
  late String listAllWinnersEndpoint;
  late String getSessions;
  late String achievements;
  late String sessionDetail;
  late String updateSession;
  late String fisheryRatingEndpoint;
  late String fisheryReviewEndpoint;
  late String authEndpoint;
  late String anglerProfileEndpoint;
  late String nextSessionStartEndpoint;
  late String subscriptionLevelEndpoint;
  late String walletEndpoint;
  late String identitiesEndpint;
  late String getUserStatisticsEndpoint;
  late String getNotificationsEndpoint;
  late String getCatchReportListEndpoint;
  late String getCreditHistoryEndpoint;
  late String getMyMembershipsEndpoint;
  late String signUpEndpoint;
  late String signOut1Endpoint;
  late String signOut2Endpoint;
  late String passwordResetEndpoint;
  late String uploadPicEndpoint;
  late String uploadBackgroundEndpoint;
  late String forgotPasswordEndpoint;
  late String registerNewSubscriberEndpoint;
  late String verifySubscriptionEndPoint;
  late String featuredFisheryEndpoint;
  late String homeEndpoint;
  late String sbFlythroughs;
  late String sbVirtuals;
  late String sbDiaries;
  late String socialEndpoint;
  late String fisherySearchEndpoint;
  late String catchReportImageEndpoint;
  late String catchReportEndpoint;
  late String blogEndpoint;
  late String luckyEndpoint;
  late String liveReports;
}

class Authenticator {
  Authenticator() {
    cookieManager = CookieManager(sbCookieJar);
    sbDio.interceptors.add(cookieManager);
  }
  final Dio sbDio = Dio();
  var sbCookieJar = CookieJar();
  final api = ApiServerConfig();

  late CookieManager cookieManager;

  Future<bool> authenticateAngler(
      {String? username, String? password, required bool notify}) async {
    try {
      final authBox = await Hive.openBox<UserCredentials>(authBoxName);
      String? fcmToken;
      String? platformInfo;
      String? deviceName;
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;

      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final AndroidDeviceInfo androidDeviceInfo =
            await deviceInfo.androidInfo;
        platformInfo = "Android ${androidDeviceInfo.version.release}";
        deviceName = "${androidDeviceInfo.brand} ${androidDeviceInfo.model}";
      } else {
        final IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
        platformInfo = 'iOS ${iosDeviceInfo.systemVersion}';
        deviceName = iosDeviceInfo.utsname.nodename;
      }

      try {
        fcmToken = await FirebaseMessaging.instance.getToken();
      } on Exception {
        //
      }
      List<String?> invalidValues = ["", null];
      if (invalidValues.contains(username) ||
          invalidValues.contains(password)) {
        UserCredentials? credentials = authBox.get(authBoxKey);
        // authBox.close();
        if (credentials != null) {
          Map<String, String> headers = {
            'Content-Type': 'application/x-www-form-urlencoded',
          };

          var formData = FormData.fromMap({
            'username': credentials.email,
            'password': credentials.password,
            'is_mobile': true,
            'device_token': fcmToken,
            'app_version': '$version ($buildNumber)',
            'device_platform': platformInfo,
            'device_name': deviceName,
          });

          sbDio.options.headers = headers;
          String url = "${api.baseUrl}${api.loginUrl}";
          Response response = await sbDio.post(url, data: formData);

          await storeCredentials(
            email: credentials.email,
            password: credentials.password,
            token: response.data['token'],
          );

          return true;
        } else {
          if (notify == true) {
            showAlert("Please login to continue");
          }
          return false;
        }
      } else {
        Map<String, String> headers = {
          'Content-Type': 'application/x-www-form-urlencoded',
        };

        var formData = FormData.fromMap({
          'username': username,
          'password': password,
          'is_mobile': true,
          'device_token': fcmToken,
          'app_version': '$version ($buildNumber)',
          'device_platform': platformInfo,
          'device_name': deviceName,
        });

        sbDio.options.headers = headers;
        String url = "${api.baseUrl}${api.loginUrl}";
        Response response = await sbDio.post(url, data: formData);

        await storeCredentials(
            email: username!,
            password: password!,
            token: response.data["token"]);
        return true;
      }
    } catch (error) {
      if (error is DioError) {
        if (notify == true) {
          showAlert("${error.response?.data['detail']}", color: Colors.red);
        }
        return false;
      } else {
        return false;
      }
    }
  }

  Future<bool> storeCredentials({
    required String email,
    required String password,
    required String token,
  }) async {
    // if (password == null) {
    //   return false;
    // }
    try {
      final UserCredentials credentials =
          UserCredentials(email: email, password: password, token: token);

      final authBox = await Hive.openBox<UserCredentials>(authBoxName);
      authBox.put(authBoxKey, credentials);
      await authBox.close();
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> login({
    String? username,
    String? password,
    bool aggresive = false,
    bool notify = true,
  }) async {
    if (aggresive) {
      return await authenticateAngler(
          username: username, password: password, notify: notify);
    } else {
      try {
        String url = "${api.baseUrl}${api.authEndpoint}";
        await sbDio.get(url);
        return true;
      } catch (error) {
        // print(error);

        // print(stacktrace);
        if (error is DioError) {
          if (error.response!.statusCode == 401) {
            if (aggresive) {
              return authenticateAngler(
                  username: username!, password: password!, notify: notify);
            } else {
              return false;
            }
          } else {
            if (notify == true) {
              showAlert("${error.response?.data}");
            }
            return false;
          }
        } else {
          return false;
        }
      }
    }
  }
}
