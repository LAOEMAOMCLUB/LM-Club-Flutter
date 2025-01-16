// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'coupons_model.g.dart';

@JsonSerializable()
class CouponsModel {
  final String company_name;
  final String description;
  final String company_offer;
  final String valid_upto;
  final String category;
  final String referal_code;
  final String image;

  CouponsModel({
    required this.company_name,
    required this.description,
    required this.image,
    required this.category,
    required this.company_offer,
    required this.referal_code,
    required this.valid_upto,
  });

  factory CouponsModel.fromJson(Map<String, dynamic> json) =>
      _$CouponsModelFromJson(json);
  Map<String, dynamic> toJson() => _$CouponsModelToJson(this);
}
