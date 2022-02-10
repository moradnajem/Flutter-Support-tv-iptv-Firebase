// To parse this JSON data, do
//
//     final channelModel = channelModelFromJson(jsonString);

import 'dart:convert';


FavoriteModel favoriteModelFromJson(String str) => FavoriteModel.fromJson(json.decode(str));

String favoriteModelToJson(FavoriteModel data) => json.encode(data.toJson());

class FavoriteModel {
  FavoriteModel({
    
    required this.channelId,
    required this.userId,
    required this.uid,
    required this.section,
  });

  String channelId;
  String userId;
  String uid;
  int section;

  factory FavoriteModel.fromJson(Map<String, dynamic>? json) => FavoriteModel(
    channelId: json!["channelId"],
    userId: json["userId"],
    uid: json["uid"],
    section: json["section"],
  );

  Map<String, dynamic> toJson() => {
    "channelId": channelId,
    "userId": userId,
    "uid": uid,
    "section": section,
  };
}

