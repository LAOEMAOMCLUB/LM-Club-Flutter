import 'package:json_annotation/json_annotation.dart';

import 'dart:convert';

UserDetailsRequestModel userDetailsRequestModelFromJson(String str) =>
    UserDetailsRequestModel.fromJson(json.decode(str));

String userDetailsRequestModelToJson(UserDetailsRequestModel data) =>
    json.encode(data.toJson());

@JsonSerializable()
class UserDetailsRequestModel {
  final String? email;
  final String? mobile;
  final String? username;
  final String? password;
  final String? planType;
  final String? street;
  final int? city;
  final int? state;
  final String? zipcode;
  final String? referalCode;
  final String? id;
  final String? imagePath;
  UserDetailsRequestModel({
    this.email,
    this.mobile,
    this.username,
    this.password,
    this.planType,
    this.street,
    this.city,
    this.state,
    this.referalCode,
    this.zipcode,
    this.imagePath,
    this.id,
  });

  factory UserDetailsRequestModel.fromJson(Map<String, dynamic> json) =>
      UserDetailsRequestModel(
        mobile: json['mobile'] as String,
        email: json['email'] as String,
        username: json['user_name'] as String,
        password: json['password'] as String,
        planType: json['planType'] as String,
        street: json['street'] as String,
        city: json['city'] as int,
        state: json['state'] as int,
        referalCode: json['referalCode'] as String,
        zipcode: json['zipcode'] as String,
        imagePath: json["image_path"] as String,
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        'email': email,
        'mobile': mobile,
        'user_name': username,
        'password': password,
        'planType': planType,
        'street': street,
        'city': city,
        'state': state,
        'zipcode': zipcode,
        'image_path': imagePath,
        'referalCode': referalCode,
        "id": id,
      }..removeWhere((String key, dynamic value) => value == null);
}
