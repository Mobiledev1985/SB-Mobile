// ignore_for_file: file_names

class IdentitiesModel {
  String? identifier;
  List<Flags>? flags;
  List<Traits>? traits;

  IdentitiesModel({this.identifier, this.flags, this.traits});

  IdentitiesModel.fromJson(Map<String, dynamic> json) {
    identifier = json['identifier'];
    if (json['flags'] != null) {
      flags = <Flags>[];
      json['flags'].forEach((v) {
        flags!.add(Flags.fromJson(v));
      });
    }
    if (json['traits'] != null) {
      traits = <Traits>[];
      json['traits'].forEach((v) {
        traits!.add(Traits.fromJson(v));
      });
    }
  }
}

class Flags {
  Feature? feature;
  bool? enabled;

  Flags({this.feature, this.enabled});

  Flags.fromJson(Map<String, dynamic> json) {
    feature =
        json['feature'] != null ? Feature.fromJson(json['feature']) : null;
    enabled = json['enabled'];
  }
}

class Feature {
  String? name;
  int? id;
  String? type;

  Feature({this.name, this.id, this.type});

  Feature.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    data['type'] = type;
    return data;
  }
}

class Traits {
  String? traitKey;
  int? traitValue;

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
