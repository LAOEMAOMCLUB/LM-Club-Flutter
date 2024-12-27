

import 'package:lm_club/utils/string_extention.dart';

class GeneratedAcceleratedResponse {
  final bool status;
  final String message;
  final String? data;

  GeneratedAcceleratedResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory GeneratedAcceleratedResponse.fromMap(Map<String, dynamic> map) {
    return GeneratedAcceleratedResponse(
      status: map['status'] ?? false,
      message: map.extractMessage(),
      data: map['data'] ?? '',
    );
  }
}

