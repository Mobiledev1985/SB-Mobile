import 'package:dio/dio.dart';
import 'package:sb_mobile/core/widgets/alert.dart';


class ParseBackendResponse{
  final Response response ;
  bool isSuccessful = false;
  bool isLoginRequired = false;
  bool isRefreshRequired = false;
  bool isServerError = false;
  bool isBadRequest = false;
  bool isInvalidRequest = false;

  ParseBackendResponse({required this.response}){
   if(response.statusCode == 200){
     isSuccessful = true ;
   }

   else if(response.statusCode == 500){
      isServerError = true ;
      showAlert("Server Response failed. Please try again later");
   }

   else if(response.statusCode == 401){
      isLoginRequired = true ;
      showAlert("You cannot perform this action without Logging in. Please Login and try again!");
   }

   else if(response.statusCode == 400){
     isInvalidRequest = true ;
     showAlert(response.data['detail']);
   }

   else if(response.statusCode == 422){
     if(response.data['detail'] == "Signature has expired"){
        isRefreshRequired = true ;
        showAlert("Login session has been expired. Please Login to continue!");
     } else{
       isBadRequest = true ;
       showAlert("OOPS! Server didn't like the request. If this persists please contact support team");
     }
   }

   else if(response.statusCode == 423){
     showAlert("Sorry ! this booking slot has been booked by another user, Try different booking!");
   }

  }

  Map<String, dynamic> toJson(){
    return {
      "isSuccessful": isSuccessful,
      "isLoginRequired": isLoginRequired,
      "isRefreshRequired": isRefreshRequired,
      "isServerError": isServerError,
      "isBadRequest": isBadRequest
    };
  }

}