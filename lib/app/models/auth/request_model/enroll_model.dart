import 'package:json_annotation/json_annotation.dart';

part 'enroll_model.g.dart';

@JsonSerializable()
class EnrollModel {
  final int? planId;
  final String email;
  final String mobile;
  final String username;
  final String password;
  final String planType;
  final String street;
  final int? city;
  final int? state;
  final String zipcode;
  final String? referalCode;

  EnrollModel({
   this.planId,
    required this.email,
    required this.mobile,
    required this.username,
    required this.password,
    required this.planType,
    required this.street,
    required this.city,
    required this.state,
    this.referalCode,
    required this.zipcode,
  });

  factory EnrollModel.fromJson(Map<String, dynamic> json) =>
      _$EnrollModelFromJson(json);
  Map<String, dynamic> toJson() => _$EnrollModelToJson(this);
}
