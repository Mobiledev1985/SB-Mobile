class PromotionModel {
  // String? id;
  String? name;
  // String? ticketType;
  int? discount;
  // List<String>? months;
  // String? appliedTo;
  // String? startTs;
  // String? createdAt;
  // List<String>? lakes;
  // String? fisheryId;
  String? discountType;
  // String? subscriberLevel;
  // List<String>? days;
  // bool? isActive;
  // String? expiryTs;
  String? fisheryName;
  int? fisheryPublicId;
  String? fisheryImage;

  PromotionModel({
    // this.id,
    this.name,
    // this.ticketType,
    this.discount,
    // this.months,
    // this.appliedTo,
    // this.startTs,
    // this.createdAt,
    // this.lakes,
    // this.fisheryId,
    this.discountType,
    // this.subscriberLevel,
    // this.days,
    // this.isActive,
    // this.expiryTs,
    this.fisheryName,
    this.fisheryImage,
    this.fisheryPublicId,
  });

  PromotionModel.fromJson(Map<String, dynamic> json) {
    // id = json['id'];
    name = json['name'];
    // ticketType = json['ticket_type'];
    discount = json['discount'];
    // months = json['months'].cast<String>();
    // appliedTo = json['applied_to'];
    // startTs = json['start_ts'];
    // createdAt = json['created_at'];
    // lakes = json['lakes'].cast<String>();
    // fisheryId = json['fishery_id'];
    discountType = json['discount_type'];
    // subscriberLevel = json['subscriber_level'];
    // days = json['days'].cast<String>();
    // isActive = json['is_active'];
    // expiryTs = json['expiry_ts'];
    fisheryName = json['fishery_name'];
    fisheryPublicId = json['fishery_public_id'];
    fisheryImage = json['fishery_image'];
  }
}
