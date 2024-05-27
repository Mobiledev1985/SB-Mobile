import 'package:sb_mobile/features/home_page/data/models/articles_model.dart';

class SocialArticlesResponse {
  final SocialsArticles? results;
  final String error;

  SocialArticlesResponse({required this.results, required this.error});

  SocialArticlesResponse.fromJson(Map<String, dynamic> json)
      : results = SocialsArticles.fromJson(json),
        error = "";

  SocialArticlesResponse.withError(String errorValue)
      : results = null,
        error = errorValue;
}
