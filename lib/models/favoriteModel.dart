// To parse this JSON data, do
//
//     final channelModel = channelModelFromJson(jsonString);

import 'dart:convert';

import 'package:tv/models/channelModel.dart';


FavoriteModel favoriteModelFromJson(String str) => FavoriteModel.fromJson(json.decode(str));

String favoriteModelToJson(FavoriteModel data) => json.encode(data.toJson());

class FavoriteModel {
  FavoriteModel({
    
    required this.channelId,
    required this.userId,
    required this.uid,
    required this.section,
    required this.streamURL,
    required this.titlear,
    required this.titleen,
  });

  String channelId;
  String userId;
  String uid;
  int section;
  String streamURL;
  String titlear;
  String  titleen;

  factory FavoriteModel.fromJson(Map<String, dynamic>? json) => FavoriteModel(
    channelId: json!["channelId"],
    section: json["section"],
    streamURL: json["streamURL"],
    titlear: json["titlear"],
    titleen: json["titleen"],
    uid: json["uid"],
    userId: json["userId"],
  );

  Map<String, dynamic> toJson() => {
    "channelId": channelId,
    "section": section,
    "streamURL": streamURL,
    "titlear": titlear,
    "titleen": titleen,
    "uid": uid,
    "userId": userId,
  };
}

