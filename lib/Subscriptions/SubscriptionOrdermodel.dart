// To parse this JSON data, do
//
//     final channelModel = channelModelFromJson(jsonString);

import 'dart:convert';

import 'package:tv/manger/status.dart';
//SubscriptionOrderModel


SubscriptionOrderModel subscriptionSubscriptionOrderModelFromJson(String str) => SubscriptionOrderModel.fromJson(json.decode(str));

String subscriptionSubscriptionOrderModelToJson(SubscriptionOrderModel data) => json.encode(data.toJson());

class SubscriptionOrderModel {
  SubscriptionOrderModel({
    required this.userId,
    required this.ownerId,
    required this.createdDate,
    required this.status,
    required this.messageEN,
    required this.messageAR,
    required this.uid,
  });

  String userId;
  String ownerId;
  String createdDate;
  Status status;
  String messageEN;
  String messageAR;
  String uid;

  factory SubscriptionOrderModel.fromJson(Map<String, dynamic>? json) => SubscriptionOrderModel(
    userId: json!["user-id"],
    ownerId: json["Subscription-id"],
    createdDate: json["createdDate"],
    status: Status.values[json["status"]],
    messageEN: json["message-en"],
    messageAR: json["message-ar"],
    uid: json["uid"],
  );

  Map<String, dynamic> toJson() => {
    "user-id": userId,
    "Subscription-id": ownerId,
    "createdDate": createdDate,
    "status": status.index,
    "message-en": messageEN,
    "message-ar": messageAR,
    "uid": uid,
  };
}