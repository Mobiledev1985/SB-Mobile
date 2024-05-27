class AchievementModel {
  CurrentTier? currentTier;
  int? currentPoints;
  List<Achievements>? achievements;

  AchievementModel({this.currentTier, this.currentPoints, this.achievements});

  AchievementModel.fromJson(Map<String, dynamic> json) {
    currentTier = json['current_tier'] != null
        ? CurrentTier.fromJson(json['current_tier'])
        : null;
    currentPoints = json['current_points'];
    if (json['achievements'] != null) {
      achievements = <Achievements>[];
      json['achievements'].forEach((v) {
        achievements!.add(Achievements.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (currentTier != null) {
      data['current_tier'] = currentTier!.toJson();
    }
    data['current_points'] = currentPoints;
    if (achievements != null) {
      data['achievements'] = achievements!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CurrentTier {
  int? maxPoint;
  String? name;
  String? id;
  String? image;
  int? level;
  int? minPoint;

  CurrentTier(
      {this.maxPoint,
      this.name,
      this.id,
      this.image,
      this.level,
      this.minPoint});

  CurrentTier.fromJson(Map<String, dynamic> json) {
    maxPoint = json['max_point'];
    name = json['name'];
    id = json['id'];
    image = json['image'];
    level = json['level'];
    minPoint = json['min_point'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['max_point'] = maxPoint;
    data['name'] = name;
    data['id'] = id;
    data['image'] = image;
    data['level'] = level;
    data['min_point'] = minPoint;
    return data;
  }
}

class Achievements {
  String? section;
  List<Badges>? badges;

  Achievements({this.section, this.badges});

  Achievements.fromJson(Map<String, dynamic> json) {
    section = json['section'];
    if (json['badges'] != null) {
      badges = <Badges>[];
      json['badges'].forEach((v) {
        badges!.add(Badges.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['section'] = section;
    if (badges != null) {
      data['badges'] = badges!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Badges {
  String? name;
  String? description;
  String? icon;
  int? points;
  bool? awarded;
  String? awardedDate;

  Badges(
      {this.name,
      this.description,
      this.icon,
      this.points,
      this.awarded,
      this.awardedDate});

  Badges.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    icon = json['icon'];
    points = json['points'];
    awarded = json['awarded'];
    awardedDate = json['awarded_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['description'] = description;
    data['icon'] = icon;
    data['points'] = points;
    data['awarded'] = awarded;
    data['awarded_date'] = awardedDate;
    return data;
  }
}
