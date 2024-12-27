import 'dart:convert';


Coupons couponsResponseFromJson(String str) =>
    Coupons.fromJson(json.decode(str));

String ouponsResponseToJson(Coupons data) =>
    json.encode(data.toJson());

class CouponsResponse {
  CouponsResponse({
    this.status,
    required this.message,
    required this.data,
  });

  bool? status;
  String message;
  List<Coupons> data;

  factory CouponsResponse.fromJson(Map<String, dynamic> json) =>
      CouponsResponse(
        status: json["status"],
        message: json["message"],
        data: List<Coupons>.from(json["data"] != null
            ? json['data'].map((x) => Coupons.fromJson(x))
            : {}),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Coupons {
  Coupons({
required this.companyName,
      required this.description,
      required this.image,
      required this.category,
      required this.companyOffer,
      required this.referralCode,
      required this.validUpto,
  });
 final String companyName;
  final String description;
  final String companyOffer;
  final String validUpto;
  final String category;
  final String referralCode;
  final String image;
  factory Coupons.fromJson(Map<String, dynamic> json) =>
      Coupons(
         image: json["image"],
        category: json["category"],
        companyName: json["company_name"],
        companyOffer: json["company_offer"],
        referralCode: json["referal_code"],
        validUpto: json["valid_upto"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() =>
      {"image": image,
        "category": category,
        "description": description,
          "company_name":companyName,
        "company_offer":companyOffer,
        "referal_code":referralCode,
        "valid_upto":validUpto,};
}
