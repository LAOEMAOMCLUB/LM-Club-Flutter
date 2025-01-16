// profileStatePage used to display UI and manage Models.

import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:lm_club/app/models/auth/response_model/cities_response.dart';
import 'package:lm_club/app/models/auth/response_model/referEarn_response.dart';
import 'package:lm_club/app/models/auth/response_model/referalCode_response.dart';
import 'package:lm_club/app/models/auth/response_model/state_response.dart';

import '../../models/auth/response_model/user_details.dart';

// ignore: must_be_immutable
class ProfileState extends Equatable {
  final bool? isSuccesful;
  final bool isLoading;
  final UserDetailsResponse? data;
  final String? error;
  final UserData? userDetails;
  final String? generatedResponse;
  File? imagePath;
  String? message;
  bool? updateUserSuccess;
  final List<CityData>? cities;
  final List<StateData>? states;
  final StateData? stateId;
  final bool? stateUpdated;
  final CityData? cityId;
  final ReferEarnData? pointsData;
  final ReferalCodeData? refeeralCode;
  final List<ReferEarnDataPoints>? userPoints;
  final List<ReferEarnDataBeehivePoints>? beehivePoints;
  final List<ReferEarnDataBroadcastPoints>? broadcastPoints;
  ProfileState({
    this.isSuccesful,
    required this.isLoading,
    this.error,
    this.data,
    this.updateUserSuccess,
    this.imagePath,
    this.cities,
    this.states,
    this.stateUpdated,
    this.message,
    this.stateId,
    this.cityId,
    this.generatedResponse,
    required this.userDetails,
    this.userPoints,
    this.beehivePoints,
    this.broadcastPoints,
    this.pointsData,
    this.refeeralCode,
  });

  ProfileState.init(this.data)
      : error = "",
        isLoading = false,
        isSuccesful = false,
        stateUpdated = false,
        imagePath = null,
        cities = [],
        states = [],
        message = '',
        generatedResponse = '',
        updateUserSuccess = false,
        stateId = StateData.fromJson({}),
        cityId = CityData.fromJson({}),
        userDetails = UserData.fromJson({}),
        refeeralCode = ReferalCodeData.fromJson({}),
        userPoints = [],
        beehivePoints = [],
        broadcastPoints = [],
        pointsData = ReferEarnData.fromJson({});
  @override
  List<Object?> get props => [
        isSuccesful,
        isLoading,
        error,
        imagePath,
        data,
        cities,
        message,
        states,
        stateId,
        stateUpdated,
        cityId,
        userDetails,
        generatedResponse,
        updateUserSuccess,
        userPoints,
        beehivePoints,
        broadcastPoints,
        pointsData,
        refeeralCode,
      ];

  ProfileState copyWith(
      {String? error,
      bool? isLoading,
      bool? isSuccesful,
      File? imagePath,
      UserDetailsResponse? data,
      StateData? stateId,
      bool? stateUpdated,
      CityData? cityId,
      String? message,
      String? generatedResponse,
      bool? updateUserSuccess,
      List<StateData>? states,
      List<CityData>? cities,
      UserData? userDetails,
      ReferEarnData? pointsData,
      List<ReferEarnDataPoints>? userPoints,
      List<ReferEarnDataBeehivePoints>? beehivePoints,
      List<ReferEarnDataBroadcastPoints>? broadcastPoints,
      ReferalCodeData? refeeralCode}) {
    return ProfileState(
        isSuccesful: isSuccesful ?? this.isSuccesful,
        error: error ?? this.error,
        imagePath: imagePath ?? this.imagePath,
        data: data ?? this.data,
        isLoading: isLoading ?? this.isLoading,
        stateId: stateId ?? this.stateId,
        stateUpdated: stateUpdated ?? this.stateUpdated,
        cityId: cityId ?? this.cityId,
        cities: cities ?? this.cities,
        states: states ?? this.states,
        generatedResponse: this.generatedResponse ?? this.generatedResponse,
        message: message ?? this.message,
        updateUserSuccess: updateUserSuccess ?? this.updateUserSuccess,
        userDetails: userDetails ?? this.userDetails,
        pointsData: pointsData ?? this.pointsData,
        userPoints: userPoints ?? this.userPoints,
        beehivePoints: beehivePoints ?? this.beehivePoints,
        broadcastPoints: broadcastPoints ?? this.broadcastPoints,
        refeeralCode: refeeralCode ?? this.refeeralCode);
  }
}
