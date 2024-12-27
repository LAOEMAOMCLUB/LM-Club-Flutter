// import 'package:freezed_annotation/freezed_annotation.dart';

// part 'enroll_model.g.dart';

import 'dart:convert';

import 'package:lm_club/app/models/auth/response_model/cities_response.dart';
import 'package:lm_club/app/models/auth/response_model/login_response.dart';
import 'package:lm_club/app/models/auth/response_model/state_response.dart';
import 'package:lm_club/utils/string_extention.dart';

EnrollResModel enrollResModelFromJson(String str) =>
    EnrollResModel.fromJson(json.decode(str));

String enrollResModelToJson(EnrollResModel data) => json.encode(data.toJson());

class EnrollResModel {
  final bool? status;
  final String? message;
  final EnrollData? data;
  tokenData? accessToken;

  EnrollResModel({
    this.status,
    this.message,
    this.data,
    this.accessToken,
  });

  factory EnrollResModel.fromJson(Map<String, dynamic> json) => EnrollResModel(
        status: json["status"] ?? false,
        message: json.extractMessage(),
        data: EnrollData.fromJson(json["data"] ?? {}),
        accessToken: tokenData.fromJson(json["accessToken"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data!.toJson(),
        "accessToken": accessToken!.toJson()
      };
}

class EnrollData {
  EnrollData({
    this.id,
    this.username,
    this.role,
    // this.password,
    this.email,
    this.mobile,
    this.activeStatus,
    this.isVerifiedUser,
    this.street,
    this.state,
    this.city,
    this.planId,
    this.planAmount,
    this.subscription,
    this.imagePath,
    this.zipcode,
    // this.widgets,
    // this.role,
    this.referralCodeApplied,
    // this.createdBy,
    // this.createdOn,
    // this.modifiedBy,
    // this.modifiedOn,
    // this.v,
  });

  int? id;
  String? username;
  // int? createdBy;
  // int? modifiedBy;

  // String? password;
  String? email;
  String? mobile;
  bool? activeStatus;

  RoleData? role;
  String? street;
  StateData? state;
  String? planId;
  String? planAmount;
  CityData? city;
  String? referralCodeApplied;
  bool? isVerifiedUser;
  String? subscription;
  String? imagePath;
  String? zipcode;

  // List<WidgetModelResponse>? widgets;

  // Date? createdOn;
  // Date? modifiedOn;

  // int? v;

  factory EnrollData.fromJson(Map<String, dynamic> json) => EnrollData(
        id: json["id"],
        username: json["user_name"],
        // password: json["password"],
        email: json["email_id"] ?? '',
        mobile: json["mobile_number"] ?? '',

        activeStatus: json["is_active"] ?? false,
        isVerifiedUser: json['is_verified_user'] ?? false,

        imagePath: json["image_path"] ?? '',
        zipcode: json["zipcode"] ?? '',
        street: json["street"] ?? '',
        state: StateData.fromJson(json['state'] ?? {}),
        city: CityData.fromJson(json['city'] ?? {}),
        planId: json.containsKey('planDetails')
            ? getPlanId(json['planDetails'])
            : '',
        planAmount: json.containsKey('planAmount')
            ? json['planAmount']
            : json.containsKey('planDetails')
                ? getPlanAmount(json['planDetails'])
                : '',
        subscription: json["subscription"] ?? '',
        referralCodeApplied: json["referral_code_applied"] ?? '',
        // widgets: List<WidgetModelResponse>.from(json["widgets"] != null
        //     ? json['widgets'].map((x) => WidgetModelResponse.fromJson(x))
        //     : {}),
        // role: json['role'] ?? 0,
        role: RoleData.fromJson(json["role"] ?? {}),
        // createdBy: json["created_by"] ?? '',
        // modifiedBy: json["modified_by"] ?? '',
        // createdOn: json["created_on"] ?? '',
        // modifiedOn: json["modified_on"] ?? '',
        // createdAt: json["createdAt"] == null
        //     ? DateTime.now()
        //     : DateTime.parse(json["createdAt"]),
        // updatedAt: json["updatedAt"] == null
        //     ? DateTime.now()
        //     : DateTime.parse(json["updatedAt"]),
        // v: json["__v"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_name": username,
        // "password": password,
        "email_id": email,
        "mobile_number": mobile,
        "image_path": imagePath,
        "street": street,
        "state": state?.toJson(),
        "city": city?.toJson(),
        "subscription": subscription,
        "referral_code_applied": referralCodeApplied,
        "zipcode": zipcode,
        "is_active": activeStatus,
        "is_verified_user": isVerifiedUser,
        // "role": role
        // "created_on": createdAt!.toIso8601String(),
        // "modified_on": updatedAt!.toIso8601String(),
        "role": role!.toJson(),
        // "widgets": List<dynamic>.from(widgets!.map((x) => x.toJson())),
        // "created_on": createdOn,
        // "modified_on": modifiedOn,
        // "created_by": createdBy,
        // "modified_by": modifiedBy,
        // "createdAt": createdAt.toIso8601String(),
        // "updatedAt": updatedAt.toIso8601String(),
        // "__v": v,
      };
}

class RoleData {
  RoleData(
      {this.id,
      this.role,
      this.isActive,
      this.createdBy,
      this.createdOn,
      this.modifiedBy,
      this.modifiedOn});

  int? id;
  String? role;
  bool? isActive;
  String? createdOn;
  String? modifiedOn;
  String? createdBy;
  String? modifiedBy;

  factory RoleData.fromJson(Map<String, dynamic> json) => RoleData(
        id: json["id"] ?? 0,
        role: json["role"] ?? '',
        createdBy: json["created_by"] ?? '',
        modifiedBy: json["modified_by"] ?? '',
        createdOn: json["created_on"] ?? '',
        modifiedOn: json["modified_on"] ?? '',
        isActive: json["is_active"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "role": role,
        "is_active": isActive,
        "created_on": createdOn,
        "modified_on": modifiedOn,
        "created_by": createdBy,
        "modified_by": modifiedBy
      };
}

class tokenData {
  tokenData({
    this.accessToken,
  });
  String? accessToken;
  factory tokenData.fromJson(Map<String, dynamic> json) => tokenData(
        accessToken: json["access_token"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
      };
}
