import 'package:sb_mobile/features/fishery_property_details/data/models/catch_report_model.dart';
import 'package:sb_mobile/features/home_page/data/models/articles_model.dart';
import 'package:sb_mobile/features/home_page/data/models/fisheries_model.dart';

class HomeModel {
  List<Exclusive>? exclusive;
  List<FisheriesModel>? bookableVenues;
  List<CatchReport>? liveCatchReport;
  List<Article>? articles;

  HomeModel({
    this.exclusive,
    this.bookableVenues,
    this.liveCatchReport,
    this.articles,
  });

  HomeModel copyWith({
    List<Exclusive>? exclusive,
    List<FisheriesModel>? bookableVenues,
    List<CatchReport>? liveCatchReport,
    List<Article>? articles,
  }) {
    return HomeModel(
      exclusive: exclusive ?? this.exclusive,
      bookableVenues: bookableVenues ?? this.bookableVenues,
      liveCatchReport: liveCatchReport ?? this.liveCatchReport,
      articles: articles ?? this.articles,
    );
  }
}

class Exclusive {
  String backgroundImage;
  String icon;
  String name;
  String? apiEndpoint;

  Exclusive(
      {required this.backgroundImage,
      required this.icon,
      required this.name,
      this.apiEndpoint});
}
