
import 'dart:convert';

import 'package:tv/manger/Section.dart';

SectionModel sectionModelFromJson(String str) => SectionModel.fromJson(json.decode(str));

class SectionModel {
  SectionModel({
    required this.titleEN,
    required this.titleAR,
    required this.section,
    required this.uid,

  });

  String titleEN;
  String titleAR;
  Section section;
  String uid;


  factory SectionModel.fromJson(Map<String, dynamic>? json) => SectionModel(
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


