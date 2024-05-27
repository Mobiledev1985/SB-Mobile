class IdentitiesPostModel {
  String? identifier;
  List<Traits>? traits;

  IdentitiesPostModel({this.identifier, this.traits});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['identifier'] = identifier;
    if (traits != null) {
      data['traits'] = traits!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Traits {
  String? traitKey;
  dynamic traitValue;

  Traits({this.traitKey, this.traitValue});

  Traits.fromJson(Map<String, dynamic> json) {
    traitKey = json['trait_key'];
    traitValue = json['trait_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['trait_key'] = traitKey;
    data['trait_value'] = traitValue;
    return data;
  }
}
