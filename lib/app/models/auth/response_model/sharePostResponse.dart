import 'dart:convert';

SharePostResponse sharePostResponseFromJson(String str) =>
    SharePostResponse.fromJson(json.decode(str));

String sharePostResponseToJson(SharePostResponse data) =>
    json.encode(data.toJson());

class SharePostResponse {
  SharePostResponse({
    required this.status,
    required this.message,
  });

  bool status;
  String message;

  factory SharePostResponse.fromJson(Map<String, dynamic> json) =>
      SharePostResponse(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
