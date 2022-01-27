import 'dart:convert';

import 'package:tv/manger/status.dart';
import 'package:tv/manger/user-type.dart';






UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
     this.id,
     required this.image,
     required this.name,
     this.phone,
     this.email,
     this.city,
     this.uid,
     this.accountStatus,
     this.userType,
     this.dateCreated,
  });

  String? id;
  String image;
  String name;
  String? phone;
  String? email;
  String? city;
  String? uid;
  Status? accountStatus;
  UserType? userType;
  String? dateCreated;

  factory UserModel.fromJson(Map<String, dynamic>? json) => UserModel(
    id: json!["id"],
    image: json["image"],
    name: json["name"],
    phone: json["phone"],
    email: json["email"],
    city: json["city"],
    uid: json["uid"],
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
    "status-account": accountStatus!.index,
    "type-user": userType!.index,
    "date-created": dateCreated,
  };
}