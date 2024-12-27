import 'dart:io';

import 'package:json_annotation/json_annotation.dart';

import 'dart:convert';

BusinessUserDetailsRequestModel businessUserDetailsRequestModelFromJson(
        String str) =>
    BusinessUserDetailsRequestModel.fromJson(json.decode(str));

String businessUserDetailsRequestModelToJson(
        BusinessUserDetailsRequestModel data) =>
    json.encode(data.toJson());

@JsonSerializable()
class BusinessUserDetailsRequestModel {
  final String? email;
  final String? mobile;
  final String? username;
  final String? password;
  // final String? planType;

  final String? businessName;
  final String? businessBy;
  final String? businessType;
  final String? businessEstablishDate;
  final String? servicesOffered;
  final String? location;
  final String? operationHoursFrom;
  final String? operationHoursTo;
  File? file;
  final int? city;
  final int? state;
  final String zipcode;
  final String? street;
  BusinessUserDetailsRequestModel(
      {this.email,
      this.mobile,
      required this.username,
      this.password,
      //required this.planType,
      this.businessEstablishDate,
      this.businessName,
      this.businessBy,
      this.businessType,
      this.servicesOffered,
      this.location,
      this.operationHoursFrom,
      this.operationHoursTo,
      this.file,
      this.state,
      this.city,
      required this.zipcode,
      this.street});

  factory BusinessUserDetailsRequestModel.fromJson(Map<String, dynamic> json) =>
      BusinessUserDetailsRequestModel(
          mobile: json['business_mobile'],
          email: json['business_email'],
          username: json['user_name'],
          businessName: json['business_person_name'],
          password: json['password'],
          //   planType: json['planType'],
          businessBy: json['business_by'],
          businessType: json['type_of_business'],
          servicesOffered: json['services_offered'],
          location: json['location'],
          operationHoursTo: json['operation_hours_to'],
          operationHoursFrom: json['operation_hours_from'],
          file: json["file"] as File,
          businessEstablishDate: json["business_established_date"],
          city: json['city'] as int,
          state: json['state'] as int,
          zipcode: json['zipcode'] as String,
          street: json['street'] as String);

  Map<String, dynamic> toJson() => {
        'business_email': email,
        'business_mobile': mobile,
        'business_person_name': businessName,
        "user_name": username,
        'password': password,
        //'planType': planType,
        "type_of_business": businessType,
        "business_by": businessBy,
        "services_offered": servicesOffered,
        "location": location,
        "file": file,
        "operation_hours_to": operationHoursTo,
        "operation_hours_from": operationHoursFrom,
        "business_established_date": businessEstablishDate,
        'city': city,
        'state': state,
        'zipcode': zipcode,
        'street': street
      }..removeWhere((String key, dynamic value) => value == null);
}
