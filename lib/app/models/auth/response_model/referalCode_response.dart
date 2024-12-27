import 'dart:convert';

import 'package:lm_club/utils/string_extention.dart';

ReferalCodeData planResponseFromJson(String str) =>
    ReferalCodeData.fromJson(json.decode(str));

class ReferalCodeResponse {
  final bool status;
  final String message;
  final ReferalCodeData? data;

  ReferalCodeResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory ReferalCodeResponse.fromMap(Map<String, dynamic> map) {
    return ReferalCodeResponse(
      status: map['status'] ?? false,
      message: map.extractMessage(),
      data: ReferalCodeData.fromJson(map['data'] ?? {}),
    );
  }
}

class ReferalCodeData {
  ReferalCodeData(
      {this.id,
      this.referalCode,
      this.isActive,
      this.bonusPoints,
      this.referalCount,
      // this.createdBy,
      // this.createdOn,
      // this.modifiedBy,
      // this.modifiedOn,
      // this.validFrom,
      // this.validUpto
      });

  int? id;
  String? referalCode;
  bool? isActive;
  int? bonusPoints;
  int? referalCount;
  // String? createdOn;
  // String? modifiedOn;
  // String? createdBy;
  // String? modifiedBy;
  // String?validFrom;
  // String? validUpto;

  factory ReferalCodeData.fromJson(Map<String, dynamic> json) => ReferalCodeData(
        id: json["id"] ?? 0,
        referalCode: json["referral_code"] ?? '',
        referalCount: json["referralCount"] ?? 0,
        bonusPoints: json["bonusPoints"] ?? 0,
        // createdBy: json["created_by"],
        // modifiedBy: json["modified_by"],
        // createdOn: json["created_on"],
        // modifiedOn: json["modified_on"],
         isActive: json["is_active"] ?? false,
        //  validFrom: json["valid_from"],
        //   validUpto: json["valid_upto"],

      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "referral_code": referalCode,
        "is_active": isActive,
        "referralCount" : referalCount,
        "bonusPoints" : bonusPoints
        // "created_on": createdOn,
        // "modified_on": modifiedOn,
        // "created_by": createdBy,
        // "modified_by": modifiedBy,
        // "valid_from": validFrom,
        // "valid_upto": validUpto
      };
}