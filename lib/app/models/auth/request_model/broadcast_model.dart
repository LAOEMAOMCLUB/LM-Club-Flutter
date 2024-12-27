import 'dart:io';

import 'package:json_annotation/json_annotation.dart';

import 'dart:convert';



BroadcastModel broadcastModelRequestFromJson(String str) =>
    BroadcastModel.fromJson(json.decode(str));

String propertyPublishRequestToJson(BroadcastModel data) =>
    json.encode(data.toJson());

@JsonSerializable()
class BroadcastModel {
  final String? title;
  final String? description;
  List<File>? image;
  bool? isDrafted;

  BroadcastModel({
    this.title,
    this.description,
    this.image,
    this.isDrafted,
  });

  factory BroadcastModel.fromJson(Map<String, dynamic> json) => BroadcastModel(
        // image: json.containsKey("image")
        //     ? List<String>.from(json["image"].map((x) => x))
        //     : [],
        image: json["files"],
        title: json["title"],
        description: json["description"],
        isDrafted: json["is_draft"],
      );

  Map<String, dynamic> toJson() => {
        "files": image,
        "title": title,
        "description": description,
        "is_draft": isDrafted,
      }..removeWhere((String key, dynamic value) => value == null);
}
