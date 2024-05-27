import 'package:sb_mobile/features/fishery_property_details/data/models/catch_report_model.dart';

class CatchReportWithAddress {
  Address? address;
  String? name;
  List<CatchReport>? reports;

  CatchReportWithAddress({this.address, this.name, this.reports});

  CatchReportWithAddress.fromJson(Map<String, dynamic> json) {
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
    name = json['name'];
    if (json['reports'] != null) {
      reports = <CatchReport>[];
      json['reports'].forEach((v) {
        reports!.add(CatchReport.fromJson(v));
      });
    }
  }
}

class Address {
  String? city;
  String? line1;
  String? line2;
  Location? location;
  String? oneLine;
  String? postcode;

  Address(
      {this.city,
      this.line1,
      this.line2,
      this.location,
      this.oneLine,
      this.postcode});

  Address.fromJson(Map<String, dynamic> json) {
    city = json['city'];
    line1 = json['line1'];
    line2 = json['line2'];
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    oneLine = json['one_line'];
    postcode = json['postcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['city'] = city;
    data['line1'] = line1;
    data['line2'] = line2;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['one_line'] = oneLine;
    data['postcode'] = postcode;
    return data;
  }
}

class Location {
  double? lat;
  double? lng;

  Location({this.lat, this.lng});

  Location.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}
