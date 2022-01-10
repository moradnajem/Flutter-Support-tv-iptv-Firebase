
import 'dart:convert';

import 'package:tv/manger/Section.dart';

ServiceModel serviceModelFromJson(String str) => ServiceModel.fromJson(json.decode(str));

class ServiceModel {
  ServiceModel({
    required this.titleEN,
    required this.titleAR,
    required this.section,
    required this.uid,

  });

  String titleEN;
  String titleAR;
  Section section;
  String uid;


  factory ServiceModel.fromJson(Map<String, dynamic>? json) => ServiceModel(
    titleEN: json!["title-en"],
    titleAR: json["title-ar"],
    section: Section.values[json["section"]],
    uid: json["uid"],

  );
  Map<String, dynamic> toJson() => {
    "title-en": titleEN,
    "title-ar": titleAR,
    "section": section.index,
    "uid": uid,
  };
}


