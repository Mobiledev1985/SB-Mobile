import 'package:dio/dio.dart';
import 'package:sb_mobile/core/config/authenticator.dart';
import 'package:sb_mobile/core/config/server_config.dart';
import 'package:sb_mobile/core/utility/utils/parse_backend_response.dart';
import 'package:sb_mobile/core/widgets/alert.dart';
import 'package:sb_mobile/features/fishery_property_details/data/models/api_property_details_response.dart';
import 'package:sb_mobile/features/home_page/data/models/promotion_model.dart';
import 'package:sb_mobile/features/home_page/data/models/session_model.dart';
import 'package:sb_mobile/features/my_profile/data/models/booking_model.dart';
import 'package:sb_mobile/features/my_profile/data/models/catch_report_with_address.dart';
import 'package:sb_mobile/features/my_profile/data/models/credit_history_model.dart';
import 'package:sb_mobile/features/my_profile/data/models/giveaway_quiz_model.dart';
import 'package:sb_mobile/features/my_profile/data/models/my_membership_model.dart';
import 'package:sb_mobile/features/my_profile/data/models/perks_model.dart';
import 'package:sb_mobile/features/my_profile/data/models/session_detail_model.dart';
import 'package:sb_mobile/features/my_profile/data/models/winner_model.dart';

class SwimbookerApiProvider {
  final ApiServerConfig api = ApiServerConfig();

  Future<List<CatchReportWithAddress>?> getCatches() async {
    try {
      String url = "${api.baseUrl}${api.getCatchReportListEndpoint}";
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      auth.sbDio.options.headers = headers;
      Response response = await auth.sbDio.get(url);
      return (response.data['result'] as List)
          .map((e) => CatchReportWithAddress.fromJson(e))
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

  Future<bool> deleteCatche(String catchReportId) async {
    try {
      String url =
          "${api.baseUrl}${api.catchReportEndpoint}?catch_report_id=$catchReportId";
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      auth.sbDio.options.headers = headers;

      await auth.sbDio.delete(
        url,
      );

      return true;
      // return (response.data['result'] as List)
      //     .map((e) => CatchReportWithAddress.fromJson(e))
      //     .toList();
    } catch (error) {
      if (error is DioError) {
        ParseBackendResponse(response: error.response!);
      } else {
        return false;
      }
      return false;
    }
  }

  Future<BookingModel?> getBookings() async {
    try {
      String url = "${api.baseUrl}${api.userBookingsEndpoint}";
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      auth.sbDio.options.headers = headers;
      Response response = await auth.sbDio.get(url);
      return BookingModel.fromJson(response.data['result']);
    } catch (error) {
      if (error is DioError) {
        ParseBackendResponse(response: error.response!);
        return null;
      } else {
        return null;
      }
    }
  }

  Future<PerksModel?> getPerks() async {
    try {
      String url = "${api.proUrl}${api.perksEndpoint}";
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      auth.sbDio.options.headers = headers;
      Response response = await auth.sbDio.get(url);
      return PerksModel.fromJson(response.data);
    } catch (error) {
      if (error is DioError && error.response != null) {
        ParseBackendResponse(response: error.response!);
        return null;
      } else {
        return null;
      }
    }
  }

  Future<List<PromotionModel>?> getPromotion() async {
    try {
      String url = "${api.baseUrl}${api.promotionEndpoint}";
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      auth.sbDio.options.headers = headers;
      Response response = await auth.sbDio.get(url);
      return (response.data['result'] as List)
          .map((e) => PromotionModel.fromJson(e))
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

  Future<List<GiveawayQuizModel>?> getGiveawayQuizzes() async {
    try {
      String url = "${api.proUrl}${api.giveawayQuizEndpoint}";
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      auth.sbDio.options.headers = headers;
      Response response = await auth.sbDio.get(url);

      return (response.data as List)
          .map((e) => GiveawayQuizModel.fromJson(e))
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

  Future<List<WinnerModel>?> getListOfAllWinners(
      int pageKey, int pageNumber) async {
    try {
      String url =
          "${api.proUrl}${api.listAllWinnersEndpoint}?page=$pageKey&limit=$pageNumber&is_mobile=true";
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      auth.sbDio.options.headers = headers;
      Response response = await auth.sbDio.get(url);
      return (response.data as List)
          .map((e) => WinnerModel.fromJson(e))
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

  Future<List<SessionModel>?> getSessions() async {
    try {
      String url = "${api.proUrl}${api.getSessions}";
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      auth.sbDio.options.headers = headers;
      Response response = await auth.sbDio.get(url);
      return (response.data as List)
          .map((e) => SessionModel.fromJson(e))
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

  Future<bool?> submitAnswer(
      {required String quizId,
      required String answer,
      required Function(String?) ticketNumber}) async {
    try {
      String url = "${api.proUrl}${api.quizSubmitionEndpoint}";

      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      auth.sbDio.options.headers = headers;
      Map<String, String> payload = {"quiz_id": quizId, "answer": answer};
      final Response response = await auth.sbDio.post(url, data: payload);
      ticketNumber.call(response.data['quiz-submission']['ticket_number']);
      return true;
    } catch (error) {
      if (error is DioError && error.response != null) {
        ParseBackendResponse backendResponse =
            ParseBackendResponse(response: error.response!);
        if (backendResponse.isSuccessful) {
          return null;
        } else {
          return null;
        }
      } else {
        return null;
      }
    }
  }

  Future<List<CreditHistory>?> getCreditHistory() async {
    try {
      String url = "${api.baseUrl}${api.getCreditHistoryEndpoint}";
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      auth.sbDio.options.headers = headers;
      Response response = await auth.sbDio.get(url);
      return (response.data['result'] as List)
          .map((e) => CreditHistory.fromJson(e))
          .toList();
    } catch (error) {
      if (error is DioError && error.response != null) {
        ParseBackendResponse(response: error.response!);
      } else {
        return null;
      }
      return null;
    }
  }

  Future<MyMemberShipModel?> getMemberships() async {
    try {
      String url = "${api.baseUrl}${api.getMyMembershipsEndpoint}";
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      auth.sbDio.options.headers = headers;
      final Response response = await auth.sbDio.get(url);
      return MyMemberShipModel.fromJson(response.data['result']);
    } catch (error) {
      if (error is DioError && error.response != null) {
        ParseBackendResponse(response: error.response!);
      } else {
        return null;
      }
      return null;
    }
  }

  Future<String?> getFisheryImage({required String publicId}) async {
    try {
      String url = "${api.baseUrl}${api.fisheryDetailsEndpoint}";

      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      auth.sbDio.options.headers = headers;

      Map<String, dynamic> query = {'id': publicId};
      Response response = await auth.sbDio.get(url, queryParameters: query);

      PropertyDetailsResponse data =
          PropertyDetailsResponse.fromJson(response.data);
      return data.results?.images.primary;
    } catch (error) {
      // print(stacktrace);
      if (error is DioError) {
        ParseBackendResponse(response: error.response!);
      } else {
        return null;
      }
      return null;
    }
  }

  Future<SessionDetailModel?> getSessionDetail(
      {required String sessionId}) async {
    try {
      String url = "${api.proUrl}${api.sessionDetail}";

      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      auth.sbDio.options.headers = headers;

      Map<String, dynamic> query = {'session_id': sessionId};
      Response response = await auth.sbDio.get(url, queryParameters: query);
      return SessionDetailModel.fromJson(response.data);
    } catch (error) {
      // print(stacktrace);
      if (error is DioError && error.response != null) {
        ParseBackendResponse(response: error.response!);
      } else {
        return null;
      }
      return null;
    }
  }

  Future<void> updateNotes({required SessionNotes sessionNotes}) async {
    try {
      String url = "${api.proUrl}${api.updateSession}";

      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      auth.sbDio.options.headers = headers;
      Map<String, dynamic> payload = sessionNotes.toJson();
      await auth.sbDio.put(url, data: payload);
      showAlert('Successfully updated');
    } catch (error) {
      if (error is DioError && error.response != null) {
        ParseBackendResponse backendResponse =
            ParseBackendResponse(response: error.response!);
        if (backendResponse.isSuccessful) {
          return;
        } else {
          return;
        }
      } else {
        return;
      }
    }
  }
}
