// profileBloc here we can make API calls by defining functions.

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:lm_club/app/domain/usecase/home/home_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lm_club/app/models/auth/request_model/profile_req_model.dart';
import 'package:lm_club/app/models/auth/request_model/userDetails_model.dart';
import 'package:lm_club/app/models/auth/response_model/cities_response.dart';
import 'package:lm_club/app/models/auth/response_model/state_response.dart';
import 'package:lm_club/app/models/auth/response_model/user_details.dart';
import 'package:lm_club/app/presentation/profile/profile_event.dart';
import 'package:lm_club/app/presentation/profile/profile_state.dart';
import 'package:lm_club/utils/string_extention.dart';
import 'package:lm_club/utils/globals.dart' as globals;
import 'package:intl/intl.dart';

@injectable
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final HomeUsecase _homeUsecase;
  List<CityData>? cities = [];
  List<StateData>? states = [];
  String stateId = '';
  String cityId = '';
  String imageUrl = '';
  StateData pbState = StateData.fromJson({});
  CityData pbCity = CityData.fromJson({});
  late UserDetailsRequestModel request;
  late ProfileRequestModel requestProfileImage;
  final profileFormKey = GlobalKey<FormState>();

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController referalCodeContoller = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController statesController = TextEditingController();
  TextEditingController zipcodeController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController planTypeController = TextEditingController();
  TextEditingController planValidityContoller = TextEditingController();

  File? imagePath;
  ProfileBloc(this._homeUsecase) : super(ProfileState.init(null)) {
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

    on<UpdateUserDetails>(
      (event, emit) async {
        emit(state.copyWith(
            isLoading: true, updateUserSuccess: false, error: ""));
        try {
          final response = await _homeUsecase.updateUserDetails(event.request);

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

    on<PopulateUserDetails>((event, emit) {
      UserData userDetails = event.userDetails;

      usernameController.text =
          userDetails.username!.capitalizeOnlyFirstLater();

      phoneController.text = userDetails.mobile!;
      emailController.text = userDetails.email!;
      if (userDetails.cities != null &&
          userDetails.cities!.cityName!.isNotEmpty &&
          cities!.isNotEmpty) {
        updateCity(cities!
            // ignore: unrelated_type_equality_checks
            .firstWhere((element) => element.city == userDetails.cities));
      }

      if (userDetails.states != null &&
          userDetails.states!.stateName!.isNotEmpty &&
          states!.isNotEmpty) {
        updateState(states!
            // ignore: unrelated_type_equality_checks
            .firstWhere((element) => element.name == userDetails.states));
      }
      cityController.text = userDetails.cities!.cityName ?? '';
      getCities(StateData.fromJson(userDetails.states?.toJson() ?? {}));
      statesController.text = userDetails.states!.stateName ?? '';
      streetController.text = userDetails.street.toString();
      zipcodeController.text = userDetails.zipcode.toString();
      planTypeController.text = userDetails.subscription.toString();
      if (userDetails.planValidity.toString().isNotEmpty) {
        String dateTimeString = userDetails.planValidity.toString();
        // Parse the DateTime string
        DateTime dateTime = DateTime.parse(dateTimeString);
        String formattedDate = DateFormat('MM-dd-yyyy').format(dateTime);
        planValidityContoller.text = formattedDate;
      }
    });

    on<GetStates>(
      (event, emit) async {
        emit(state.copyWith(isLoading: true, error: ""));
        try {
          final response = await _homeUsecase.getStates();
          emit(state.copyWith(
            error: "",
            isLoading: false,
            states: response.data,
            //  loggedIn: loggedIn,
          ));
        } catch (e) {
          if (kDebugMode) {
            print('Debug-- getStates ${e.toString()}');
          }
          if (e is DioException) {
            emit(state.copyWith(
              isLoading: false,
              states: null,
              error: e.errorMessage(),
              //loggedIn: loggedIn,
            ));
          } else {
            emit(state.copyWith(
              isLoading: false,
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
        emit(state.copyWith(isLoading: true, error: "", stateUpdated: false));
        try {
          final response = await _homeUsecase.getCities(event.stateId);

          cities = response.data;
          emit(state.copyWith(
            error: "",
            isLoading: false,
            cities: cities,
            //  loggedIn: loggedIn,
          ));
        } catch (e) {
          if (kDebugMode) {
            print('Debug-- FetchUserDetails ${e.toString()}');
          }
          if (e is DioException) {
            emit(state.copyWith(
              isLoading: false,
              cities: null,
              error: e.errorMessage(),
              //loggedIn: loggedIn,
            ));
          } else {
            emit(state.copyWith(
              isLoading: false,
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
        emit(state.copyWith(isLoading: true));
        cityController.text = '';
        emit(state.copyWith(
            isLoading: false,
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

    on<UploadProfileImage>(
      (event, emit) async {
        emit(state.copyWith(isLoading: true, error: "", isSuccesful: false));
        try {
          final response = await _homeUsecase.uploadProfileImage(event.model);
          getUserDetails(globals.userId);
          emit(state.copyWith(
            isLoading: false,
            error: "",
            isSuccesful: true,
            data: response,
          ));
        } on DioException catch (de) {
          emit(state.copyWith(
              isLoading: false, error: de.errorMessage(), isSuccesful: false));
        } catch (e) {
          emit(state.copyWith(
              isLoading: false, error: e.toString(), isSuccesful: false));
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
        uploadProfileImage();
      },
    );

    on<GetUserPoints>(
      (event, emit) async {
        emit(state.copyWith(isLoading: true, error: ""));
        try {
          final response = await _homeUsecase.getUserPoints();
          emit(state.copyWith(
              error: "",
              isLoading: false,
              userPoints: response.data!.myReferalPoints,
              beehivePoints: response.data!.mybeehivePoints,
              broadcastPoints: response.data!.myBroadcastPoints,
              pointsData: response.data
              //  loggedIn: loggedIn,
              ));
        } catch (e) {
          if (kDebugMode) {
            print('Debug-- FetchUserpoints ${e.toString()}');
          }
          if (e is DioException) {
            emit(state.copyWith(
              isLoading: false,
              userPoints: null,
              error: e.errorMessage(),
              //loggedIn: loggedIn,
            ));
          } else {
            emit(state.copyWith(
              isLoading: false,
              userPoints: null,
              error: e.toString(),
              //loggedIn: loggedIn,
            ));
          }
        }
      },
    );

    on<GetReferalCode>(
      (event, emit) async {
        emit(state.copyWith(isLoading: true, error: ""));
        try {
          final response = await _homeUsecase.getReferalCode();

          emit(state.copyWith(
            error: "",
            isLoading: false,
            refeeralCode: response.data,
            //  loggedIn: loggedIn,
          ));
        } catch (e) {
          if (kDebugMode) {
            print('Debug-- FetchrefeeralCodes ${e.toString()}');
          }
          if (e is DioException) {
            emit(state.copyWith(
              isLoading: false,
              refeeralCode: null,
              error: e.errorMessage(),
              //loggedIn: loggedIn,
            ));
          } else {
            emit(state.copyWith(
              isLoading: false,
              refeeralCode: null,
              error: e.toString(),
              //loggedIn: loggedIn,
            ));
          }
        }
      },
    );
  }

  void getReferalCode() async {
    add(ProfileEvent.getReferalCode());
  }

  void getUserPoints() async {
    add(ProfileEvent.getUserPoints());
  }

  void uploadProfileImage() {
    final model = ProfileRequestModel(image: imagePath);
    requestProfileImage = model;
    add(ProfileEvent.uploadProfileImage(model));
  }

  ProfileRequestModel uploadProfileRequest() {
    return requestProfileImage;
  }

  void getUserDetails(String id) async {
    add(ProfileEvent.getUserDetails(id));
  }

  uploadImage(imagePath) {
    add(ProfileEvent.uploadImage(imagePath));
  }

  populateUserDetails(UserData userDetails) {
    add(ProfileEvent.populateUserDetails(userDetails));
  }

  void getCities(StateData stateId) async {
    add(ProfileEvent.getCities(stateId));
  }

  void getStates() async {
    add(ProfileEvent.getStates());
  }

  updateCity(CityData city) {
    add(ProfileEvent.updateCity(city));
  }

  updateState(StateData name) {
    add(ProfileEvent.updateState(name));
  }

  void updateUserDetails(String image) {
    if (profileFormKey.currentState!.validate()) {
      final userDetails = UserDetailsRequestModel(
        username: usernameController.text,
        state: pbState.id,
        city: pbCity.id,
        zipcode: zipcodeController.text,
        street: streetController.text,
        // imagePath: image,
      );
      add(ProfileEvent.updateUserDetails(userDetails));
    }
  }

  void uploadImageProfile(String image) {
    final userDetails = UserDetailsRequestModel(
      imagePath: image,
    );
    add(ProfileEvent.updateUserDetails(userDetails));
  }
}
