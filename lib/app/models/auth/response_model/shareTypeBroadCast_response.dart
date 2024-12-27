import 'package:lm_club/utils/string_extention.dart';

class ShareTypeModel {
  final int? id;
  final String? rewardType;
  final String? points;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool? isActive;
  final dynamic createdBy;
  final DateTime? createdOn;
  final dynamic modifiedBy;
  final DateTime? modifiedOn;

  ShareTypeModel({
    required this.id,
    this.rewardType,
    this.points,
    this.startDate,
    this.endDate,
    this.isActive,
    this.createdBy,
    this.createdOn,
    this.modifiedBy,
    this.modifiedOn,
  });

  factory ShareTypeModel.fromJson(Map<String, dynamic> json) {
    return ShareTypeModel(
      id: json['id'],
      rewardType: json['reward_type'] ?? '',
      points: json['points'] ?? '',
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      isActive: json['is_active'],
      createdBy: json['created_by'],
      createdOn: DateTime.parse(json['created_on']),
      modifiedBy: json['modified_by'],
      modifiedOn: DateTime.parse(json['modified_on']),
    );
  }
}

class ShareTypeResponse {
  final bool status;
  final String message;
  final List<ShareTypeModel> data;

  ShareTypeResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ShareTypeResponse.fromJson(Map<String, dynamic> json) {
    return ShareTypeResponse(
      status: json['status'],
      message: json.extractMessage(),
      data: (json['data'] as List)
          .map((plan) => ShareTypeModel.fromJson(plan))
          .toList(),
    );
  }
}
