
import 'package:json_annotation/json_annotation.dart';

import 'dart:convert';

ValidateReferal validateReferalRequestFromJson(String str) =>
    ValidateReferal.fromJson(json.decode(str));

String validateReferalRequestToJson(ValidateReferal data) => json.encode(data.toJson());

@JsonSerializable()
class ValidateReferal {
  final String? referralCode;
 

  ValidateReferal({
    this.referralCode,
   
  });

  factory ValidateReferal.fromJson(Map<String, dynamic> json) => ValidateReferal(
    
        referralCode: json["referralCode"],
     
      );

  Map<String, dynamic> toJson() => {
       
        "referralCode": referralCode,
       
      }..removeWhere((String key, dynamic value) => value == null);
}
