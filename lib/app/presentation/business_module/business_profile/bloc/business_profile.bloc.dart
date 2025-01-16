//businessProfileBlocPage here every logic and functionality defined to make API calls.

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:lm_club/app/domain/usecase/home/home_usecase.dart';
import 'package:lm_club/app/models/auth/request_model/business_user_request.dart';
import 'package:lm_club/app/models/auth/response_model/cities_response.dart';
import 'package:lm_club/app/models/auth/response_model/state_response.dart';
import 'package:lm_club/app/models/auth/response_model/user_details.dart';
import 'package:lm_club/app/presentation/business_module/business_profile/bloc/business_profile.event.dart';
import 'package:lm_club/app/presentation/business_module/business_profile/bloc/business_profile.state.dart';
import 'package:lm_club/utils/string_extention.dart';

@injectable
class BusinessProfileBloc
    extends Bloc<BusinessProfileEvent, BusinessProfileState> {
  final HomeUsecase _homeUsecase;
  File? imagePath;
  String stateId = '';
  String cityId = '';
  bool? validateSuccessStatus = false;
  List<CityData>? cities = [];
  List<StateData>? states = [];
  StateData pbState = StateData.fromJson({});
  CityData pbCity = CityData.fromJson({});
  final businessProfileFormKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController businessNameController = TextEditingController();
  TextEditingController businessByController = TextEditingController();
  TextEditingController businessTypeController = TextEditingController();
  TextEditingController servicesOfferedController = TextEditingController();
  TextEditingController operationHoursFromController = TextEditingController();
  TextEditingController operationHoursToController = TextEditingController();
  TextEditingController businessEstablishDateController =
      TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController statesController = TextEditingController();
  TextEditingController zipcodeController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController logoController = TextEditingController();

  BusinessProfileBloc(this._homeUsecase)
      : super(BusinessProfileState.init(null)) {
    on<GetUserDetails>(
      (event, emit) async {
        emit(state.copyWith(isLoading: true, error: ""));
        try {
          final response = await _homeUsecase.getUserDetails(event.id);
          populateUserDetails(response.data!);
          emit(state.copyWith(
            error: "",
            isLoading: false,
            userDetails: response.data,
            //  loggedIn: loggedIn,
          ));
        } catch (e) {
          if (kDebugMode) {
            print('Debug-- FetchUserDetails ${e.toString()}');
          }
          if (e is DioException) {
            emit(state.copyWith(
              isLoading: false,
              userDetails: null,
              error: e.errorMessage(),
              //loggedIn: loggedIn,
            ));
          } else {
            emit(state.copyWith(
              isLoading: false,
              userDetails: null,
              error: e.toString(),
              //loggedIn: loggedIn,
            ));
          }
        }
      },
    );

    on<UploadImage>(
      (event, emit) {
        imagePath = event.path;
        // uploadProfileImage();
        emit(state.copyWith(isLoading: true));
        emit(state.copyWith(
          isLoading: false,
          imagePath: event.path,
          error: "",
        ));
      },
    );
    on<UpdateUserDetails>(
      (event, emit) async {
        emit(state.copyWith(
            isLoading: true, updateUserSuccess: false, error: ""));
        try {
          final response =
              await _homeUsecase.updateBusinessUserDetails(event.request);

          emit(state.copyWith(
              error: "",
              isLoading: false,
              userDetails: response.data,
              updateUserSuccess: true,
              message: response.message
              //  loggedIn: loggedIn,
              ));
        } catch (e) {
          if (kDebugMode) {
            print('Debug-- FetchUserDetails ${e.toString()}');
          }
          if (e is DioException) {
            emit(state.copyWith(
              isLoading: false,
              userDetails: null,
              updateUserSuccess: false,
              error: e.errorMessage(),
              //loggedIn: loggedIn,
            ));
          } else {
            emit(state.copyWith(
              isLoading: false,
              userDetails: null,
              updateUserSuccess: false,
              error: e.toString(),
              //loggedIn: loggedIn,
            ));
          }
        }
      },
    );
    on<GetStates>(
      (event, emit) async {
        emit(state.copyWith(error: ""));
        try {
          final response = await _homeUsecase.getStates();
          emit(state.copyWith(
            error: "",

            states: response.data,
            //  loggedIn: loggedIn,
          ));
        } catch (e) {
          if (kDebugMode) {
            print('Debug-- getStates ${e.toString()}');
          }
          if (e is DioException) {
            emit(state.copyWith(
              states: null,
              error: e.errorMessage(),
              //loggedIn: loggedIn,
            ));
          } else {
            emit(state.copyWith(
              states: null,
              error: e.toString(),
              //loggedIn: loggedIn,
            ));
          }
        }
      },
    );

    on<GetCities>(
      (event, emit) async {
        emit(state.copyWith(error: "", stateUpdated: false));
        try {
          final response = await _homeUsecase.getCities(event.stateId);

          cities = response.data;
          emit(state.copyWith(
            error: "",

            cities: cities,
            //  loggedIn: loggedIn,
          ));
        } catch (e) {
          if (kDebugMode) {
            print('Debug-- FetchUserDetails ${e.toString()}');
          }
          if (e is DioException) {
            emit(state.copyWith(
              cities: null,
              error: e.errorMessage(),
              //loggedIn: loggedIn,
            ));
          } else {
            emit(state.copyWith(
              cities: null,
              error: e.toString(),
              //loggedIn: loggedIn,
            ));
          }
        }
      },
    );

    on<UpdateState>(
      (event, emit) async {
        pbState = StateData.fromJson({});
        pbState = event.id;
        cityId = '';
        emit(state.copyWith());
        cityController.text = '';
        emit(state.copyWith(
            stateId: pbState,
            cityId: CityData.fromJson({}),
            error: "",
            stateUpdated: true));
        // getCities(pbState);
      },
    );

    on<UpdateCity>(
      (event, emit) {
        pbCity = CityData.fromJson({});
        pbCity = event.value;

        emit(state.copyWith());
        emit(state.copyWith(
          cityId: pbCity,
          error: "",
        ));
      },
    );
    on<PopulateUserDetails>((event, emit) {
      UserData userDetails = event.userDetails;

      usernameController.text = userDetails.username!;
      phoneController.text = userDetails.mobile!;
      emailController.text = userDetails.email!;
      businessNameController.text =
          userDetails.businessDetails!.businessPersonName!;
      businessByController.text = userDetails.businessDetails!.businessBy!;
      businessTypeController.text =
          userDetails.businessDetails!.typeOfBusiness!;
      servicesOfferedController.text =
          userDetails.businessDetails!.servicesOffered!;

      operationHoursFromController.text = convertTo12HourFormat(
          userDetails.businessDetails!.operationHoursFrom!);
      operationHoursToController.text =
          convertTo12HourFormat(userDetails.businessDetails!.operationHoursTo!);
      businessEstablishDateController.text =
          userDetails.businessDetails!.businessEstablishedDate!;
      if (userDetails.cities != null &&
          userDetails.cities!.cityName!.isNotEmpty &&
          cities!.isNotEmpty) {
        updateCity(cities!
            .firstWhere((element) => element.city == userDetails.cities));
      }

      if (userDetails.states != null &&
          userDetails.states!.stateName!.isNotEmpty &&
          states!.isNotEmpty) {
        updateState(states!
            .firstWhere((element) => element.name == userDetails.states));
      }
      //  locationController.text = userDetails.businessDetails!.location!;
      logoController.text = userDetails.businessDetails!.logoImage!;
      cityController.text = userDetails.cities!.cityName ?? '';
      statesController.text = userDetails.states!.stateName ?? '';
      streetController.text = userDetails.street.toString();
      zipcodeController.text = userDetails.zipcode.toString();
      getCities(StateData.fromJson(userDetails.states?.toJson() ?? {}));
    });
  }
  String convertTo12HourFormat(String time) {
    DateTime dateTime = DateFormat('HH:mm').parse(time);
    String formattedTime = DateFormat('hh:mm a').format(dateTime);
    return formattedTime;
  }

  void getUserDetails(String id) async {
    add(BusinessProfileEvent.getUserDetails(id));
  }

  populateUserDetails(UserData userDetails) {
    add(BusinessProfileEvent.populateUserDetails(userDetails));
  }

  uploadImage(imagePath) {
    add(BusinessProfileEvent.uploadImage(imagePath));
  }

  void getCities(StateData stateId) async {
    add(BusinessProfileEvent.getCities(stateId));
  }

  void getStates() async {
    add(BusinessProfileEvent.getStates());
  }

  updateCity(CityData city) {
    add(BusinessProfileEvent.updateCity(city));
  }

  updateState(StateData name) {
    add(BusinessProfileEvent.updateState(name));
  }

  void updateBusinessUserDetails() {
    //if (businessProfileFormKey.currentState!.validate()) {
    final userDetails = BusinessUserDetailsRequestModel(
      username: usernameController.text,
      businessName: businessNameController.text,
      password: passwordController.text,
      businessEstablishDate: businessEstablishDateController.text,
      businessBy: businessByController.text,
      businessType: businessTypeController.text,
      servicesOffered: servicesOfferedController.text,
      street: streetController.text,
      zipcode: zipcodeController.text,
      state: pbState.id,
      city: pbCity.id,
      //location: locationController.text,
      operationHoursTo: operationHoursToController.text,
      operationHoursFrom: operationHoursFromController.text,
      // file: imagePath,
    );
    add(BusinessProfileEvent.updateUserDetails(userDetails));
  }
  // }
}
