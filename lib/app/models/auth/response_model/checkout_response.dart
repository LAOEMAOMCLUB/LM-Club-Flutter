import 'dart:convert';

CheckoutResponse checkoutResponseFromJson(String str) =>
    CheckoutResponse.fromJson(json.decode(str));

String checkoutResponseToJson(CheckoutResponse data) =>
    json.encode(data.toJson());

class CheckoutResponse {
  CheckoutResponse({
    this.status,
     this.message,
    this.amount,
    this.nonce,
     this.token,
  });

  bool? status;
  String? message;
  String? amount;
  String? nonce;
  tokenData? token;


  factory CheckoutResponse.fromJson(Map<String, dynamic> json) =>
      CheckoutResponse(
          status: json["status"] ?? '',
          message: json["message"] ?? '',
          amount: json["amount"] ?? '',
          nonce: json["nonce"] ?? '',
           token: tokenData.fromJson(json["token"] ?? {}),);

  Map<String, dynamic> toJson() =>
      {"status": status, "message": message, "amount": amount, "nonce": nonce,"accessToken": token!.toJson()};
}

class tokenData{
  tokenData(
      {this.accessToken,
     });
     String? accessToken;
     factory tokenData.fromJson(Map<String, dynamic> json) => tokenData(
        accessToken: json["access_token"] ?? '',
      
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
       
      };
}