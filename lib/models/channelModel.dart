// To parse this JSON data, do
//
//     final channelModel = channelModelFromJson(jsonString);

import 'dart:convert';

import 'package:tv/manger/Section.dart';


ChannelModel channelModelFromJson(String str) => ChannelModel.fromJson(json.decode(str));

String channelModelToJson(ChannelModel data) => json.encode(data.toJson());

class ChannelModel {
  ChannelModel({
    required this.sectionuid,
    required this.section,
    required this.streamURL,
    required this.titleEN,
    required this.titleAR,
    required this.uid,
  });

  String streamURL;
  String sectionuid;
  String titleEN;
  String titleAR;
  Section section;
  String uid;

  factory ChannelModel.fromJson(Map<String, dynamic>? json) => ChannelModel(
    streamURL: json!["streamURL"],
    sectionuid: json["section-uid"],
    titleEN: json["title-en"],
    titleAR: json["title-ar"],
    section: Section.values[json["section"]],
    uid: json["uid"],
  );

  Map<String, dynamic> toJson() => {
    "section-uid": sectionuid,
    "url-image": streamURL,
    "title-en": titleEN,
    "title-ar": titleAR,
    "section": section.index,
    "uid": uid,
  };
}

