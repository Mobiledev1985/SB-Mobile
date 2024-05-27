import 'package:sb_mobile/features/home_page/data/models/featured_fisheries_model.dart';

class FeaturedFisheryApiResponse {
  final FeaturedFisheriesModel? results;
  final String? error;

  FeaturedFisheryApiResponse({required this.results, required this.error});

  factory FeaturedFisheryApiResponse.fromJson(Map<String, dynamic> json) {
    return FeaturedFisheryApiResponse(
        results: FeaturedFisheriesModel.fromJson(json['result'] ?? ''),
        error: null);
  }

  factory FeaturedFisheryApiResponse.withError(String errorValue) {
    return FeaturedFisheryApiResponse(results: null, error: errorValue);
  }
}
