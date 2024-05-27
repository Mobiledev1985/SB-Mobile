import 'package:flutter/material.dart' show ValueNotifier;

enum QuestionState { notSubmitted, confirmation, correct, wrong }

class GiveawayQuizModel {
  String? id;
  String? question;
  String? bannerImage;
  String? option1;
  String? option3;
  bool? deactivate;
  String? endTs;
  String? giveawayTheme;
  String? title;
  String? shortDescription;
  String? option2;
  String? startTs;
  String? ticketNumber;
  ValueNotifier<QuestionState>? questionState;

  GiveawayQuizModel({
    this.id,
    this.question,
    this.bannerImage,
    this.option1,
    this.option3,
    this.deactivate,
    this.endTs,
    this.giveawayTheme,
    this.title,
    this.shortDescription,
    this.option2,
    this.startTs,
    this.questionState,
  });

  GiveawayQuizModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    bannerImage = json['banner_image'];
    option1 = json['option1'];
    option3 = json['option3'];
    deactivate = json['deactivate'];
    endTs = json['end_ts'];
    giveawayTheme = json['giveaway_theme'];
    title = json['title'];
    shortDescription = json['short_description'];
    option2 = json['option2'];
    startTs = json['start_ts'];
    ticketNumber = json['ticket_number'];
    questionState = ValueNotifier(QuestionState.notSubmitted);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['question'] = question;
    data['banner_image'] = bannerImage;
    data['option1'] = option1;
    data['option3'] = option3;
    data['deactivate'] = deactivate;
    data['end_ts'] = endTs;
    data['giveaway_theme'] = giveawayTheme;
    data['title'] = title;
    data['short_description'] = shortDescription;
    data['option2'] = option2;
    data['start_ts'] = startTs;
    return data;
  }
}
