// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_enroll_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusinessEnrollModel _$BusinessEnrollModelFromJson(Map<String, dynamic> json) =>
    BusinessEnrollModel(
        mobile: json['business_mobile'] as String,
        email: json['business_email'] as String,
        username: json['business_person_name'] as String,
        businessName: json['business_name'] as String,
        password: json['password'] as String,
        //   planType: json['planType'] as String,
        businessBy: json['business_by'] as String,
        businessType: json['type_of_business'] as String,
        servicesOffered: json['services_offered'] as String,
        location: json['location'] as String,
        operationHoursTo: json['operation_hours_to'] as String,
        operationHoursFrom: json['operation_hours_from'] as String,
        file: json["file"] as File,
        businessEstablishDate: json["business_established_date"] as String,
        city: json['city'] as int,
        state: json['state'] as int,
        zipcode: json['zipcode'] as String,
        street: json['street'] as String);

Map<String, dynamic> _$BusinessEnrollModelToJson(
        BusinessEnrollModel instance) =>
    <String, dynamic>{
      'business_email': instance.email,
      'business_mobile': instance.mobile,
      'business_person_name': instance.username,
      "business_name": instance.businessName,
      'password': instance.password,
      //'planType': instance.planType,
      "type_of_business": instance.businessType,
      "business_by": instance.businessBy,
      "services_offered": instance.servicesOffered,
      "location": instance.location,
      "file": instance.file,
      "operation_hours_to": instance.operationHoursTo,
      "operation_hours_from": instance.operationHoursFrom,
      "business_established_date": instance.businessEstablishDate,
      'city': instance.city,
      'state': instance.state,
      'zipcode': instance.zipcode,
      'street':instance.street
    };
