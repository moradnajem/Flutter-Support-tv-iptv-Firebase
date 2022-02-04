
import 'dart:convert';



SubscriptionsModel subscriptionsModelFromJson(String str) => SubscriptionsModel.fromJson(json.decode(str));

class SubscriptionsModel {
  SubscriptionsModel({
    required this.SubscriptionEN,
    required this.SubscriptionAR,
    required this.uid,
    required this.uidOwner,


  });

  String SubscriptionEN;
  String SubscriptionAR;
  String uidOwner;
  String uid;


  factory SubscriptionsModel.fromJson(Map<String, dynamic>? json) => SubscriptionsModel(
    SubscriptionEN: json!["Subscription-en"],
    SubscriptionAR: json["Subscription-ar"],
    uidOwner: json["uid-owner"],
    uid: json["uid"],

  );
  Map<String, dynamic> toJson() => {
    "Subscription-en": SubscriptionEN,
    "Subscription-ar": SubscriptionAR,
    "uid-owner": uidOwner,
    "uid": uid,
  };
}


