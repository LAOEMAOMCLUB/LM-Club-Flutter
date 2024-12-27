import 'dart:convert';

import 'package:lm_club/app/models/auth/response_model/cities_response.dart';
import 'package:lm_club/app/models/auth/response_model/state_response.dart';

LoginResponseModel loginResponseModelFromJson(String str) =>
    LoginResponseModel.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponseModel data) =>
    json.encode(data.toJson());

class LoginResponseModel {
  LoginResponseModel({
    required this.status,
    required this.message,
    required this.data,
    required this.accessToken,
  });

  bool status;
  String message;
  LoginData data;
  tokenData accessToken;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        status: json["status"],
        message: json["message"],
        data: LoginData.fromJson(json["data"] ?? {}),
        accessToken: tokenData.fromJson(json["accessToken"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
        "accessToken": accessToken.toJson()
      };
}

class LoginData {
  LoginData({
    this.id,
    this.username,

    // this.password,
    this.email,
    this.mobile,
    this.activeStatus,
    this.isVerifiedUser,
    this.street,
    this.state,
    this.city,
    required this.planId,
    this.planAmount,
    this.subscription,
    this.imagePath,
    this.zipcode,
    this.planStatus,
    // this.widgets,
    this.role,
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
  bool? planStatus;
  RoleData? role;
  String? street;
  StateData? state;
  CityData? city;
  String planId;
  String? planAmount;
  String? referralCodeApplied;
  bool? isVerifiedUser;
  String? subscription;
  String? imagePath;
  String? zipcode;

  // List<WidgetModelResponse>? widgets;

  // Date? createdOn;
  // Date? modifiedOn;

  // int? v;

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
        id: json["id"],
        username: json["user_name"],
        // password: json["password"],
        email: json["email_id"] ?? '',
        mobile: json["mobile_number"] ?? '',

        activeStatus: json["is_active"],
        isVerifiedUser: json['is_verified_user'],
        planStatus: json["planStatus"],
        imagePath: json["image_path"],
        zipcode: json["zipcode"],
        street: json["street"],
        state: StateData.fromJson(json["state"]),
        city: CityData.fromJson(json["city"]),
        planId: json.containsKey('subscriptionDetails')
            ? getPlanId(json['subscriptionDetails'])
            : '',
        planAmount: json.containsKey('subscriptionDetails')
            ? getPlanAmount(json['subscriptionDetails'])
            : '',
        subscription: json["subscription"],
        referralCodeApplied: json["referral_code_applied"],
        // widgets: List<WidgetModelResponse>.from(json["widgets"] != null
        //     ? json['widgets'].map((x) => WidgetModelResponse.fromJson(x))
        //     : {}),

        role: RoleData.fromJson(json["role"]),
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
        "planStatus": planStatus,
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

class WidgetModelResponse {
  WidgetModelResponse({
    required this.id,
    required this.name,
  });
  int id;
  String name;

  factory WidgetModelResponse.fromJson(Map<String, dynamic> json) =>
      WidgetModelResponse(
        id: json["id"] ?? 0,
        name: json["widget_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "widget_name": name,
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
        role: json["role"],
        createdBy: json["created_by"],
        modifiedBy: json["modified_by"],
        createdOn: json["created_on"],
        modifiedOn: json["modified_on"],
        isActive: json["is_active"],
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

String getPlanAmount(Map<String, dynamic> obj) {
  if (obj.containsKey('subscription')) {
    Map<String, dynamic> subscription = obj['subscription'];
    if (subscription.containsKey('plan_amount')) {
      return subscription['plan_amount'];
    } else {
      return '';
    }
  } else {
    return '';
  }
}

String getPlanId(Map<String, dynamic> obj) {
  if (obj.containsKey('subscription')) {
    Map<String, dynamic> subscription = obj['subscription'];
    if (subscription.containsKey('id')) {
      return subscription['id'].toString();
    } else {
      return '';
    }
  } else {
    return '';
  }
}
