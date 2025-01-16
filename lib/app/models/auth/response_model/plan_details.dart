import 'dart:convert';

import 'package:lm_club/utils/string_extention.dart';

PlanDetailsData planResponseFromJson(String str) =>
    PlanDetailsData.fromMap(json.decode(str));

class PlanDetailsResponse {
  final bool status;
  final String message;
  final PlanDetailsData data;

  PlanDetailsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory PlanDetailsResponse.fromMap(Map<String, dynamic> map) {
    return PlanDetailsResponse(
      status: map['status'] ?? false,
      message: map.extractMessage(),
      data: PlanDetailsData.fromMap(map['data'] ?? {}),
    );
  }
}

class PlanDetailsData {
  final int? id;
  final String? plan;
  final String? registrationAmount;
  final int? planAmount;
  final String? planAmountString;
  final String? terms;
  final List<WidgetIdDetails>? widgets;
  String? createdOn;
  String? modifiedOn;
  String? createdBy;
  String? modifiedBy;
  String? description;
  String? imagePath;
  bool? isActive;
  bool? isVerifiedUser;
  TC? tc;

  PlanDetailsData(
      {this.id,
      this.plan,
      this.registrationAmount,
      this.planAmount,
      this.planAmountString,
      this.terms,
      this.widgets,
      this.createdBy,
      this.createdOn,
      this.modifiedBy,
      this.modifiedOn,
      this.description,
      this.imagePath,
      this.isActive,
      this.tc,
      this.isVerifiedUser});

  factory PlanDetailsData.fromMap(Map<String, dynamic> map) => PlanDetailsData(
        id: map["id"] ?? 0,
        plan: map["plan"] ?? '',
        registrationAmount: map["renewalRegistrationAmount"] ?? '',
        planAmount: map["plan_amount"] ?? 0,
        planAmountString: map["planAmount"] ?? '',
        terms: map["terms"] ?? '',
        createdBy: map["created_by"] ?? '',
        modifiedBy: map["modified_by"] ?? '',
        createdOn: map["created_on"] ?? '',
        modifiedOn: map["modified_on"] ?? '',
        imagePath: map["image_path"] ?? '',
        description: map["description"] ?? '',
        isActive: map["is_active"],
        isVerifiedUser: map["is_verified_user"],
        tc: TC.fromMap(map["T&C"] ?? {}),
        widgets: map["widgets"] != null
            ? List<WidgetIdDetails>.from(
                map["widgets"].map((x) => WidgetIdDetails.fromMap(x)),
              )
            : [],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "plan": plan,
        "renewalRegistrationAmount": registrationAmount,
        "plan_amount": planAmount,
        "planAmount": planAmountString,
        "terms": terms,
        "widgets": List<dynamic>.from(widgets!.map((x) => x.toMap())),
        "created_on": createdOn,
        "modified_on": modifiedOn,
        "created_by": createdBy,
        "modified_by": modifiedBy,
        "is_active": isActive,
        "description": description,
        "image_path": imagePath,
        "T&C": tc!.toMap(),
      };
}

class WidgetDetails {
  final String id;
  final String planId;
  final WidgetIdDetails widgetId;

  WidgetDetails({
    required this.id,
    required this.planId,
    required this.widgetId,
  });

  factory WidgetDetails.fromMap(Map<String, dynamic> map) {
    return WidgetDetails(
      id: map['_id'] ?? '',
      planId: map['planId'] ?? '',
      widgetId: WidgetIdDetails.fromMap(map['widgetId'] ?? {}),
    );
  }
}

// class WidgetIdDetails {
//   final String id;
//   final String name;
//   final bool activeStatus;

//   WidgetIdDetails({
//     required this.id,
//     required this.name,
//     required this.activeStatus,
//   });

//   factory WidgetIdDetails.fromMap(Map<String, dynamic> map) {
//     return WidgetIdDetails(
//       id: map['_id'] ?? '',
//       name: map['name'] ?? '',
//       activeStatus: map['activeStatus'] ?? false,
//     );
//   }
//}
class WidgetIdDetails {
  WidgetIdDetails({
    this.id,
    this.name,
    this.activeStatus,
    this.description,
  });

  late int? id;
  late String? name;
  late bool? activeStatus;
  String? description;

  factory WidgetIdDetails.fromMap(Map<String, dynamic> map) => WidgetIdDetails(
        id: map["id"] ?? 0,
        name: map["widget_name"] ?? '',
        description: map["description"] ?? '',
        activeStatus: map["activeStatus"] ?? false,
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "widget_name": name,
        "activeStatus": activeStatus,
        "description": description
      };
}

class TC {
  final String name;
  final String content;

  TC({
    required this.name,
    required this.content,
  });

  factory TC.fromMap(Map<String, dynamic> map) => TC(
        name: map["name"] ?? '',
        content: map["content"] ?? '',
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "content": content,
      };
}
