import 'dart:convert';

SaveOrLikePostResponse saveOrLikePostResponseFromJson(String str) =>
    SaveOrLikePostResponse.fromJson(json.decode(str));

String saveOrLikePostResponseToJson(SaveOrLikePostResponse data) =>
    json.encode(data.toJson());

class SaveOrLikePostResponse {
  SaveOrLikePostResponse({
    required this.status,
    required this.message,
  });

  bool status;
  String message;

  factory SaveOrLikePostResponse.fromJson(Map<String, dynamic> json) =>
      SaveOrLikePostResponse(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
