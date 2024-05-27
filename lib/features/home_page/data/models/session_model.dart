class SessionModel {
  String? userId;
  bool? isCancelled;
  String? fisheryName;
  int? captures;
  String? endTs;
  String? id;
  String? fisheryId;
  String? startTs;
  int? sessionNoteCount;
  String? imageUrl;

  SessionModel({
    this.userId,
    this.isCancelled,
    this.fisheryName,
    this.captures,
    this.endTs,
    this.id,
    this.fisheryId,
    this.startTs,
    this.sessionNoteCount,
    this.imageUrl,
  });

  SessionModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    isCancelled = json['is_cancelled'];
    fisheryName = json['fishery_name'];
    captures = json['captures'];
    endTs = json['end_ts'];
    id = json['id'];
    fisheryId = json['fishery_id'];
    startTs = json['start_ts'];
    sessionNoteCount = json['session_note_count'];
    imageUrl = '';
  }
}
