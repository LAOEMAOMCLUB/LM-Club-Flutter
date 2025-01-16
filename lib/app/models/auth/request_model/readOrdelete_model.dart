import 'package:json_annotation/json_annotation.dart';

import 'dart:convert';

ReadOrDeleteModel readOrDeleteModelRequestFromJson(String str) =>
    ReadOrDeleteModel.fromJson(json.decode(str));

String readOrDeleteModelRequestToJson(ReadOrDeleteModel data) =>
    json.encode(data.toJson());

@JsonSerializable()
class ReadOrDeleteModel {
  final int? widgetId;
  final String? actionType;
  final List<int>? ids;

  ReadOrDeleteModel({this.widgetId, this.actionType, this.ids});

  factory ReadOrDeleteModel.fromJson(Map<String, dynamic> json) =>
      ReadOrDeleteModel(
        widgetId: json["widgetId"],
        actionType: json["actionType"],
        ids: List<int>.from(json['ids'] ?? []),
      );

  Map<String, dynamic> toJson() => {
        "widgetId": widgetId,
        "actionType": actionType,
        "ids": ids,
      }..removeWhere((String key, dynamic value) => value == null);
}
