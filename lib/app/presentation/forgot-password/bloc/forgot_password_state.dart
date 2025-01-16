// forgotPasswordState used to display UI and manage Models.

import 'package:equatable/equatable.dart';
import 'package:lm_club/app/models/auth/response_model/forgot_password_response.dart';

class ForgotPasswordState extends Equatable {
  final bool? isSuccesful;
  final bool isLoading;
  final String? message;
  final ForgotPasswordResponse? data;
  final String? error;

  const ForgotPasswordState({
    this.isSuccesful,
    required this.isLoading,
    this.message,
    this.error,
    this.data,
  });

  const ForgotPasswordState.init(this.data)
      : error = "",
        isLoading = false,
        isSuccesful = false,
        message = "";

  @override
  List<Object?> get props => [isSuccesful, isLoading, error, data, message];

  ForgotPasswordState copyWith({
    String? error,
    String? message,
    bool? isLoading,
    bool? isSuccesful,
    ForgotPasswordResponse? data,
  }) {
    return ForgotPasswordState(
        isSuccesful: isSuccesful ?? this.isSuccesful,
        error: error ?? this.error,
        data: data ?? this.data,
        message: message ?? this.message,
        isLoading: isLoading ?? this.isLoading);
  }
}
