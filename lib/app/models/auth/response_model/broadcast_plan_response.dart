import 'dart:convert';

BroadcastPlanResponse broadcastPlanResponseFromJson(String str) =>
    BroadcastPlanResponse.fromJson(json.decode(str));

String broadcastPlanResponseToJson(BroadcastPlanResponse data) =>
    json.encode(data.toJson());

class BroadcastPlanResponse {
  BroadcastPlanResponse({
    this.status,
    required this.message,
    required this.data,
  });

  bool? status;
  String? message;
  List<BroadcastPlan> data;

  factory BroadcastPlanResponse.fromJson(Map<String, dynamic> json) =>
      BroadcastPlanResponse(
        status: json["status"],
        message: json["message"],
        data: List<BroadcastPlan>.from(json["data"] != null
            ? json['data'].map((x) => BroadcastPlan.fromJson(x))
            : []),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class BroadcastPlan {
  BroadcastPlan({
    this.id,
    this.flag,
    this.description,
    this.key,
    this.isActive,
  });

  int? id;
  String? flag;
  String? description;
  String? key;
  bool? isActive;

  factory BroadcastPlan.fromJson(Map<String, dynamic> json) => BroadcastPlan(
        id: json["id"],
        flag: json["flag"] ?? '',
        description: json["description"] ?? '',
        key: json['key'] ?? '',
        isActive: json['is_active'] ?? false
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "flag": flag,
        "description": description,
        "key": key,
        "isActive" : isActive
      };
}
