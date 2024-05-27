class BookingModel {
  List<BookingItem>? history;
  List<BookingItem>? upcoming;

  BookingModel({this.history, this.upcoming});

  BookingModel.fromJson(Map<String, dynamic> json) {
    if (json['history'] != null) {
      history = <BookingItem>[];
      json['history'].forEach((v) {
        history!.add(BookingItem.fromJson(v));
      });
    }
    if (json['upcoming'] != null) {
      upcoming = <BookingItem>[];
      json['upcoming'].forEach((v) {
        upcoming!.add(BookingItem.fromJson(v));
      });
    }
  }
}

class BookingItem {
  String? name;
  String? fisheryPublicId;
  String? image;
  String? address;
  int? anglers;
  int? guests;
  int? rods;
  String? fisheryId;
  String? bookingId;
  num? paymentTotal;
  String? arrival;
  String? departure;
  bool? cancellable;
  String? bookingDate;
  String? status;
  List<GateCodes>? gateCodes;
  AnglerDetails? anglerDetails;
  String? lakeName;
  String? bookingPublicId;
  String? paymentStatus;
  String? selected;

  BookingItem(
      {this.name,
      this.fisheryPublicId,
      this.image,
      this.address,
      this.anglers,
      this.guests,
      this.rods,
      this.fisheryId,
      this.bookingId,
      this.paymentTotal,
      this.arrival,
      this.departure,
      this.cancellable,
      this.bookingDate,
      this.status,
      this.gateCodes,
      this.anglerDetails,
      this.lakeName,
      this.bookingPublicId,
      this.paymentStatus,
      this.selected});

  BookingItem.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    fisheryPublicId = json['fishery_public_id'].toString();
    image = json['image'];
    address = json['address'];
    anglers = json['anglers'];
    guests = json['guests'];
    rods = json['rods'];
    fisheryId = json['fishery_id'];
    bookingId = json['booking_id'];
    paymentTotal = json['payment_total'];
    arrival = json['arrival'];
    departure = json['departure'];
    cancellable = json['cancellable'];
    bookingDate = json['booking_date'];
    status = json['status'];
    if (json['gate_codes'] != null) {
      gateCodes = <GateCodes>[];
      json['gate_codes'].forEach((v) {
        gateCodes!.add(GateCodes.fromJson(v));
      });
    }
    anglerDetails = json['angler_details'] != null
        ? AnglerDetails.fromJson(json['angler_details'])
        : null;
    lakeName = json['lake_name'];
    bookingPublicId = json['booking_public_id'].toString();
    paymentStatus = json['payment_status'];
    selected = json['selected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['fishery_public_id'] = fisheryPublicId;
    data['image'] = image;
    data['address'] = address;
    data['anglers'] = anglers;
    data['guests'] = guests;
    data['rods'] = rods;
    data['fishery_id'] = fisheryId;
    data['booking_id'] = bookingId;
    data['payment_total'] = paymentTotal;
    data['arrival'] = arrival;
    data['departure'] = departure;
    data['cancellable'] = cancellable;
    data['booking_date'] = bookingDate;
    data['status'] = status;
    data['gate_codes'] = gateCodes;
    if (anglerDetails != null) {
      data['angler_details'] = anglerDetails!.toJson();
    }
    data['lake_name'] = lakeName;
    data['payment_status'] = paymentStatus;
    data['selected'] = selected;
    return data;
  }
}

class AnglerDetails {
  String? email;
  int? numRod;
  String? lastName;
  bool? concession;
  String? firstName;
  String? phoneNumber;
  String? profileImage;

  AnglerDetails(
      {this.email,
      this.numRod,
      this.lastName,
      this.concession,
      this.firstName,
      this.phoneNumber,
      this.profileImage});

  AnglerDetails.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    numRod = json['num_rod'];
    lastName = json['last_name'];
    concession = json['concession'];
    firstName = json['first_name'];
    phoneNumber = json['phone_number'];
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['num_rod'] = numRod;
    data['last_name'] = lastName;
    data['concession'] = concession;
    data['first_name'] = firstName;
    data['phone_number'] = phoneNumber;
    data['profile_image'] = profileImage;
    return data;
  }
}

class GateCodes {
  String? name;
  String? code;
  String? description;
  GateCodes({
    this.name,
    this.code,
    this.description,
  });

  GateCodes.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    code = json['code'];
    description = json['description'];
  }
}
