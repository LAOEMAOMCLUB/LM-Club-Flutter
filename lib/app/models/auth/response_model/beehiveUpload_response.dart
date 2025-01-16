import 'dart:convert';

BeehiveUploadResponse beehiveUploadResponseFromJson(String str) =>
    BeehiveUploadResponse.fromJson(json.decode(str));

String beehiveUploadResponseToJson(BeehiveUploadResponse data) =>
    json.encode(data.toJson());

class BeehiveUploadResponse {
  BeehiveUploadResponse({
    this.status,
    this.message,
  });

  bool? status;
  String? message;

  factory BeehiveUploadResponse.fromJson(Map<String, dynamic> json) =>
      BeehiveUploadResponse(
        status: json["status"] ?? false,
        message: json["message"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
