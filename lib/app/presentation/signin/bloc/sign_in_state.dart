// signInState used to display UI and manage Models.

import 'package:equatable/equatable.dart';
import 'package:lm_club/app/models/auth/response_model/login_response.dart';

class SignInState extends Equatable {
  final bool? loginSuccesful;
  final bool isLoading;
  final LoginResponseModel? data;
  final String? error;
  final String? message;
  const SignInState(
      {this.loginSuccesful,
      required this.isLoading,
      this.error,
      this.data,
      this.message});

  const SignInState.init(this.data)
      : error = "",
        isLoading = false,
        loginSuccesful = false,
        message = '';

  @override
  List<Object?> get props => [loginSuccesful, isLoading, error, data, message];

  SignInState copyWith({
    String? error,
    bool? isLoading,
    bool? loginSuccesful,
    LoginResponseModel? data,
    String? message,
  }) {
    return SignInState(
        loginSuccesful: loginSuccesful ?? this.loginSuccesful,
        error: error ?? this.error,
        data: data ?? this.data,
        message: message ?? this.message,
        isLoading: isLoading ?? this.isLoading);
  }
}
