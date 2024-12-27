import 'dart:convert';

UploadBroadCastResponse uploadBroadCastResponseFromJson(String str) =>
    UploadBroadCastResponse.fromJson(json.decode(str));

String uploadBroadCastResponseToJson(UploadBroadCastResponse data) =>
    json.encode(data.toJson());

class UploadBroadCastResponse {
  UploadBroadCastResponse({
    required this.status,
    required this.message,
  });

  bool status;
  String message;

  factory UploadBroadCastResponse.fromJson(Map<String, dynamic> json) =>
      UploadBroadCastResponse(
        status: json["status"] ?? false,
        message: json["message"]?? '',
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
