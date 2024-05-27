
import 'angler_profile_details_model.dart';

class AnglerProfileApiResponse {
  final AnglerProfile? profile;
  final String error;

  AnglerProfileApiResponse({required this.profile, required this.error});

  AnglerProfileApiResponse.fromJson(Map<String, dynamic> json)
      : profile = AnglerProfile.fromJson(json['result']),
        error = "";

  AnglerProfileApiResponse.withError(String errorValue)
      : profile = null,
        error = errorValue;
}
