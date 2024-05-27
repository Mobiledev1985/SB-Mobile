class FisheriesModel {
  String? id;
  bool? isFavourite;
  bool? isTackleShop;
  bool? isCafe;
  bool? isDayTicket;
  bool? isYoungAnglers;
  bool? isDisabledAccess;
  bool? isNightFishing;
  List<String>? images;
  String? city;
  List<String>? speciesNames;
  String? postcode;
  double? rating;
  String? description;
  bool? isBookable;
  bool? isComingSoon;
  int? publicId;
  List<String>? tags;
  String? sbFlythrough;
  String? name;
  int? totalReviews;
  String? sbDiaries;
  String? virtualExperience;
  Location? location;
  List<String>? facilities;
  List<String>? quickFacts;

  FisheriesModel(
      {this.id,
      this.isFavourite,
      this.isTackleShop,
      this.isCafe,
      this.isDayTicket,
      this.isYoungAnglers,
      this.isDisabledAccess,
      this.isNightFishing,
      this.images,
      this.city,
      this.speciesNames,
      this.postcode,
      this.rating,
      this.description,
      this.isBookable,
      this.isComingSoon,
      this.publicId,
      this.tags,
      this.sbFlythrough,
      this.name,
      this.totalReviews,
      this.sbDiaries,
      this.virtualExperience,
      this.location,
      this.facilities,
      this.quickFacts});

  FisheriesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isFavourite = json['is_favourite'];
    isTackleShop = json['is_tackle_shop'];
    isCafe = json['is_cafe'];
    isDayTicket = json['is_day_ticket'];
    isYoungAnglers = json['is_young_anglers'];
    isDisabledAccess = json['is_disabled_access'];
    isNightFishing = json['is_night_fishing'];
    images = json['images'].cast<String>();
    city = json['city'];
    speciesNames = json['species_names'].cast<String>();
    postcode = json['postcode'];
    rating = json['rating'];
    description = json['description'];
    isBookable = json['is_bookable'];
    isComingSoon = json['is_coming_soon'];
    publicId = json['public_id'];
    tags = json['tags'].cast<String>();
    sbFlythrough = json['sb_flythrough'];
    name = json['name'];
    totalReviews = json['total_reviews'];
    sbDiaries = json['sb_diaries'];
    virtualExperience = json['virtual_experience'];
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    facilities = json['facilities'].cast<String>();
    quickFacts = json['quick_facts'].cast<String>();
  }
}

class Location {
  num? lon;
  num? lat;

  Location({this.lon, this.lat});

  Location.fromJson(Map<String, dynamic> json) {
    lon = json['lon'];
    lat = json['lat'];
  }
}
