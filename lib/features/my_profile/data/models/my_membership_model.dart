class MyMemberShipModel {
  List<MembershipAndSeasonTicketModel>? memberships;
  List<MembershipAndSeasonTicketModel>? seasonTickets;

  MyMemberShipModel({this.memberships, this.seasonTickets});

  MyMemberShipModel.fromJson(Map<String, dynamic> json) {
    if (json['memberships'] != null) {
      memberships = <MembershipAndSeasonTicketModel>[];
      json['memberships'].forEach((v) {
        memberships!.add(MembershipAndSeasonTicketModel.fromJson(v));
      });
    }
    if (json['season_tickets'] != null) {
      seasonTickets = <MembershipAndSeasonTicketModel>[];
      json['season_tickets'].forEach((v) {
        seasonTickets!.add(MembershipAndSeasonTicketModel.fromJson(v));
      });
    }
  }
}

class MembershipAndSeasonTicketModel {
  String? fishery;
  int? fisheryId;
  List<String>? lakes;
  String? fisheryImage;
  String? fisheryEmail;
  String? fisheryPhone;
  String? renewalDate;

  MembershipAndSeasonTicketModel(
      {this.fishery,
      this.fisheryId,
      this.lakes,
      this.fisheryImage,
      this.fisheryEmail,
      this.fisheryPhone,
      this.renewalDate});

  MembershipAndSeasonTicketModel.fromJson(Map<String, dynamic> json) {
    fishery = json['fishery'];
    fisheryId = json['fishery_id'];
    lakes = json['lakes']?.cast<String>();
    fisheryImage = json['fishery_image'];
    fisheryEmail = json['fishery_email'];
    fisheryPhone = json['fishery_phone'];
    renewalDate = json['renewal_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fishery'] = fishery;
    data['fishery_id'] = fisheryId;
    data['lakes'] = lakes;
    data['fishery_image'] = fisheryImage;
    data['fishery_email'] = fisheryEmail;
    data['fishery_phone'] = fisheryPhone;
    data['renewal_date'] = renewalDate;
    return data;
  }
}
