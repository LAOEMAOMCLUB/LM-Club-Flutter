// referEarnState used to display UI and manage Models.

import 'package:equatable/equatable.dart';
import 'package:lm_club/app/models/auth/response_model/referEarn_response.dart';
import 'package:lm_club/app/models/auth/response_model/referalCode_response.dart';

// ignore: must_be_immutable
class ReferEarnState extends Equatable {
  final bool? isSuccesful;
  final bool isLoading;

  final String? error;
  final ReferEarnResponse? data;
  final ReferEarnData? userPoints;
  ReferalCodeResponse? referalcodedata;
  ReferalCodeData? refeeralCode;

  ReferEarnState({
    required this.isSuccesful,
    required this.isLoading,
    this.error,
    this.userPoints,
    this.data,
    this.refeeralCode,
    this.referalcodedata,
  });

  ReferEarnState.init(this.data)
      : error = "",
        isLoading = false,
        userPoints = ReferEarnData.fromJson({}),
        refeeralCode = ReferalCodeData.fromJson({}),
        referalcodedata = ReferalCodeResponse.fromMap({}),
        isSuccesful = false;

  @override
  List<Object?> get props => [
        isSuccesful,
        isLoading,
        error,
        data,
        userPoints,
        refeeralCode,
        referalcodedata
      ];

  ReferEarnState copyWith(
      {String? error,
      bool? isLoading,
      bool? isSuccesful,
      ReferEarnResponse? data,
      ReferEarnData? userPoints,
      ReferalCodeResponse? referalcodedata,
      ReferalCodeData? refeeralCode}) {
    return ReferEarnState(
        isSuccesful: isSuccesful ?? this.isSuccesful,
        error: error ?? this.error,
        isLoading: isLoading ?? this.isLoading,
        data: data ?? this.data,
        userPoints: userPoints ?? this.userPoints,
        refeeralCode: refeeralCode ?? this.refeeralCode,
        referalcodedata: referalcodedata ?? this.referalcodedata);
  }
}
