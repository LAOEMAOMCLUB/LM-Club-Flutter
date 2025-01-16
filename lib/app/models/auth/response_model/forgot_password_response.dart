import 'dart:convert';

ForgotPasswordResponse forgotPasswordResponseFromJson(String str) =>
    ForgotPasswordResponse.fromJson(json.decode(str));

String forgotPasswordResponseToJson(ForgotPasswordResponse data) =>
    json.encode(data.toJson());

class ForgotPasswordResponse {
  ForgotPasswordResponse({
    this.status,
    required this.message,
    this.mobile,
    this.otp,
    this.accessToken
  });

  bool? status;
  String message;
  String? mobile;
  int? otp;
  String? accessToken;

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) =>
      ForgotPasswordResponse(
          status: json["status"] ?? '',
          message: json["message"] ?? '',
          mobile: json["mobile"] ?? '',
          accessToken: json['accessToken'],
          otp: json["otp"]);

  Map<String, dynamic> toJson() =>
      {"status": status, "message": message, "mobile": mobile, "otp": otp,'accessToken':accessToken};
}
