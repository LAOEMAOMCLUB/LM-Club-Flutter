import 'dart:convert';

AccountDeleteResponse responseFromJson(String str) =>
    AccountDeleteResponse.fromJson(json.decode(str));

String responseToson(AccountDeleteResponse data) => json.encode(data.toJson());

class AccountDeleteResponse {
  AccountDeleteResponse({
    this.status,
    this.message,
  });

  bool? status;
  String? message;

  factory AccountDeleteResponse.fromJson(Map<String, dynamic> json) =>
      AccountDeleteResponse(
        status: json["status"] ?? false,
        message: json["message"] ?? '',
      );

  Map<String, dynamic> toJson() => {"status": status, "message": message};
}
