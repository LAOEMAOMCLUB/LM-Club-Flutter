import 'package:json_annotation/json_annotation.dart';

import 'dart:convert';

SaveOrLikeModel saveOrLikeModelRequestFromJson(String str) =>
    SaveOrLikeModel.fromJson(json.decode(str));

String beehiveRequestToJson(SaveOrLikeModel data) => json.encode(data.toJson());

@JsonSerializable()
class SaveOrLikeModel {
  final int? id;
  final String? type;
  final bool? action;

  SaveOrLikeModel({this.id, this.action, this.type});

  factory SaveOrLikeModel.fromJson(Map<String, dynamic> json) =>
      SaveOrLikeModel(
        id: json["id"],
        action: json["action"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "action": action,
        "type": type,
      }..removeWhere((String key, dynamic value) => value == null);
}
