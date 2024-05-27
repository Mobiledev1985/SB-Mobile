import 'package:equatable/equatable.dart';

class FeaturedFishery extends Equatable {
  final int publicId;
  final String fisheryName;
  final String image;
  final String city;
  final String postCode;
  final int rating;

  const FeaturedFishery(
      {required this.publicId,
      required this.fisheryName,
      required this.image,
      required this.city,
      required this.postCode,
      required this.rating});

  @override
  List<Object> get props => [publicId];

  factory FeaturedFishery.fromJson(Map<String, dynamic> json) {
    return FeaturedFishery(
      publicId: json["id"] ?? 0,
      fisheryName: json["name"] ?? '',
      image: json["image"] ?? '',
      city: json["city"] ?? '',
      postCode: json["postcode"] ?? '',
      rating: json["rating"] ?? 0,
    );
  }
}

class FeaturedFisheriesModel extends Equatable {
  final List<FeaturedFishery> fisheries;

  const FeaturedFisheriesModel({required this.fisheries});

  @override
  List<Object> get props => [fisheries];

  factory FeaturedFisheriesModel.fromJson(List<dynamic> json) {
    List<FeaturedFishery> fisheries = [];
    for (var value in json) {
      fisheries.add(FeaturedFishery.fromJson(value));
    }
    return FeaturedFisheriesModel(fisheries: fisheries);
  }
}
