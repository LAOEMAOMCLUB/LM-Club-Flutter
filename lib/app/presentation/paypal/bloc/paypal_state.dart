// paypalState used to display UI and manage Models.

import 'package:equatable/equatable.dart';
import 'package:lm_club/app/models/auth/response_model/checkout_response.dart';

class PaypalState extends Equatable {
  final bool? isSuccesful;
  final bool isLoading;
  final String? message;
  final CheckoutResponse? data;
  final String? error;

  const PaypalState({
    this.isSuccesful,
    required this.isLoading,
    this.message,
    this.error,
    this.data,
  });

  const PaypalState.init(this.data)
      : error = "",
        isLoading = false,
        isSuccesful = false,
        message = "";

  @override
  List<Object?> get props => [isSuccesful, isLoading, error, data, message];

  PaypalState copyWith({
    String? error,
    String? message,
    bool? isLoading,
    bool? isSuccesful,
    CheckoutResponse? data,
  }) {
    return PaypalState(
        isSuccesful: isSuccesful ?? this.isSuccesful,
        error: error ?? this.error,
        data: data ?? this.data,
        message: message ?? this.message,
        isLoading: isLoading ?? this.isLoading);
  }
}
