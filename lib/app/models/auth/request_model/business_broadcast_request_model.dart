import 'dart:io';

import 'package:json_annotation/json_annotation.dart';

import 'dart:convert';



BusinessBroadcastModel businessBroadcastModelRequestFromJson(String str) =>
    BusinessBroadcastModel.fromJson(json.decode(str));

String businessBroadcastModelRequestToJson(BusinessBroadcastModel data) =>
    json.encode(data.toJson());

@JsonSerializable()
class BusinessBroadcastModel {
  final String? title;
  final String? description;
  List<File>? image;
  String? isDrafted;
  String? couponCode;
  String? validDate;
  String? whatPromoting;
  String? postDuration;
  String? id;
  bool? isEdited;

  BusinessBroadcastModel({
    this.title,
    this.description,
    this.image,
    this.isDrafted,
    this.couponCode,
    this.validDate,
    this.whatPromoting,
    this.postDuration,
    this.id,
    this.isEdited,
  });

  factory BusinessBroadcastModel.fromJson(Map<String, dynamic> json) => BusinessBroadcastModel(
        // image: json.containsKey("image")
        //     ? List<String>.from(json["image"].map((x) => x))
        //     : [],
        image: json["files"] ?? '',
        title: json["title"],
        description: json["description"],
        isDrafted: json["is_draft"],
        whatPromoting: json['what_are_you_promoting'],
        postDuration: json["post_duration"],
        couponCode: json["coupon_code"],
        id: json['id'],
        validDate: json["valid_from"],
        isEdited: json['is_edited'] 
      );

  Map<String, dynamic> toJson() => {
        "files": image,
        "title": title,
        "description": description,
        "is_draft": isDrafted,
        "valid_from":validDate,
        "coupon_code":couponCode,
        "post_duration":postDuration,
        "what_are_you_promoting":whatPromoting,
        'id': id,
        'is_edited' : isEdited
      }..removeWhere((String key, dynamic value) => value == null);
}
