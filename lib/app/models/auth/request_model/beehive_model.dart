import 'dart:io';

import 'package:json_annotation/json_annotation.dart';

import 'dart:convert';

BeehiveModel beehiveModelRequestFromJson(String str) =>
    BeehiveModel.fromJson(json.decode(str));

String beehiveRequestToJson(BeehiveModel data) => json.encode(data.toJson());

@JsonSerializable()
class BeehiveModel {
  final String? title;
  final String? description;
  final int? category;
  List<File>? image;
  String? couponCode;
  bool? isDrafted;
  String? companyName;
  String? validUpto;
   String? validFrom;
 final String? operationHoursFrom;
  final String? operationHoursTo;
  BeehiveModel({
    this.title,
    this.description,
    this.image,
    this.couponCode,
    this.category,
    this.validUpto,
    this.companyName,
    this.isDrafted,
    this.validFrom,
      this.operationHoursFrom,
      this.operationHoursTo,
  });

  factory BeehiveModel.fromJson(Map<String, dynamic> json) => BeehiveModel(
        image: json["files"],
        title: json["title"],
        description: json["description"],
        couponCode: json["coupon_code"],
        category: json["category"],
        validUpto: json["valid_upto"],
        companyName: json["company_name"],
        isDrafted: json["is_draft"],
        validFrom: json["valid_from"],
          operationHoursTo : json['event_end_time'] ,
      operationHoursFrom : json['event_start_time'] 
      );

  Map<String, dynamic> toJson() => {
        "files": image,
        "title": title,
        "description": description,
        "category": category,
        "valid_upto": validUpto,
        "coupon_code": couponCode,
        "company_name": companyName,
        "is_draft": isDrafted,
        "valid_from" : validFrom,
          "event_end_time" : operationHoursTo ,
      "event_start_time" : operationHoursFrom,
      }..removeWhere((String key, dynamic value) => value == null);
}
