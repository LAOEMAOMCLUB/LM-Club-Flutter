// profileEventPage helps to track all users actions to make API calls.

import 'dart:io';

import 'package:lm_club/app/models/auth/request_model/profile_req_model.dart';
import 'package:lm_club/app/models/auth/request_model/userDetails_model.dart';
import 'package:lm_club/app/models/auth/response_model/cities_response.dart';
import 'package:lm_club/app/models/auth/response_model/state_response.dart';
import 'package:lm_club/app/models/auth/response_model/user_details.dart';

abstract class ProfileEvent {
  ProfileEvent._();
  factory ProfileEvent.populateUserDetails(UserData userDetails) =>
      PopulateUserDetails(userDetails);
  factory ProfileEvent.getUserDetails(id) => GetUserDetails(id);
  factory ProfileEvent.uploadImage(File? path) => UploadImage(path);
  factory ProfileEvent.uploadProfileImage(ProfileRequestModel model) =>
      UploadProfileImage(model);
  factory ProfileEvent.getStates() => GetStates();
  factory ProfileEvent.getCities(StateData stateId) => GetCities(stateId);
  factory ProfileEvent.updateCity(CityData value) => UpdateCity(value);
  factory ProfileEvent.updateState(StateData id) => UpdateState(id);
  factory ProfileEvent.updateUserDetails(UserDetailsRequestModel request) =>
      UpdateUserDetails(request);
  factory ProfileEvent.generateAcceratedUrl(ProfileRequestModel model) =>
      GenerateAcceratedUrl(model);
  factory ProfileEvent.getUserPoints() => GetUserPoints();
  factory ProfileEvent.getReferalCode() => GetReferalCode();
}

class GetUserDetails extends ProfileEvent {
  final String id;
  GetUserDetails(this.id) : super._();
}

class UploadImage extends ProfileEvent {
  final File? path;
  UploadImage(this.path) : super._();
}

class UploadProfileImage extends ProfileEvent {
  final ProfileRequestModel model;
  UploadProfileImage(this.model) : super._();
}

class PopulateUserDetails extends ProfileEvent {
  final UserData userDetails;
  PopulateUserDetails(this.userDetails) : super._();
}

class GetCities extends ProfileEvent {
  final StateData stateId;
  GetCities(this.stateId) : super._();
}

class GetStates extends ProfileEvent {
  // final StateData ;
  GetStates() : super._();
}

class UpdateCity extends ProfileEvent {
  final CityData value;
  UpdateCity(this.value) : super._();
}

class UpdateState extends ProfileEvent {
  final StateData id;
  UpdateState(this.id) : super._();
}

class UpdateUserDetails extends ProfileEvent {
  final UserDetailsRequestModel request;
  UpdateUserDetails(this.request) : super._();
}

class GenerateAcceratedUrl extends ProfileEvent {
  final ProfileRequestModel model;
  GenerateAcceratedUrl(this.model) : super._();
}

class GetUserPoints extends ProfileEvent {
  GetUserPoints() : super._();
}

class GetReferalCode extends ProfileEvent {
  GetReferalCode() : super._();
}
