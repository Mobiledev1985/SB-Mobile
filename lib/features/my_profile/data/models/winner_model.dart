class WinnerModel {
  String? id;
  String? createdAt;
  String? winnerName;
  String? prize;

  WinnerModel({this.id, this.createdAt, this.winnerName, this.prize});

  WinnerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    winnerName = json['winner_name'];
    prize = json['prize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['created_at'] = createdAt;
    data['winner_name'] = winnerName;
    data['prize'] = prize;
    return data;
  }
}
