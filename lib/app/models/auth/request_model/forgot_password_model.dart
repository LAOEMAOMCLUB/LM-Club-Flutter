import 'package:json_annotation/json_annotation.dart';

import 'dart:convert';

ForgotPasswordModel forgotPasswordModelRequestFromJson(String str) =>
    ForgotPasswordModel.fromJson(json.decode(str));

String forgotPasswordModelRequestToJson(ForgotPasswordModel data) =>
    json.encode(data.toJson());

@JsonSerializable()
class ForgotPasswordModel {
  final String? mobile;
  final int? otp;
  final String? newPassword;
   final String? confirmPassword;

  ForgotPasswordModel( {this.mobile, this.otp,this.newPassword , this.confirmPassword});

  factory ForgotPasswordModel.fromJson(Map<String, dynamic> json) =>
      ForgotPasswordModel(
        mobile: json["mobile"],
        otp: json["otp"],
        newPassword: json["newPassword"],
        confirmPassword : json["confirmPassword"]
      );

  Map<String, dynamic> toJson() => {
        "mobile": mobile,
        "otp":otp,
        "newPassword":newPassword,
        "confirmPassword":confirmPassword
      }..removeWhere((String key, dynamic value) => value == null);
}
