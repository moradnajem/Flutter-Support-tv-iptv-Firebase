
import 'dart:convert';

import 'package:tv/manger/status.dart';


SubscriptionsModel subscriptionsModelFromJson(String str) => SubscriptionsModel.fromJson(json.decode(str));

class SubscriptionsModel {
  SubscriptionsModel({
    required this.SubscriptionEN,
    required this.SubscriptionAR,
    required this.uid,


  });

  String SubscriptionEN;
  String SubscriptionAR;
  String uid;


  factory SubscriptionsModel.fromJson(Map<String, dynamic>? json) => SubscriptionsModel(
    SubscriptionEN: json!["Subscription-en"],
    SubscriptionAR: json["Subscription-ar"],

    uid: json["uid"],

  );
  Map<String, dynamic> toJson() => {
    "Subscription-en": SubscriptionEN,
    "Subscription-ar": SubscriptionAR,
    "uid": uid,
  };
}


