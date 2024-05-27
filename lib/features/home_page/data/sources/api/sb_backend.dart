import 'dart:async';

import 'package:dio/dio.dart';
import 'package:sb_mobile/core/config/authenticator.dart';
import 'package:sb_mobile/core/config/server_config.dart';
import 'package:sb_mobile/core/utility/utils/parse_backend_response.dart';
import 'package:sb_mobile/core/widgets/alert.dart';
import 'package:sb_mobile/features/authentication/data/models/profile_response.dart';
import 'package:sb_mobile/features/fishery_property_details/data/models/catch_report_model.dart';
import 'package:sb_mobile/features/home_page/data/models/articles_api_response.dart';
import 'package:sb_mobile/features/home_page/data/models/featured_fishery_api_response.dart';
import 'package:sb_mobile/features/home_page/data/models/fisheries_model.dart';
import 'package:sb_mobile/features/home_page/data/models/notification_model.dart';
import 'package:sb_mobile/features/home_page/data/models/user_statistics.dart';
import 'package:sb_mobile/features/my_profile/data/models/achivement_model.dart';
import 'package:sb_mobile/features/my_profile/data/models/wallet_model.dart';
import 'package:sb_mobile/features/search/data/models/api_search_response.dart';
import 'package:sb_mobile/features/user_bookings/data/models/api_response.dart';

class SwimbookerApiProvider {
  final ApiServerConfig api = ApiServerConfig();

  Future<SocialArticlesResponse> fetchAllStories() async {
    try {
      String url = "${api.baseUrl}${api.socialEndpoint}";
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      auth.sbDio.options.headers = headers;
      Response response = await auth.sbDio.get(url);
      SocialArticlesResponse data =
          SocialArticlesResponse.fromJson(response.data);
      return data;
    } catch (error) {
      if (error is DioError) {
        // ParseBackendResponse(response: error.response!);
      }
      return SocialArticlesResponse.withError("API Failed");
    }
  }

  Future<List<CatchReport>?> getCatchReports(
      int pageKey, int pageNumber) async {
    try {
      String url =
          "${api.baseUrl}${api.liveReports}?page=$pageKey&limit=$pageNumber";
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      auth.sbDio.options.headers = headers;
      Response response = await auth.sbDio.get(url);
      return (response.data['result']['catch_reports'] as List)
          .map((e) => CatchReport.fromJson(e))
          .toList();
    } catch (error) {
      if (error is DioError && error.response != null) {
        ParseBackendResponse(response: error.response!);
        return null;
      } else {
        return null;
      }
    }
  }

  Future<UserStatistics?> getUserStatistics() async {
    try {
      String url = "${api.baseUrl}${api.getUserStatisticsEndpoint}";
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      auth.sbDio.options.headers = headers;
      Response response = await auth.sbDio.get(url);
      return UserStatistics.fromJson(response.data['result']);
    } catch (error) {
      if (error is DioError) {
        ParseBackendResponse(response: error.response!);
      } else {
        return null;
      }
      return null;
    }
  }

  Future<String?> getSubscriptionLevel() async {
    try {
      String url = "${api.proUrl}${api.subscriptionLevelEndpoint}";

      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      auth.sbDio.options.headers = headers;
      Response response = await auth.sbDio.get(url);
      return response.data;
    } catch (error) {
      if (error is DioError) {
        return null;
        // ParseBackendResponse(response: error.response);
      } else {
        return null;
      }
    }
  }

  Future<FeaturedFisheryApiResponse> getFeaturedFisheries() async {
    try {
      String url = "${api.baseUrl}${api.featuredFisheryEndpoint}";
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      auth.sbDio.options.headers = headers;
      Response response = await auth.sbDio.get(url);
      FeaturedFisheryApiResponse data =
          FeaturedFisheryApiResponse.fromJson(response.data);
      return data;
    } catch (error) {
      // print(error);
      if (error is DioError) {
        // print(error);
        // ParseBackendResponse(response: error.response!);
      }
      return FeaturedFisheryApiResponse.withError("API Failed");
    }
  }

  Future<(List<FisheriesModel>?, List<CatchReport>?)> getHomeData() async {
    try {
      String url = "${api.baseUrl}${api.homeEndpoint}";
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      auth.sbDio.options.headers = headers;
      Response response = await auth.sbDio.get(url);
      List<FisheriesModel> bookableVenues =
          (response.data['result']['fisheries'] as List)
              .map((e) => FisheriesModel.fromJson(e))
              .toList();
      List<CatchReport> catchReports =
          (response.data['result']['catch_reports'] as List)
              .map((e) => CatchReport.fromJson(e))
              .toList();
      return (bookableVenues, catchReports);
    } catch (error) {
      if (error is DioError) {
        // ParseBackendResponse(response: error.response!);
      }
      // return FeaturedFisheryApiResponse.withError("API Failed");
    }
    return (null, null);
  }

  Future<SearchResponse> getLuckyDipFishery() async {
    try {
      String url = "${api.baseUrl}${api.luckyEndpoint}";
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      auth.sbDio.options.headers = headers;
      Response response = await auth.sbDio.get(url);
      return SearchResponse.fromJson(response.data);
    } catch (error) {
      if (error is DioError) {
        ParseBackendResponse(response: error.response!);
      }
      return SearchResponse.withError("API Failed");
    }
  }

  Future<AnglerProfileApiResponse?> fetchAnglerProfile() async {
    try {
      String url = "${api.baseUrl}${api.anglerProfileEndpoint}";

      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      auth.sbDio.options.headers = headers;
      Response response = await auth.sbDio.get(url);
      return AnglerProfileApiResponse.fromJson(response.data);
    } catch (error) {
      if (error is DioError) {
        // ParseBackendResponse(response: error.response!);
      } else {
        return null;
      }
      return AnglerProfileApiResponse.withError("$error");
    }
  }

  Future<bool> updateUserFavourite({required String fisheryId}) async {
    try {
      String url = "${api.baseUrl}${api.favEndpoint}";

      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      auth.sbDio.options.headers = headers;
      Map<String, String> payload = {"fishery_id": fisheryId};
      await auth.sbDio.post(url, data: payload);
      return true;
    } catch (error) {
      if (error is DioError) {
        ParseBackendResponse backendResponse =
            ParseBackendResponse(response: error.response!);
        if (backendResponse.isSuccessful) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    }
  }

  Future<SavedFisheriesApiResponse?> getSavedFisheries() async {
    // !! Make the function dynamic
    try {
      // var response = await auth.login();
      // if (!response) {
      //   return SavedFisheriesApiResponse.withError("API Failed");
      // } else {
      String url = "${api.baseUrl}${api.favEndpoint}";
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      auth.sbDio.options.headers = headers;
      Response response = await auth.sbDio.get(url);
      return SavedFisheriesApiResponse.fromJson(response.data);
      // }
    } catch (error) {
      if (error is DioError) {
        ParseBackendResponse(response: error.response!);
      } else {
        return SavedFisheriesApiResponse.withError("$error");
      }
      return SavedFisheriesApiResponse.withError("$error");
    }
  }

  Future<bool> logout() async {
    try {
      String url1 = "${api.baseUrl}${api.signOut1Endpoint}";
      String url2 = "${api.baseUrl}${api.signOut2Endpoint}";

      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      auth.sbDio.options.headers = headers;
      await auth.sbDio.get(url1);
      await auth.sbDio.get(url2);
      return true;
    } catch (error) {
      if (error is DioError) {
        ParseBackendResponse(response: error.response!);
        return false;
      } else {
        showAlert("Server Error, please try again later.");
        return false;
      }
    }
  }

  Future<AchievementModel?> getAchivements() async {
    try {
      String url = "${api.baseUrl}${api.achievements}";
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      auth.sbDio.options.headers = headers;
      Response response = await auth.sbDio.get(url);
      return AchievementModel.fromJson(response.data['result']);
    } catch (error) {
      if (error is DioError && error.response != null) {
        ParseBackendResponse(response: error.response!);
        return null;
      } else {
        return null;
      }
    }
  }

  Future<WalletModel?> getWallet() async {
    try {
      String url = "${api.baseUrl}${api.walletEndpoint}";

      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      auth.sbDio.options.headers = headers;
      Response response = await auth.sbDio.get(url);

      return WalletModel.fromJson(response.data['result']);
    } catch (error) {
      if (error is DioError && error.response != null) {
        ParseBackendResponse(response: error.response!);
        return null;
      } else {
        return null;
      }
    }
  }

  Future<List<NotificationModel>?> getNotifications() async {
    try {
      String url = "${api.baseUrl}${api.getNotificationsEndpoint}";
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      auth.sbDio.options.headers = headers;
      Response response = await auth.sbDio.get(url);
      return (response.data['result'] as List)
          .map((e) => NotificationModel.fromJson(e))
          .toList();
    } catch (error) {
      if (error is DioError) {
        ParseBackendResponse(response: error.response!);
      } else {
        return null;
      }
      return null;
    }
  }

  Future<bool> readNotifications(List<String> notifications) async {
    try {
      String url = "${api.baseUrl}${api.getNotificationsEndpoint}";
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      auth.sbDio.options.headers = headers;
      await auth.sbDio.put(
        url,
        data: {
          'notification_ids': notifications,
        },
      );
      // return (response.data['result'] as List)
      //     .map((e) => NotificationModel.fromJson(e))
      //     .toList();
      return true;
    } catch (error) {
      if (error is DioError) {
        ParseBackendResponse(response: error.response!);
      } else {
        return false;
      }
      return false;
    }
  }
}
