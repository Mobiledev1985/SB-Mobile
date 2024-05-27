class PerksModel {
  List<Perk>? fisheryPerks;
  List<Perk>? supplierPerks;

  PerksModel({this.fisheryPerks, this.supplierPerks});

  PerksModel.fromJson(Map<String, dynamic> json) {
    if (json['fishery_perks'] != null) {
      fisheryPerks = <Perk>[];
      json['fishery_perks'].forEach((v) {
        fisheryPerks!.add(Perk.fromJson(v));
      });
    }
    if (json['supplier_perks'] != null) {
      supplierPerks = <Perk>[];
      json['supplier_perks'].forEach((v) {
        supplierPerks!.add(Perk.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (fisheryPerks != null) {
      data['fishery_perks'] = fisheryPerks!.map((v) => v.toJson()).toList();
    }
    if (supplierPerks != null) {
      data['supplier_perks'] = supplierPerks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Perk {
  int? offerType;
  String? discountLine;
  String? headerImage;
  bool? isDiscountCode;
  String? linkType;
  String? linkValue;
  bool? isActive;
  String? id;
  String? title;
  String? offerDescription;
  String? discountCode;
  String? linkText;
  String? startTs;

  Perk(
      {this.offerType,
      this.discountLine,
      this.headerImage,
      this.isDiscountCode,
      this.linkType,
      this.isActive,
      this.id,
      this.title,
      this.offerDescription,
      this.discountCode,
      this.linkText,
      this.startTs,
      this.linkValue});

  Perk.fromJson(Map<String, dynamic> json) {
    offerType = json['offer_type'];
    discountLine = json['discount_line'];
    headerImage = json['header_image'];
    isDiscountCode = json['is_discount_code'];
    linkType = json['link_type'];
    linkValue = json['link_value'];
    isActive = json['is_active'];
    id = json['id'];
    title = json['title'];
    offerDescription = json['offer_description'];
    discountCode = json['discount_code'];
    linkText = json['link_text'];
    startTs = json['start_ts'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['offer_type'] = offerType;
    data['discount_line'] = discountLine;
    data['header_image'] = headerImage;
    data['is_discount_code'] = isDiscountCode;
    data['link_type'] = linkType;
    data['is_active'] = isActive;
    data['id'] = id;
    data['title'] = title;
    data['offer_description'] = offerDescription;
    data['discount_code'] = discountCode;
    data['link_text'] = linkText;
    data['start_ts'] = startTs;
    return data;
  }
}
