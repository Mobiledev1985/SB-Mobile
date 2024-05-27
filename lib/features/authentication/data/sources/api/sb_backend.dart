import 'dart:io';

import 'package:dio/dio.dart';
import 'package:sb_mobile/core/config/authenticator.dart';
import 'package:sb_mobile/core/config/server_config.dart';
import 'package:sb_mobile/core/utility/utils/parse_backend_response.dart';
import 'package:sb_mobile/core/widgets/alert.dart';
import 'package:sb_mobile/features/authentication/data/models/angler_profile_details_model.dart';
import 'package:sb_mobile/features/authentication/data/models/auth_response.dart';
import 'package:sb_mobile/features/authentication/data/models/profile_response.dart';
import 'package:sb_mobile/features/authentication/data/models/signup_model.dart';
import 'package:sb_mobile/features/home_page/data/models/user_statistics.dart';
import 'package:sb_mobile/features/my_profile/data/models/achivement_model.dart';
import 'package:sb_mobile/features/my_profile/data/models/identities_post_model.dart';
import 'package:sb_mobile/features/my_profile/data/models/wallet_model.dart';

class SwimbookerApiProvider {
  final ApiServerConfig api = ApiServerConfig();

  Future<UserAuthApiResponse> verifyAuthentication() async {
    try {
      String url = "${api.baseUrl}${api.authEndpoint}";
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      auth.sbDio.options.headers = headers;
      await auth.sbDio.get(url);
      return UserAuthApiResponse.fromResult(true);
    } catch (error) {
      if (error is DioError) {
        return UserAuthApiResponse.fromResult(false);
      } else {
        return UserAuthApiResponse.fromResult(false);
      }
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
        ParseBackendResponse(response: error.response!);
      } else {
        return null;
      }
      return AnglerProfileApiResponse.withError("$error");
    }
  }

  Future<String?> nextSessionStart() async {
    try {
      String url = "${api.proUrl}${api.nextSessionStartEndpoint}";

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

  Future<bool> registerUser({required SignupRecord signUp}) async {
    try {
      String url = "${api.baseUrl}${api.signUpEndpoint}";

      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      auth.sbDio.options.headers = headers;
      await auth.sbDio.post(url, data: signUp.toJson());

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

  Future<bool> getIdentities(
      {required IdentitiesPostModel identitiesPostModel}) async {
    try {
      // String url = "https://edge.api.flagsmith.com/api/v1/identities/";

      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      auth.sbDio.options.headers = headers;
      // final Response response =
      //     await auth.sbDio.post(url, data: identitiesPostModel.toJson());
      // print(response.data);
      return true;
    } catch (error) {
      // print(error.)
      // print(error);

      if (error is DioError) {
        // print(error.message);
        // ParseBackendResponse backendResponse =
        //     ParseBackendResponse(response: error.response!);
        // if (backendResponse.isSuccessful) {
        //   return true;
        // } else {
        //   return false;
        // }
        return false;
      } else {
        return false;
      }
    }
  }

  logout() async {
    try {
      String url1 = "${api.baseUrl}${api.signOut1Endpoint}";
      String url2 = "${api.baseUrl}${api.signOut2Endpoint}";

      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      auth.sbDio.options.headers = headers;
      await auth.sbDio.get(url1);
      await auth.sbDio.get(url2);
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

  Future<dynamic> resetPassword() async {
    try {
      String url = "${api.baseUrl}${api.passwordResetEndpoint}";
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      auth.sbDio.options.headers = headers;
      await auth.sbDio.get(url);
      showAlert("Check email for reset link");
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

  Future<bool> resetPasswordByEmail({required String email}) async {
    try {
      String url = "${api.baseUrl}${api.forgotPasswordEndpoint}";
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      Map<String, String> payload = {'email': email};
      auth.sbDio.options.headers = headers;
      await auth.sbDio.post(url, data: payload);
      showAlert("Check email for reset link");
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

  Future<bool> updateUserDetails({required AnglerProfile profile}) async {
    try {
      String url = "${api.baseUrl}${api.anglerProfileEndpoint}";

      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      auth.sbDio.options.headers = headers;
      // print(profile.toJson());
      Response response = await auth.sbDio.put(url, data: profile.toJson());

      var msg = response.data['result'];
      showAlert(msg);
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

  Future<bool> uploadBackgroundImage(File file) async {
    try {
      String url = "${api.baseUrl}${api.uploadBackgroundEndpoint}";
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path, filename: fileName),
      });
      await auth.sbDio.post(url, data: formData);
      return true;
    } catch (error) {
      if (error is DioError) {
        showAlert('Failed to upload, Request Too Long');
        // ParseBackendResponse(response: error.response!);
        return false;
      } else {
        showAlert("Server Error, please try again later.");
        return false;
      }
    }
  }

  Future<bool> uploadProfilePicture({required File croppedFile}) async {
    try {
      String url = "${api.baseUrl}${api.uploadPicEndpoint}";
      String fileName = croppedFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file":
            await MultipartFile.fromFile(croppedFile.path, filename: fileName),
      });
      await auth.sbDio.post(url, data: formData);
      return true;
    } catch (error) {
      if (error is DioError) {
        showAlert('Failed to upload, Request Too Long');
        ParseBackendResponse(response: error.response!);
        return false;
      } else {
        showAlert("Server Error, please try again later.");
        return false;
      }
    }
  }

  Future<String?> registerNewSubscriber({required String email}) async {
    try {
      String url = "${api.proUrl}${api.registerNewSubscriberEndpoint}";
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      Map<String, String> payload = {'customer_email': email};
      auth.sbDio.options.headers = headers;
      final Response response = await auth.sbDio.post(url, data: payload);
      return response.data['user_id'];
    } catch (error) {
      if (error is DioError && error.response != null) {
        ParseBackendResponse(response: error.response!);
        showAlert(error.response?.data['detail']);
        throw Exception(error.response?.data['detail']);
      } else {
        throw Exception('Server Error, please try again later.');
      }
    }
  }

  Future<(bool, String?)> verifyPurchase(
    String source,
    subscriptionId,
    String verificationToken,
    String userEmail,
  ) async {
    try {
      String url = "${api.proUrl}${api.verifySubscriptionEndPoint}";
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      Map<String, String> payload = {
        'source': source,
        'subscription_id': subscriptionId,
        'verification_token': verificationToken,
        'user_email': userEmail,
      };
      auth.sbDio.options.headers = headers;
      final Response response = await auth.sbDio.post(url, data: payload);
      return (
        response.data['verified'] as bool,
        response.data['message'] as String?
      );
    } catch (error) {
      if (error is DioError && error.response != null) {
        ParseBackendResponse(response: error.response!);
        throw Exception(error.response?.data);
      } else {
        throw Exception('Server Error, please try again later.');
      }
    }
  }
}
