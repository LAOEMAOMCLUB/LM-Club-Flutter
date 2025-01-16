import 'dart:convert';

import 'package:lm_club/utils/string_extention.dart';

StateData statesResponseFromJson(String str) =>
    StateData.fromJson(json.decode(str));

String statesResponseToJson(StateData data) => json.encode(data.toJson());

class StateResponse {
  bool status;
  String message;
  List<StateData> data;
  int count;

  StateResponse({
    required this.status,
    required this.message,
    required this.data,
    required this.count,
  });

  factory StateResponse.fromJson(Map<String, dynamic> json) {
    return StateResponse(
      status: json['status'],
      message: json.extractMessage(),
      data: List<StateData>.from(json["data"] != null
          ? json['data'].map((x) => StateData.fromJson(x))
          : {}),
      count: json["count"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': List<dynamic>.from(data.map((x) => x.toJson())),
      'count': count
    };
  }
}

class StateData {
  int? id;
  String? name;
  String? code;
  bool? activeStatus;
  String? createdAt;
  String? updatedAt;
  int? v;

  StateData({
     this.id,
     this.name,
     this.code,
     this.activeStatus,
     this.createdAt,
     this.updatedAt,
    this.v,
  });

  factory StateData.fromJson(Map<String, dynamic> json) {
    return StateData(
      id: json['id'],
      name: json['state_name'],
      code: json['code'],
      activeStatus: json['activeStatus'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'state_name': name,
      'code': code,
      'activeStatus': activeStatus,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}
