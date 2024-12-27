part of 'coupons_model.dart';

CouponsModel _$CouponsModelFromJson(Map<String, dynamic> json) => CouponsModel(
    company_name: json['company_name'] as String,
    description: json['description'] as String,
    image: ['image'] as String,
    category: ['category'] as String,
    company_offer: ['company_offer'] as String,
    referal_code: ['referal_code'] as String,
    valid_upto: ['valid_upto'] as String);

Map<String, dynamic> _$CouponsModelToJson(CouponsModel instance) =>
    <String, dynamic>{
      'company_name': instance.company_name,
      'description': instance.description,
      'image': instance.image,
      'category': instance.category,
      'company_offer': instance.company_offer,
      'referal_code': instance.referal_code,
      'valid_upto': instance.valid_upto
    };
