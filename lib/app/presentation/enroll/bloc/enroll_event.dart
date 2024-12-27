// enrollEventPage helps to track all users actions to make API calls.

import 'package:lm_club/app/models/auth/request_model/enroll_model.dart';
import 'package:lm_club/app/models/auth/request_model/forgot_password_model.dart';
import 'package:lm_club/app/models/auth/request_model/validateReferal_model.dart';
import 'package:lm_club/app/models/auth/response_model/cities_response.dart';
import 'package:lm_club/app/models/auth/response_model/state_response.dart';

abstract class EnrollEvent {
  EnrollEvent._();
  factory EnrollEvent.createUser(EnrollModel userData) => EnrollUser(userData);
  factory EnrollEvent.getplan(id) => GetPlan(id);
  factory EnrollEvent.getStates() => GetStates();
  factory EnrollEvent.getCities(StateData stateId) => GetCities(stateId);
  factory EnrollEvent.updateCity(CityData value) => UpdateCity(value);
  factory EnrollEvent.verifyOtp(ForgotPasswordModel model) => VerifyOtp(model);
  factory EnrollEvent.updateState(StateData id) => UpdateState(id);
  factory EnrollEvent.resendOtp(ForgotPasswordModel model) => ResendOtp(model);
  factory EnrollEvent.validateReferalCode(ValidateReferal model) =>
      ValidateReferalCode(model);

  factory EnrollEvent.clearValidationStatus() => ClearValidationStatus();
}

class EnrollUser extends EnrollEvent {
  final EnrollModel userData;
  EnrollUser(this.userData) : super._();
}

class GetPlan extends EnrollEvent {
  final String id;
  GetPlan(this.id) : super._();
}

class GetCities extends EnrollEvent {
  final StateData stateId;
  GetCities(this.stateId) : super._();
}

class GetStates extends EnrollEvent {
  // final StateData ;
  GetStates() : super._();
}

class ResendOtp extends EnrollEvent {
  final ForgotPasswordModel model;
  ResendOtp(this.model) : super._();
}

class UpdateCity extends EnrollEvent {
  final CityData value;
  UpdateCity(this.value) : super._();
}

class UpdateState extends EnrollEvent {
  final StateData id;
  UpdateState(this.id) : super._();
}

class VerifyOtp extends EnrollEvent {
  final ForgotPasswordModel model;
  VerifyOtp(this.model) : super._();
}

class ValidateReferalCode extends EnrollEvent {
  final ValidateReferal model;
  ValidateReferalCode(this.model) : super._();
}

class ClearValidationStatus extends EnrollEvent {
  ClearValidationStatus() : super._();
}
