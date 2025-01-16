import 'package:json_annotation/json_annotation.dart';

import 'dart:convert';

SharePostModel sharePostModelRequestFromJson(String str) =>
    SharePostModel.fromJson(json.decode(str));

String sharePostModelRequestToJson(SharePostModel data) =>
    json.encode(data.toJson());

@JsonSerializable()
class SharePostModel {
  final int? postId;
  final String? modeOfShare;

  SharePostModel({this.postId, this.modeOfShare,});

  factory SharePostModel.fromJson(Map<String, dynamic> json) => SharePostModel(
        postId: json["postId"],
        modeOfShare: json["mode_of_share"],
        
      );

  Map<String, dynamic> toJson() => {
        "postId": postId,
        "mode_of_share": modeOfShare,
        
      }..removeWhere((String key, dynamic value) => value == null);
}
