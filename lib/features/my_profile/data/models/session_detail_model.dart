import 'package:sb_mobile/features/fishery_property_details/data/models/catch_report_model.dart';

class SessionDetailModel {
  String? userId;
  bool? isCancelled;
  String? fisheryName;
  int? captures;
  String? endTs;
  String? id;
  String? fisheryId;
  String? startTs;
  String? lakeName;
  List<SessionNotes>? sessionNotes;
  CatchReportSummary? catchReportSummary;
  List<CatchReport>? catchReports;

  SessionDetailModel({
    this.userId,
    this.isCancelled,
    this.fisheryName,
    this.captures,
    this.endTs,
    this.id,
    this.fisheryId,
    this.startTs,
    this.sessionNotes,
    this.catchReportSummary,
    this.catchReports,
    this.lakeName,
  });

  SessionDetailModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    isCancelled = json['is_cancelled'];
    fisheryName = json['fishery_name'];
    captures = json['captures'];
    endTs = json['end_ts'];
    id = json['id'];
    fisheryId = json['fishery_id'];
    startTs = json['start_ts'];
    lakeName = json['lake_name'];
    if (json['session_notes'] != null) {
      sessionNotes = <SessionNotes>[];
      json['session_notes'].forEach((v) {
        sessionNotes!.add(SessionNotes.fromJson(v));
      });
    }
    catchReportSummary = json['catch_report_summary'] != null
        ? CatchReportSummary.fromJson(json['catch_report_summary'])
        : null;
    if (json['catch_reports'] != null) {
      catchReports = <CatchReport>[];
      json['catch_reports'].forEach((v) {
        catchReports!.add(CatchReport.fromJson(v));
      });
    }
  }
}

class SessionNotes {
  String? title;
  String? userId;
  String? lake;
  String? imageUpload;
  String? uploadedAt;
  String? sessionId;
  String? id;
  String? detail;
  String? swim;
  String? noteDate;

  SessionNotes({
    this.title,
    this.userId,
    this.lake,
    this.imageUpload,
    this.uploadedAt,
    this.sessionId,
    this.id,
    this.detail,
    this.swim,
    this.noteDate,
  });

  SessionNotes.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    userId = json['user_id'];
    lake = json['lake'];
    imageUpload = json['image_upload'];
    uploadedAt = json['uploaded_at'];
    sessionId = json['session_id'];
    id = json['id'];
    detail = json['detail'];
    swim = json['swim'];
    noteDate = json['note_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['user_id'] = userId;
    data['lake'] = lake;
    data['image_upload'] = imageUpload;
    data['uploaded_at'] = uploadedAt;
    data['session_id'] = sessionId;
    data['note_id'] = id;
    data['detail'] = detail;
    data['swim'] = swim;
    data['note_date'] = noteDate;
    return data;
  }
}

class CatchReportSummary {
  String? maximumFishWeight;
  String? averageFishWeight;
  int? fishCaught;
  int? speciesCaught;
  List<String>? images;

  CatchReportSummary(
      {this.maximumFishWeight,
      this.averageFishWeight,
      this.fishCaught,
      this.speciesCaught,
      this.images});

  CatchReportSummary.fromJson(Map<String, dynamic> json) {
    maximumFishWeight = json['maximum_fish_weight'];
    averageFishWeight = json['average_fish_weight'];
    fishCaught = json['fish_caught'];
    speciesCaught = json['species_caught'];
    images = json['images'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['maximum_fish_weight'] = maximumFishWeight;
    data['average_fish_weight'] = averageFishWeight;
    data['fish_caught'] = fishCaught;
    data['species_caught'] = speciesCaught;
    data['images'] = images;
    return data;
  }
}

// class CatchReports {
//   String? fisheryId;
//   int? fishWeightOz;
//   bool? isDeleted;
//   String? name;
//   bool? personalBest;
//   String? notes;
//   String? fishCaughtDate;
//   String? rig;
//   bool? isAnglerNameEntered;
//   String? fishery;
//   String? bait;
//   String? id;
//   String? lake;
//   String? imageUpload;
//   String? userId;
//   String? swim;
//   String? uploadDate;
//   int? publicId;
//   String? fishSpecies;
//   bool? isApproved;
//   int? fishWeightLb;
//   String? userImage;

//   CatchReports(
//       {this.fisheryId,
//       this.fishWeightOz,
//       this.isDeleted,
//       this.name,
//       this.personalBest,
//       this.notes,
//       this.fishCaughtDate,
//       this.rig,
//       this.isAnglerNameEntered,
//       this.fishery,
//       this.bait,
//       this.id,
//       this.lake,
//       this.imageUpload,
//       this.userId,
//       this.swim,
//       this.uploadDate,
//       this.publicId,
//       this.fishSpecies,
//       this.isApproved,
//       this.fishWeightLb,
//       this.userImage});

//   CatchReports.fromJson(Map<String, dynamic> json) {
//     fisheryId = json['fishery_id'];
//     fishWeightOz = json['fish_weight_oz'];
//     isDeleted = json['is_deleted'];
//     name = json['name'];
//     personalBest = json['personal_best'];
//     notes = json['notes'];
//     fishCaughtDate = json['fish_caught_date'];
//     rig = json['rig'];
//     isAnglerNameEntered = json['is_angler_name_entered'];
//     fishery = json['fishery'];
//     bait = json['bait'];
//     id = json['id'];
//     lake = json['lake'];
//     imageUpload = json['image_upload'];
//     userId = json['user_id'];
//     swim = json['swim'];
//     uploadDate = json['upload_date'];
//     publicId = json['public_id'];
//     fishSpecies = json['fish_species'];
//     isApproved = json['is_approved'];
//     fishWeightLb = json['fish_weight_lb'];
//     userImage = json['user_image'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['fishery_id'] = fisheryId;
//     data['fish_weight_oz'] = fishWeightOz;
//     data['is_deleted'] = isDeleted;
//     data['name'] = name;
//     data['personal_best'] = personalBest;
//     data['notes'] = notes;
//     data['fish_caught_date'] = fishCaughtDate;
//     data['rig'] = rig;
//     data['is_angler_name_entered'] = isAnglerNameEntered;
//     data['fishery'] = fishery;
//     data['bait'] = bait;
//     data['id'] = id;
//     data['lake'] = lake;
//     data['image_upload'] = imageUpload;
//     data['user_id'] = userId;
//     data['swim'] = swim;
//     data['upload_date'] = uploadDate;
//     data['public_id'] = publicId;
//     data['fish_species'] = fishSpecies;
//     data['is_approved'] = isApproved;
//     data['fish_weight_lb'] = fishWeightLb;
//     data['user_image'] = userImage;
//     return data;
//   }
// }
