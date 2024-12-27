// businessProfileStatePage used to display UI and manage Models.

import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:lm_club/app/models/auth/response_model/cities_response.dart';
import 'package:lm_club/app/models/auth/response_model/state_response.dart';
import 'package:lm_club/app/models/auth/response_model/user_details.dart';

// ignore: must_be_immutable
class BusinessProfileState extends Equatable {
  final bool? isSuccesful;
  final bool isLoading;
  final UserData? userDetails;
  final String? error;
  final String? message;
  final UserDetailsResponse? data;
  File? imagePath;
  final bool? updateUserSuccess;
  final List<StateData>? states;
  final List<CityData>? cities;
  final StateData? stateId;
  final bool stateUpdated;

  final CityData? cityId;
  BusinessProfileState(
      {required this.isSuccesful,
      required this.isLoading,
      this.error,
      this.userDetails,
      this.data,
      this.imagePath,
      this.message,
      this.updateUserSuccess,
      this.cities,
      this.cityId,
      this.stateId,
      required this.stateUpdated,
      required this.states});

  BusinessProfileState.init(this.data)
      : error = "",
        isLoading = false,
        userDetails = UserData.fromJson({}),
        imagePath = null,
        updateUserSuccess = false,
        message = '',
        states = [],
        stateId = StateData.fromJson({}),
        stateUpdated = false,
        cityId = CityData.fromJson({}),
        cities = [],
        isSuccesful = false;

  @override
  List<Object?> get props => [
        isSuccesful,
        isLoading,
        error,
        data,
        userDetails,
        imagePath,
        updateUserSuccess,
        message,
        states,
        cities,
        stateId,
        stateUpdated,
        cityId
      ];

  BusinessProfileState copyWith(
      {String? error,
      bool? isLoading,
      bool? isSuccesful,
      final UserData? userDetails,
      File? imagePath,
      final UserDetailsResponse? data,
      final String? message,
      final bool? updateUserSuccess,
      StateData? stateId,
      bool? stateUpdated,
      CityData? cityId,
      List<CityData>? cities,
      List<StateData>? states}) {
    return BusinessProfileState(
      isSuccesful: isSuccesful ?? this.isSuccesful,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      userDetails: userDetails ?? this.userDetails,
      imagePath: imagePath ?? this.imagePath,
      updateUserSuccess: updateUserSuccess ?? this.updateUserSuccess,
      message: message ?? this.message,
      states: states ?? this.states,
      stateUpdated: stateUpdated ?? this.stateUpdated,
      cityId: cityId ?? this.cityId,
      cities: cities ?? this.cities,
      stateId: stateId ?? this.stateId,
    );
  }
}
