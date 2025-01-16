import 'dart:io';

import 'package:json_annotation/json_annotation.dart';

part 'business_enroll_model.g.dart';

@JsonSerializable()
class BusinessEnrollModel {
  final String email;
  final String mobile;
  final String username;
  final String password;
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
  BusinessEnrollModel(
      {required this.email,
      required this.mobile,
      required this.username,
      required this.password,
      //required this.planType,
      this.businessEstablishDate,
      this.businessName,
      this.businessBy,
      this.businessType,
      this.servicesOffered,
      this.location,
      this.operationHoursFrom,
      this.state,
      this.city,
      required this.zipcode,
      this.operationHoursTo,
      this.file,
      this.street});

  factory BusinessEnrollModel.fromJson(Map<String, dynamic> json) =>
      _$BusinessEnrollModelFromJson(json);
  Map<String, dynamic> toJson() => _$BusinessEnrollModelToJson(this);
}
