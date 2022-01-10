import 'dart:convert';

import 'package:tv/manger/status.dart';
import 'package:tv/manger/user-type.dart';






UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    required this.id,
    required this.image,
    required this.name,
    required this.phone,
    required this.email,
    required this.city,
    required this.uid,
    required this.accountStatus,
    required this.userType,
    required this.balance,
    required this.dateCreated,
  });

  String id;
  String image;
  String name;
  String phone;
  String email;
  String city;
  String uid;
  Status accountStatus;
  UserType userType;
  double balance;
  String dateCreated;

  factory UserModel.fromJson(Map<String, dynamic>? json) => UserModel(
    id: json!["id"],
    image: json["image"],
    name: json["name"],
    phone: json["phone"],
    email: json["email"],
    city: json["city"],
    uid: json["uid"],
    balance: (json["balance"] ?? 0) * 1.0,
    accountStatus: Status.values[json["status-account"]],
    userType: UserType.values[json["type-user"]],
    dateCreated: json["date-created"] ?? DateTime.now().toString(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
    "name": name,
    "phone": phone,
    "email": email,
    "city": city,
    "uid": uid,
    "balance": balance,
    "status-account": accountStatus.index,
    "type-user": userType.index,
    "date-created": dateCreated,
  };
}