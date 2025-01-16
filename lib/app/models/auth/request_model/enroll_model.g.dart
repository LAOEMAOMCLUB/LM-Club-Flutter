// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enroll_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EnrollModel _$EnrollModelFromJson(Map<String, dynamic> json) => EnrollModel(
    planId: json['planId'] as int,
    mobile: json['mobile'] as String,
    email: json['email'] as String,
    username: json['username'] as String,
    password: json['password'] as String,
    planType: json['planType'] as String,
    street: json['street'] as String,
    city: json['city'] as int,
    state: json['state'] as int,
    referalCode: json['referalCode'] as String,
    zipcode: json['zipcode'] as String);

Map<String, dynamic> _$EnrollModelToJson(EnrollModel instance) =>
    <String, dynamic>{
      'planId': instance.planId,
      'email': instance.email,
      'mobile': instance.mobile,
      'username': instance.username,
      'password': instance.password,
      'planType': instance.planType,
      'street': instance.street,
      'city': instance.city,
      'state': instance.state,
      'zipcode': instance.zipcode,
      'referalCode': instance.referalCode
    };
