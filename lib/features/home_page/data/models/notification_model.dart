class NotificationModel {
  String? title;
  String? id;
  Map<String, dynamic>? data;
  bool? isRead;
  String? body;
  String? userId;
  String? createdAt;

  NotificationModel(
      {this.title,
      this.id,
      this.data,
      this.isRead,
      this.body,
      this.userId,
      this.createdAt});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    id = json['id'];
    data = json['data'];
    isRead = json['is_read'];
    body = json['body'];
    userId = json['user_id'];
    createdAt = json['created_at'];
  }
}
