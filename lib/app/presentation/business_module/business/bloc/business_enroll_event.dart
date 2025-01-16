// businessEnrollEventPage helps to track all users actions to make API calls.

import 'dart:io';
import 'package:lm_club/app/models/auth/request_model/business_enroll_model.dart';
import 'package:lm_club/app/models/auth/request_model/forgot_password_model.dart';
import 'package:lm_club/app/models/auth/response_model/cities_response.dart';
import 'package:lm_club/app/models/auth/response_model/state_response.dart';

abstract class BusinessEnrollEvent {
  BusinessEnrollEvent._();
  factory BusinessEnrollEvent.createBusinessUser(
          BusinessEnrollModel userData) =>
      BusinessEnrollUser(userData);
  factory BusinessEnrollEvent.getplan(id) => GetPlan(id);
  factory BusinessEnrollEvent.uploadImage(File? path) => UploadImage(path);
  factory BusinessEnrollEvent.verifyOtp(ForgotPasswordModel model) =>
      VerifyOtp(model);
  factory BusinessEnrollEvent.resendOtp(ForgotPasswordModel model) =>
      ResendOtp(model);
  factory BusinessEnrollEvent.getCities(StateData stateId) =>
      GetCities(stateId);
  factory BusinessEnrollEvent.updateCity(CityData value) => UpdateCity(value);

  factory BusinessEnrollEvent.updateState(StateData id) => UpdateState(id);
  factory BusinessEnrollEvent.getStates() => GetStates();
}

class BusinessEnrollUser extends BusinessEnrollEvent {
  final BusinessEnrollModel userData;
  BusinessEnrollUser(this.userData) : super._();
}

class UploadImage extends BusinessEnrollEvent {
  final File? path;
  UploadImage(this.path) : super._();
}

class VerifyOtp extends BusinessEnrollEvent {
  final ForgotPasswordModel model;
  VerifyOtp(this.model) : super._();
}

class ResendOtp extends BusinessEnrollEvent {
  final ForgotPasswordModel model;
  ResendOtp(this.model) : super._();
}

class GetCities extends BusinessEnrollEvent {
  final StateData stateId;
  GetCities(this.stateId) : super._();
}

class GetStates extends BusinessEnrollEvent {
  // final StateData ;
  GetStates() : super._();
}

class UpdateCity extends BusinessEnrollEvent {
  final CityData value;
  UpdateCity(this.value) : super._();
}

class UpdateState extends BusinessEnrollEvent {
  final StateData id;
  UpdateState(this.id) : super._();
}

class GetPlan extends BusinessEnrollEvent {
  final String id;
  GetPlan(this.id) : super._();
}
