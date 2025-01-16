import 'dart:convert';

ChoosePlanModal planResponseFromJson(String str) =>
    ChoosePlanModal.fromMap(json.decode(str));

String planResponseToJson(ChoosePlanModal data) => json.encode(data.toMap());

class ChoosePlanResponse {
  ChoosePlanResponse({
    this.status,
    required this.message,
    required this.data,
  });

  bool? status;
  String message;
  List<ChoosePlanModal> data;

  factory ChoosePlanResponse.fromMap(Map<String, dynamic> json) =>
      ChoosePlanResponse(
        status: json["status"],
        message: json["message"],
        data: List<ChoosePlanModal>.from(json["data"] != null
            ? json['data'].map((x) => ChoosePlanModal.fromMap(x))
            : {}),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

class ChoosePlanModal {
  ChoosePlanModal({
    required this.id,
    this.plan,
    this.registrationAmount,
    this.planAmount,
    this.terms,
    this.widgets,
    this.createdBy,
    this.createdOn,
    this.planAmountString,
    this.modifiedBy,
    this.modifiedOn,
    this.description,
    this.imagePath,
    this.isActive,
  });

  late int id;
  late String? plan;
  late String? registrationAmount;
  late int? planAmount;
  late String? planAmountString;

  late String? terms;
  late List<WidgetIdModel>? widgets;
  String? createdOn;
  String? modifiedOn;
  String? createdBy;
  String? modifiedBy;
  String? description;
  String? imagePath;
  bool? isActive;

  factory ChoosePlanModal.fromMap(Map<String, dynamic> map) => ChoosePlanModal(
        id: map["id"] ?? 0,
        plan: map["plan"] ?? '',
        registrationAmount: map["renewalRegistrationAmount"] ?? '',
        planAmount: map["plan_amount"],
        planAmountString: map["planAmount"],
        terms: map["terms"] ?? '',
        createdBy: map["created_by"],
        modifiedBy: map["modified_by"],
        createdOn: map["created_on"],
        modifiedOn: map["modified_on"],
        imagePath: map["image_path"],
        description: map["description"],
        isActive: map["is_active"],
        widgets: map["widgets"] != null
            ? List<WidgetIdModel>.from(
                map["widgets"].map((x) => WidgetIdModel.fromMap(x)),
              )
            : [],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "plan": plan,
        "renewalRegistrationAmount": registrationAmount,
        "plan_amount": planAmount,
        "planAmount":planAmountString,
        "terms": terms,
        "widgets": List<dynamic>.from(widgets!.map((x) => x.toMap())),
        "created_on": createdOn,
        "modified_on": modifiedOn,
        "created_by": createdBy,
        "modified_by": modifiedBy,
        "is_active": isActive,
        "description": description,
        "imagePath": imagePath
      };
}

// class WidgetModel {
//   WidgetModel({
//      this.id,
//      this.planId,
//      this.widgetId,
//   });

//   late String? id;
//   late String? planId;
//   late WidgetIdModel? widgetId;

//   factory WidgetModel.fromMap(Map<String, dynamic> map) => WidgetModel(
//         id: map["_id"] ?? 0,
//         planId: map["planId"] ?? '',
//         widgetId: WidgetIdModel.fromMap(map["widgetId"] ?? {}),
//       );

//   Map<String, dynamic> toMap() => {
//         "id": id,
//         "planId": planId,
//         "widgetId": widgetId!.toMap(),
//       };
// }

class WidgetIdModel {
  WidgetIdModel({
    this.id,
    this.name,
    this.activeStatus,
  });

  late int? id;
  late String? name;
  late bool? activeStatus;

  factory WidgetIdModel.fromMap(Map<String, dynamic> map) => WidgetIdModel(
        id: map["id"],
        name: map["widget_name"] ?? '',
        activeStatus: map["activeStatus"] ?? false,
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "widget_name": name,
        "activeStatus": activeStatus,
      };
}
