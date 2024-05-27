

class UserAuthApiResponse {
  final bool isLoggedIn;
  final String error;

  UserAuthApiResponse({
    required this.isLoggedIn,
    required this.error
  });

  UserAuthApiResponse.fromResult(bool status)
      : isLoggedIn = status,
        error = "";

  UserAuthApiResponse.withError(String errorValue)
      : isLoggedIn = false,
        error = errorValue;

}
