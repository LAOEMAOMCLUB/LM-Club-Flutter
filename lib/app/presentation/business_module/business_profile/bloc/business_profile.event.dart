// businessProfileEventPage helps to track all users actions to make API calls.

import 'dart:io';
import 'package:lm_club/app/models/auth/request_model/business_user_request.dart';
import 'package:lm_club/app/models/auth/response_model/cities_response.dart';
import 'package:lm_club/app/models/auth/response_model/state_response.dart';
import 'package:lm_club/app/models/auth/response_model/user_details.dart';

abstract class BusinessProfileEvent {
  BusinessProfileEvent._();
  factory BusinessProfileEvent.getUserDetails(id) => GetUserDetails(id);
  factory BusinessProfileEvent.populateUserDetails(UserData userDetails) =>
      PopulateUserDetails(userDetails);
  factory BusinessProfileEvent.uploadImage(File? path) => UploadImage(path);
  factory BusinessProfileEvent.updateUserDetails(
          BusinessUserDetailsRequestModel request) =>
      UpdateUserDetails(request);
  factory BusinessProfileEvent.getCities(StateData stateId) =>
      GetCities(stateId);
  factory BusinessProfileEvent.updateCity(CityData value) => UpdateCity(value);

  factory BusinessProfileEvent.updateState(StateData id) => UpdateState(id);
  factory BusinessProfileEvent.getStates() => GetStates();
}

class GetUserDetails extends BusinessProfileEvent {
  final String id;
  GetUserDetails(this.id) : super._();
}

class PopulateUserDetails extends BusinessProfileEvent {
  final UserData userDetails;
  PopulateUserDetails(this.userDetails) : super._();
}

class UploadImage extends BusinessProfileEvent {
  final File? path;
  UploadImage(this.path) : super._();
}

class UpdateUserDetails extends BusinessProfileEvent {
  final BusinessUserDetailsRequestModel request;
  UpdateUserDetails(this.request) : super._();
}

class GetCities extends BusinessProfileEvent {
  final StateData stateId;
  GetCities(this.stateId) : super._();
}

class GetStates extends BusinessProfileEvent {
  // final StateData ;
  GetStates() : super._();
}

class UpdateCity extends BusinessProfileEvent {
  final CityData value;
  UpdateCity(this.value) : super._();
}

class UpdateState extends BusinessProfileEvent {
  final StateData id;
  UpdateState(this.id) : super._();
}
