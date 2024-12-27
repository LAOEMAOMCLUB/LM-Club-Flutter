// businessEnrollStatePage used to display UI and manage Models.

import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:lm_club/app/models/auth/response_model/cities_response.dart';
import 'package:lm_club/app/models/auth/response_model/enroll_response.dart';
import 'package:lm_club/app/models/auth/response_model/forgot_password_response.dart';
import 'package:lm_club/app/models/auth/response_model/state_response.dart';

import '../../../../models/auth/response_model/plan_details.dart';

// ignore: must_be_immutable
class BusinessEnrollState extends Equatable {
  final bool? isSuccesful;
  final bool isLoading;
  final bool? isSuccesfulOtp;
  final EnrollResModel? data;
  final String? error;
  final String? message;
  File? imagePath;
  final ForgotPasswordResponse? otpData;
  PlanDetailsData? choosePlanModal;
  String? otpMessage;
  final bool? isSuccesfulPassword;
  final List<StateData> states;
  final List<CityData>? cities;
  final StateData? stateId;
  final bool stateUpdated;

  final CityData? cityId;
  BusinessEnrollState(
      {required this.isSuccesful,
      required this.isLoading,
      this.error,
      this.imagePath,
      this.data,
      this.otpData,
      this.otpMessage,
      this.message,
      this.isSuccesfulPassword,
      this.isSuccesfulOtp,
      this.cities,
      this.cityId,
      this.stateId,
      this.choosePlanModal,
      required this.stateUpdated,
      required this.states});

  BusinessEnrollState.init(this.data, this.otpData)
      : error = "",
        isLoading = false,
        imagePath = null,
        message = '',
        isSuccesfulPassword = false,
        isSuccesfulOtp = false,
        states = [],
        stateId = StateData.fromJson({}),
        stateUpdated = false,
        cityId = CityData.fromJson({}),
        cities = [],
        isSuccesful = false,
        choosePlanModal = PlanDetailsData.fromMap({});

  @override
  List<Object?> get props => [
        isSuccesful,
        isLoading,
        error,
        data,
        imagePath,
        otpData,
        otpMessage,
        message,
        isSuccesfulPassword,
        isSuccesfulOtp,
        states,
        cities,
        stateId,
        stateUpdated,
        cityId,
        choosePlanModal,
      ];

  BusinessEnrollState copyWith(
      {String? error,
      bool? isLoading,
      bool? isSuccesful,
      File? imagePath,
      final EnrollResModel? data,
      final ForgotPasswordResponse? otpData,
      final String? otpMessage,
      final bool? isSuccesfulPassword,
      final bool? isSuccesfulOtp,
      final String? message,
      StateData? stateId,
      PlanDetailsData? choosePlanModal,
      bool? stateUpdated,
      CityData? cityId,
      List<CityData>? cities,
      List<StateData>? states}) {
    return BusinessEnrollState(
        isSuccesful: isSuccesful ?? this.isSuccesful,
        error: error ?? this.error,
        isLoading: isLoading ?? this.isLoading,
        data: data ?? this.data,
        imagePath: imagePath ?? this.imagePath,
        otpData: otpData ?? this.otpData,
        message: message ?? this.message,
        isSuccesfulPassword: isSuccesfulPassword ?? this.isSuccesfulPassword,
        otpMessage: otpMessage ?? this.otpMessage,
        isSuccesfulOtp: isSuccesfulOtp ?? this.isSuccesfulOtp,
        states: states ?? this.states,
        stateUpdated: stateUpdated ?? this.stateUpdated,
        cityId: cityId ?? this.cityId,
        cities: cities ?? this.cities,
        stateId: stateId ?? this.stateId,
        choosePlanModal: choosePlanModal ?? this.choosePlanModal);
  }
}
