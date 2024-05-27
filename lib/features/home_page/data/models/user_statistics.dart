import 'package:sb_mobile/features/fishery_property_details/data/models/catch_report_model.dart';

class UserStatistics {
  num? sessionsBooked;
  num? totalSessionHours;
  num? fishCaught;
  num? averageSessionLength;
  num? averageSessionValue;
  num? fisheryReviews;
  num? speciesCaught;
  String? averageFishWeight;
  String? maximumFishWeight;
  CatchReport? catchReport;

  UserStatistics(
      {this.sessionsBooked,
      this.totalSessionHours,
      this.fishCaught,
      this.averageSessionLength,
      this.averageSessionValue,
      this.fisheryReviews,
      this.speciesCaught,
      this.averageFishWeight,
      this.maximumFishWeight,
      this.catchReport});

  UserStatistics.fromJson(Map<String, dynamic> json) {
    sessionsBooked = json['sessions_booked'];
    totalSessionHours = json['total_session_hours'];
    fishCaught = json['fish_caught'];
    averageSessionLength = json['average_session_length'];
    averageSessionValue = json['average_session_value'];
    fisheryReviews = json['fishery_reviews'];
    speciesCaught = json['species_caught'];
    averageFishWeight = json['average_fish_weight'];
    maximumFishWeight = json['maximum_fish_weight'];
    catchReport = json['maximum_weight_catch_report'] == null
        ? null
        : CatchReport.fromJson(json['maximum_weight_catch_report']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sessions_booked'] = sessionsBooked;
    data['total_session_hours'] = totalSessionHours;
    data['fish_caught'] = fishCaught;
    data['average_session_length'] = averageSessionLength;
    data['average_session_value'] = averageSessionValue;
    data['fishery_reviews'] = fisheryReviews;
    data['species_caught'] = speciesCaught;
    data['average_fish_weight'] = averageFishWeight;
    data['maximum_fish_weight'] = maximumFishWeight;
    return data;
  }
}
