// extensionsPage every string extension defined here like (emailFormat,mobile US NumberFormat,error message,video and audio format)

import 'package:dio/dio.dart';

extension FormExtensions on String? {
  /// Validate fields like name,address,homeclub
  bool get isValidFormString => this!.isNotEmpty && this!.length > 2;

  /// Validate email field
  bool get isValidEmail =>
      this!.isValidFormString &&
      RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(this!);

  /// Validate password field
  bool get isValidPassword => RegExp(
          r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$")
      .hasMatch(this!);

  /// Validate phone field
  bool get isValidTelephone =>
      this!.isValidFormString &&
      RegExp(r'(^(?:[+0]9)?[0-9]{10,15}$)').hasMatch(this!);

  /// Validate only  number field
  bool get hasOnlyNumbers =>
      this!.isValidFormString && RegExp(r'^[0-9]+$').hasMatch(this!);

  /// Validate only  number field
  bool get hasOnlyChars => RegExp(r'^[a-zA-Z]+$').hasMatch(this!);

  num get toInt => num.parse(this!);
  String capitalizeOnlyFirstLater() {
    if (this!.trim().isEmpty) return "";

    return "${this?[0].toUpperCase()}${this?.substring(1)}";
  }

  bool get isVideo =>
      this == 'image/mp4' || this == 'image/mov' || this == 'image/avi';
}

extension Extensions on DioException {
  String errorMessage() {
    String errorMessage = '';
    if (response != null) {
      if (response!.data["message"] is String) {
        errorMessage = response!.data["message"];
      } else if (response!.data["message"] is Map<String, dynamic>) {
        errorMessage = response!.data["message"]["message"] ?? '';
      }
    } else {
      errorMessage = message ?? '';
    }
    return errorMessage;
  }
}

extension ResponseExtractor on Map<String, dynamic> {
  String extractMessage() {
    var obj = this;
    if (obj.containsKey('message')) {
      if (obj['message'] is String) {
        return obj['message'];
      } else if (obj['message'] is Map<String, dynamic>) {
        if (obj['message'].containsKey('detail')) {
          if (obj['message']['detail'] is String) {
            return obj['message']['detail'];
          } else {
            return '';
          }
        } else {
          return "";
        }
      } else {
        return '';
      }
    } else {
      return '';
    }
  }
}
