import 'dart:convert';

import 'package:lm_club/utils/string_extention.dart';

UserData planResponseFromJson(String str) =>
    UserData.fromJson(json.decode(str));

class UserDetailsResponse {
  final bool status;
  final String message;
  final UserData? data;

  UserDetailsResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory UserDetailsResponse.fromMap(Map<String, dynamic> map) {
    return UserDetailsResponse(
      status: map['status'] ?? false,
      message: map.extractMessage(),
      data: UserData.fromJson(map['data'] ?? {}),
    );
  }
}

class UserData {
  int? id;
  String? username;
  // int? createdBy;
  // int? modifiedBy;

  // String? password;
  String? email;
  String? mobile;
  bool? activeStatus;
  bool? planStatus;
  String? planMessage;
  RoleData? role;
  String? street;
  String? referralCodeApplied;
  bool? isVerifiedUser;
  String? subscription;
  int? subscriptionId;
  String? imagePath;
  String? planImage;
  String? zipcode;
  CitiesData? cities;
  StatedData? states;
  List<WidgetModelResponse>? widgets;
  DateTime? planValidity;
  BusinessData? businessDetails;
  AboutUs? aboutus;
  TC? tc;
  LMClubRewards? lmClubRewards;
  // Date? createdOn;
  // Date? modifiedOn;

  // int? v;

  UserData(
      {this.id,
      this.username,

      // this.password,
      this.email,
      this.mobile,
      this.activeStatus,
      this.isVerifiedUser,
      this.street,
      this.subscription,
      this.subscriptionId,
      this.imagePath,
      this.planImage,
      this.zipcode,
      this.widgets,
      this.cities,
      this.states,
      this.role,
      this.businessDetails,
      this.planMessage,
      this.planStatus,
      this.referralCodeApplied,
      this.planValidity,
      this.aboutus,
      this.tc,
      this.lmClubRewards
      // this.createdBy,
      // this.createdOn,
      // this.modifiedBy,
      // this.modifiedOn,
      // this.v,
      });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
        id: json["id"],
        username: json["user_name"] ?? '',
        // password: json["password"],
        email: json["email_id"] ?? '',
        mobile: json["mobile_number"] ?? '',
        activeStatus: json["is_active"],
        isVerifiedUser: json['is_verified_user'],
        imagePath: json["image_path"] ?? '',
        planImage: json["planImage"] ?? '',
        zipcode: json["zipcode"],
        street: json["street"],
        subscription: json["subscription"] ?? '',
        subscriptionId: json["subscriptionId"],
        planValidity: json["planValidity"] != null
            ? DateTime.parse(json["planValidity"])
            : null,
        planMessage: json['planMessage'] ?? '',
        planStatus: json['planStatus'] ?? true,
        referralCodeApplied: json["referral_code_applied"],
        widgets: List<WidgetModelResponse>.from(json["widgets"] != null
            ? json['widgets'].map((x) => WidgetModelResponse.fromJson(x))
            : {}),
        cities: CitiesData.fromJson(json["city"] ?? {}),
        states: StatedData.fromJson(json["state"] ?? {}),
        role: RoleData.fromJson(json["role"] ?? {}),
        aboutus: AboutUs.fromJson(json["AboutUs"] ?? {}),
        tc: TC.fromJson(json["T&C"] ?? {}),
        lmClubRewards: LMClubRewards.fromJson(json["LM CLUB Rewards"] ?? {}),
        businessDetails: BusinessData.fromJson(json["businessDetails"] ?? {})
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
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_name": username,
        // "password": password,
        "email_id": email,
        "mobile_number": mobile,
        "image_path": imagePath,
        "planImage": planImage,
        "street": street,
        "subscription": subscription,
        "subscriptionId": subscriptionId,
        "referral_code_applied": referralCodeApplied,
        "zipcode": zipcode,
        "planValidity": planValidity?.toIso8601String(),
        "is_active": activeStatus,
        // "created_on": createdAt!.toIso8601String(),
        // "modified_on": updatedAt!.toIso8601String(),
        "role": role!.toJson(),
        "businessDetails": businessDetails!.toJson(),
        "widgets": List<dynamic>.from(widgets!.map((x) => x.toJson())),
        "city": cities!.toJson(),
        "state": states!.toJson(),
        "AboutUs": aboutus!.toJson(),
        "T&C": tc!.toJson(),
        "planStatus": planStatus,
        "planMessage": planMessage,
        "LM CLUB Rewards": lmClubRewards
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
  final int? id;
  final String? widgetName;
  final WidgetContent? content;
  final WidgetTermsAndConditions? termsAndConditions;
  final String? imagePath;

  WidgetModelResponse({
    this.id,
    this.widgetName,
    this.content,
    this.termsAndConditions,
    this.imagePath,
  });

  factory WidgetModelResponse.fromJson(Map<String, dynamic> json) {
    return WidgetModelResponse(
      id: json["id"],
      widgetName: json["widget_name"] ?? '',
      content: WidgetContent.fromJson(json["content"] ?? {}),
      termsAndConditions: WidgetTermsAndConditions.fromJson(json["t&c"] ?? {}),
      imagePath: json["image_path"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "widget_name": widgetName,
        "content": content!.toJson(),
        "t&c": termsAndConditions!.toJson(),
        "image_path": imagePath,
      };
}

class WidgetContent {
  final String name;
  final String content;

  WidgetContent({
    required this.name,
    required this.content,
  });

  factory WidgetContent.fromJson(Map<String, dynamic> json) {
    return WidgetContent(
      name: json["name"] ?? '',
      content: json["content"] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "content": content,
      };
}

class WidgetTermsAndConditions {
  final String name;
  final String content;

  WidgetTermsAndConditions({
    required this.name,
    required this.content,
  });

  factory WidgetTermsAndConditions.fromJson(Map<String, dynamic> json) {
    return WidgetTermsAndConditions(
      name: json["name"] ?? '',
      content: json["content"] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "content": content,
      };
}

class AboutUs {
  final String name;
  final String content;

  AboutUs({
    required this.name,
    required this.content,
  });

  factory AboutUs.fromJson(Map<String, dynamic> json) {
    return AboutUs(
      name: json["name"] ?? '',
      content: json["content"] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "content": content,
      };
}

class TC {
  final String name;
  final String content;

  TC({
    required this.name,
    required this.content,
  });

  factory TC.fromJson(Map<String, dynamic> json) {
    return TC(
      name: json["name"] ?? '',
      content: json["content"] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "content": content,
      };
}

class LMClubRewards {
  final String name;
  final String content;

  LMClubRewards({
    required this.name,
    required this.content,
  });

  factory LMClubRewards.fromJson(Map<String, dynamic> json) {
    return LMClubRewards(
      name: json["name"] ?? '',
      content: json["content"] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "content": content,
      };
}

class CitiesData {
  CitiesData({this.id, this.cityName, this.isActive});

  int? id;
  String? cityName;
  bool? isActive;
  // String? createdOn;
  // String? modifiedOn;
  // String? createdBy;
  // String? modifiedBy;

  factory CitiesData.fromJson(Map<String, dynamic> json) => CitiesData(
        id: json["id"] ?? 0,
        cityName: json["city_name"] ?? '',
        // createdBy: json["created_by"],
        // modifiedBy: json["modified_by"],
        // createdOn: json["created_on"],
        // modifiedOn: json["modified_on"],
        isActive: json["is_active"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "city_name": cityName,
        "is_active": isActive,
        // "created_on": createdOn,
        // "modified_on": modifiedOn,
        // "created_by": createdBy,
        // "modified_by": modifiedBy
      };
}

class StatedData {
  StatedData({this.id, this.stateName, this.isActive});

  int? id;
  String? stateName;
  bool? isActive;
  // String? createdOn;
  // String? modifiedOn;
  // String? createdBy;
  // String? modifiedBy;

  factory StatedData.fromJson(Map<String, dynamic> json) => StatedData(
        id: json["id"] ?? 0,
        stateName: json["state_name"] ?? '',
        // createdBy: json["created_by"],
        // modifiedBy: json["modified_by"],
        // createdOn: json["created_on"],
        // modifiedOn: json["modified_on"],
        isActive: json["is_active"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "state_name": stateName,
        "is_active": isActive,
        // "created_on": createdOn,
        // "modified_on": modifiedOn,
        // "created_by": createdBy,
        // "modified_by": modifiedBy
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

class BusinessData {
  BusinessData({
    this.id,
    this.isActive,
    this.createdBy,
    this.createdOn,
    this.modifiedBy,
    this.modifiedOn,
    this.logoImage,
    this.businessPersonName,
    this.businessBy,
    this.businessEstablishedDate,
    this.businessType,
    this.location,
    this.operationHoursFrom,
    this.operationHoursTo,
    this.servicesOffered,
    this.typeOfBusiness,
  });

  int? id;

  bool? isActive;
  String? createdOn;
  String? modifiedOn;
  String? createdBy;
  String? modifiedBy;
  String? logoImage;
  String? businessPersonName;
  String? businessType;
  String? servicesOffered;
  String? businessBy;
  String? businessEstablishedDate;
  String? location;
  String? operationHoursFrom;
  String? operationHoursTo;
  String? typeOfBusiness;

  factory BusinessData.fromJson(Map<String, dynamic> json) => BusinessData(
      id: json["id"] ?? 0,
      createdBy: json["created_by"] ?? '',
      modifiedBy: json["modified_by"] ?? '',
      createdOn: json["created_on"] ?? '',
      modifiedOn: json["modified_on"] ?? '',
      isActive: json["is_active"] ?? false,
      businessPersonName: json["business_person_name"] ?? '',
      businessType: json["business_by"] ?? '',
      servicesOffered: json["services_offered"] ?? '',
      businessBy: json["business_by"] ?? '',
      businessEstablishedDate: json["business_established_date"] ?? '',
      location: json["location"] ?? '',
      operationHoursFrom: json["operation_hours_from"] ?? '',
      operationHoursTo: json["operation_hours_to"] ?? '',
      logoImage: json["logo_image_path"] ?? '',
      typeOfBusiness: json['type_of_business'] ?? '');

  Map<String, dynamic> toJson() => {
        "id": id,
        "is_active": isActive,
        "created_on": createdOn,
        "modified_on": modifiedOn,
        "created_by": createdBy,
        "modified_by": modifiedBy,
        "business_person_name": businessPersonName,
        "business_by": businessType,
        "services_offered": servicesOffered,
        "business_established_date": businessEstablishedDate,
        "location": location,
        "operation_hours_from": operationHoursFrom,
        "operation_hours_to": operationHoursTo,
        "logo_image_path": logoImage,
        "type_of_business": typeOfBusiness
      };
}
