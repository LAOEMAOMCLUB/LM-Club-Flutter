// import 'package:freezed_annotation/freezed_annotation.dart';

// part 'login_req_model.g.dart';

// @JsonSerializable()
// class LoginReqModel {
//   final String email;
//   final String password;

//   LoginReqModel({
//     required this.email,
//     required this.password,
//   });

//   factory LoginReqModel.fromJson(Map<String, dynamic> json) =>
//       _$LoginReqModelFromJson(json);
//   Map<String, dynamic> toJson() => _$LoginReqModelToJson(this);
// }

import 'package:json_annotation/json_annotation.dart';

import 'dart:convert';

LoginReqModel loginReqModelRequestFromJson(String str) =>
    LoginReqModel.fromJson(json.decode(str));

String loginReqModelRequestToJson(LoginReqModel data) =>
    json.encode(data.toJson());

@JsonSerializable()
class LoginReqModel {
  final String email;
   final String password;

  LoginReqModel({
    required this.email,
     required this.password,
  });

  factory LoginReqModel.fromJson(Map<String, dynamic> json) =>
      LoginReqModel(
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
      }..removeWhere((String key, dynamic value) => value == null);
}
