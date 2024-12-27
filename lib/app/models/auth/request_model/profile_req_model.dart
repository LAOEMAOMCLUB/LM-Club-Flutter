import 'dart:io';

import 'package:json_annotation/json_annotation.dart';

import 'dart:convert';

ProfileRequestModel profileRequestModelRequestFromJson(String str) =>
    ProfileRequestModel.fromJson(json.decode(str));

String profileRequestModelRequestToJson(ProfileRequestModel data) =>
    json.encode(data.toJson());

@JsonSerializable()
class ProfileRequestModel {
  File? image;

  final String? id;

  ProfileRequestModel({
     this.image,
    this.id,
  });

  factory ProfileRequestModel.fromJson(Map<String, dynamic> json) =>
      ProfileRequestModel(
        image: json["file"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "file": image,
        "id": id,
      }..removeWhere((String key, dynamic value) => value == null);
}
