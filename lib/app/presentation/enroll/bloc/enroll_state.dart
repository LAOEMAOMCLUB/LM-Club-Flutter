// enrollStatePage used to display UI and manage Models.

import 'package:equatable/equatable.dart';
import 'package:lm_club/app/models/auth/response_model/enroll_response.dart';
import 'package:lm_club/app/models/auth/response_model/forgot_password_response.dart';
import 'package:lm_club/app/models/auth/response_model/plan_details.dart';
import '../../../models/auth/response_model/cities_response.dart';
import '../../../models/auth/response_model/state_response.dart';

// ignore: must_be_immutable
class EnrollState extends Equatable {
  final bool signUpSuccesful;
  final bool? isSuccesful;
  final bool isLoading;
  final EnrollResModel? data;
  final String? error;
  final PlanDetailsData? choosePlanModal;

  // final CitiesResponse? citesData;
  final List<StateData> states;
  final ForgotPasswordResponse? otpData;
  final String? message;
  final List<CityData>? cities;
  final StateData? stateId;
  final bool stateUpdated;
  final bool? isSuccesfulPassword;
  final CityData? cityId;
  String? otpMessage;
  bool? validateSuccessful;
  bool? validateSuccessStatus;
  String? validateSuccessfulMessage;
  EnrollState(
      {required this.signUpSuccesful,
      this.isSuccesful,
      required this.isLoading,
      this.error,
      this.data,
      this.otpData,
      this.stateId,
      required this.stateUpdated,
      this.cityId,
      this.message,
      this.isSuccesfulPassword,
      this.validateSuccessful,
      this.validateSuccessfulMessage,
      required this.choosePlanModal,
      // this.citesData,
      this.validateSuccessStatus,
      this.otpMessage,
      required this.states,
      required this.cities});

  EnrollState.init(this.data, this.otpData)
      : error = "",
        isLoading = false,
        isSuccesful = false,
        signUpSuccesful = false,
        message = "",
        validateSuccessfulMessage = '',
        validateSuccessful = false,
        states = [],
        stateId = StateData.fromJson({}),
        stateUpdated = false,
        cityId = CityData.fromJson({}),
        cities = [],
        otpMessage = '',
        validateSuccessStatus = false,
        isSuccesfulPassword = false,
        choosePlanModal = PlanDetailsData.fromMap({});

  @override
  List<Object?> get props => [
        signUpSuccesful,
        isLoading,
        isSuccesful,
        error,
        message,
        data,
        choosePlanModal,
        validateSuccessStatus,
        otpData,
        validateSuccessfulMessage,
        isSuccesfulPassword,
        states,
        cities,
        otpMessage,
        stateId,
        stateUpdated,
        validateSuccessful,
        cityId
        // citesData
      ];

  EnrollState copyWith(
      {String? error,
      bool? isLoading,
      bool? signUpSuccesful,
      bool? isSuccesful,
      bool? validateSuccessful,
      EnrollResModel? data,
      String? validateSuccessfulMessage,
      String? message,
      bool? validateSuccessStatus,
      StateData? stateId,
      bool? isSuccesfulPassword,
      bool? stateUpdated,
      CityData? cityId,
      PlanDetailsData? choosePlanModal,
      ForgotPasswordResponse? otpData,
      List<CityData>? cities,
      String? otpMessage,
      List<StateData>? states}) {
    return EnrollState(
        signUpSuccesful: signUpSuccesful ?? this.signUpSuccesful,
        isSuccesful: isSuccesful ?? this.isSuccesful,
        error: error ?? this.error,
        data: data ?? this.data,
        otpData: otpData ?? this.otpData,
        isLoading: isLoading ?? this.isLoading,
        states: states ?? this.states,
        message: message ?? this.message,
        cities: cities ?? this.cities,
        stateId: stateId ?? this.stateId,
        validateSuccessful: validateSuccessful ?? this.validateSuccessful,
        otpMessage: otpMessage ?? this.otpMessage,
        isSuccesfulPassword: isSuccesfulPassword ?? this.isSuccesfulPassword,
        stateUpdated: stateUpdated ?? this.stateUpdated,
        cityId: cityId ?? this.cityId,
        validateSuccessStatus:
            validateSuccessStatus ?? this.validateSuccessStatus,
        // citesData: citesData ?? this.citesData,
        choosePlanModal: choosePlanModal ?? this.choosePlanModal);
  }
}
