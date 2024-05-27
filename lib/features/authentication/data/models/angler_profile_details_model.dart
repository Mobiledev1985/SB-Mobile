import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class PersonalBestRecord extends Equatable {
  String? speciesName;
  String? weight;

  PersonalBestRecord({this.speciesName, this.weight});

  @override
  List<Object?> get props => [speciesName, weight];

  factory PersonalBestRecord.fromJson(Map<String, dynamic> json) {
    return PersonalBestRecord(
      speciesName: json['species'] ?? '',
      weight: '${json['weight']}',
    );
  }

  Map<String, dynamic> toJson() {
    return {"species": speciesName, "weight": weight};
  }
}

// ignore: must_be_immutable
class AnglerProfile extends Equatable {
  String firstName;
  String lastName;
  String? profileImage;
  String? backgroundImage;
  String email;
  int? publicId;
  String? contact;
  String? addressLine1;
  String? addressLine2;
  String? city;
  String? postcode;
  String yearsAngling;
  bool? verified;
  bool? isPublic;
  List<PersonalBestRecord> personalBest;
  double walletAmount;

  AnglerProfile({
    required this.firstName,
    required this.lastName,
    this.profileImage,
    this.backgroundImage,
    required this.email,
    required this.publicId,
    this.contact,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.postcode,
    required this.verified,
    required this.yearsAngling,
    required this.isPublic,
    required this.personalBest,
    this.walletAmount = 0.0,
  });

  AnglerProfile copyWith({
    String? firstName,
    String? lastName,
    String? profileImage,
    String? backgroundImage,
    String? email,
    int? publicId,
    String? contact,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? postcode,
    String? yearsAngling,
    bool? verified,
    bool? isPublic,
    List<PersonalBestRecord>? personalBest,
  }) {
    return AnglerProfile(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      profileImage: profileImage ?? this.profileImage,
      backgroundImage: backgroundImage ?? this.backgroundImage,
      email: email ?? this.email,
      publicId: publicId ?? this.publicId,
      contact: contact ?? this.contact,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      city: city ?? this.city,
      postcode: postcode ?? this.postcode,
      yearsAngling: yearsAngling ?? this.yearsAngling,
      verified: verified ?? this.verified,
      isPublic: isPublic ?? this.isPublic,
      personalBest: personalBest ?? this.personalBest,
    );
  }

  @override
  List<Object> get props => [firstName, lastName];

  factory AnglerProfile.fromJson(Map<String, dynamic> json) {
    var personalBest = json['personal_best'];
    // ignore: no_leading_underscores_for_local_identifiers
    List<PersonalBestRecord> _personalBest = [];

    if (personalBest != null) {
      personalBest.forEach((element) {
        _personalBest.add(PersonalBestRecord.fromJson(element));
      });
    }

    if (_personalBest.isEmpty) {
      _personalBest = [
        PersonalBestRecord(speciesName: '', weight: ''),
        PersonalBestRecord(speciesName: '', weight: '')
      ];
    } else if (_personalBest.length == 1) {
      _personalBest.add(PersonalBestRecord(speciesName: null, weight: null));
    }

    return AnglerProfile(
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      profileImage: json['user_image'],
      backgroundImage: json['background_image'],
      email: json['email'] ?? '',
      publicId: json['public_id'],
      contact: json['contact'] ?? '',
      addressLine1: json['addressLine1'] ?? '',
      addressLine2: json['addressLine2'] ?? '',
      city: json['city'] ?? '',
      postcode: json['postcode'] ?? '',
      verified: json['verified'],
      yearsAngling: json['years_angling'] ?? '',
      isPublic: json['is_public'] ?? false,
      personalBest: _personalBest,
    );
  }

  Map<String, dynamic> toJson() {
    // ignore: no_leading_underscores_for_local_identifiers
    List<Map<String, dynamic>> _personalBest = [];

    for (var element in personalBest) {
      _personalBest.add(element.toJson());
    }

    return {
      "password": "",
      "postcode": postcode,
      "addressLine1": addressLine1,
      "addressLine2": addressLine2,
      "city": city,
      "first_name": firstName,
      "last_name": lastName,
      "years_angling": yearsAngling,
      "personal_best": _personalBest,
      "isPublic": isPublic,
    };
  }
}
