
import 'dart:convert';



SubscriptionsModel subscriptionsModelFromJson(String str) => SubscriptionsModel.fromJson(json.decode(str));

class SubscriptionsModel {
  SubscriptionsModel({
    required this.SubscriptionEN,
    required this.SubscriptionAR,
    required this.uid,
    required this.details,
    required this.uidOwner,


  });

  String SubscriptionEN;
  String SubscriptionAR;
  String details;
  String uidOwner;
  String uid;


  factory SubscriptionsModel.fromJson(Map<String, dynamic>? json) => SubscriptionsModel(
    SubscriptionEN: json!["Subscription-en"],
    SubscriptionAR: json["Subscription-ar"],
    details: json["details"],
    uidOwner: json["uid-owner"],
    uid: json["uid"],

  );
  Map<String, dynamic> toJson() => {
    "Subscription-en": SubscriptionEN,
    "Subscription-ar": SubscriptionAR,
    "details": details,
    "uid-owner": uidOwner,
    "uid": uid,
  };
}


