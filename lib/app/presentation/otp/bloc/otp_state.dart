// // otpStatePage used to display UI and manage Models.

import 'package:equatable/equatable.dart';

import 'package:lm_club/app/models/auth/response_model/forgot_password_response.dart';

class OtpState extends Equatable {
  final bool? isSuccesful;
  final bool isLoading;
  final bool? isSuccesfulPassword;
  final String? error;

  final ForgotPasswordResponse? otpData;
  final ForgotPasswordResponse? data;
  final String? message;

  const OtpState(
      {this.isSuccesful,
      this.isSuccesfulPassword,
      required this.isLoading,
      this.error,
      this.otpData,
      this.message,
      this.data});

  const OtpState.init(this.otpData, this.data)
      : error = "",
        isLoading = false,
        isSuccesful = false,
        isSuccesfulPassword = false,
        message = "";

  @override
  List<Object?> get props => [
        isLoading,
        isSuccesful,
        error,
        message,
        otpData,
        data,
        isSuccesfulPassword,
      ];

  OtpState copyWith({
    String? error,
    bool? isLoading,
    bool? isSuccesful,
    bool? isSuccesfulPassword,
    String? message,
    ForgotPasswordResponse? otpData,
    ForgotPasswordResponse? data,
  }) {
    return OtpState(
        isSuccesful: isSuccesful ?? this.isSuccesful,
        error: error ?? this.error,
        otpData: otpData ?? this.otpData,
        isLoading: isLoading ?? this.isLoading,
        message: message ?? this.message,
        isSuccesfulPassword: isSuccesfulPassword ?? this.isSuccesfulPassword,
        data: data ?? this.otpData);
  }
}
