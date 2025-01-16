// businessEnrollBlocPage here every logic and functionality defined to make API calls.

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lm_club/app/domain/usecase/home/home_usecase.dart';
import 'package:lm_club/app/models/auth/request_model/business_enroll_model.dart';
import 'package:lm_club/app/models/auth/request_model/forgot_password_model.dart';
import 'package:lm_club/app/models/auth/response_model/cities_response.dart';
import 'package:lm_club/app/models/auth/response_model/state_response.dart';
import 'package:lm_club/app/presentation/business_module/business/bloc/business_enroll_event.dart';
import 'package:lm_club/app/presentation/business_module/business/bloc/business_enroll_state.dart';
import 'package:lm_club/utils/string_extention.dart';
import 'package:lm_club/utils/globals.dart' as globals;

@injectable
class BusinessEnrollBloc
    extends Bloc<BusinessEnrollEvent, BusinessEnrollState> {
  final HomeUsecase _homeUsecase;
  final businessEnrollFormKey = GlobalKey<FormState>();
  late BusinessEnrollModel request;
  File? imagePath;
  final otpFormKey = GlobalKey<FormState>();
  late ForgotPasswordModel requestOtp;
  late ForgotPasswordModel request1;
  String stateId = '';
  String cityId = '';
  bool? validateSuccessStatus = false;
  List<CityData>? cities = [];
  StateData pbState = StateData.fromJson({});
  CityData pbCity = CityData.fromJson({});
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
  TextEditingController locationController = TextEditingController();
  TextEditingController logoController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController statesController = TextEditingController();
  TextEditingController zipcodeController = TextEditingController();
  TextEditingController otpController1 = TextEditingController();
  TextEditingController otpController4 = TextEditingController();
  TextEditingController otpController2 = TextEditingController();
  TextEditingController otpController3 = TextEditingController();
  TextEditingController otpController5 = TextEditingController();
  TextEditingController otpController6 = TextEditingController();
  BusinessEnrollBloc(this._homeUsecase)
      : super(BusinessEnrollState.init(null, null)) {
    on<BusinessEnrollUser>(
      (event, emit) async {
        emit(state.copyWith(isLoading: true, error: "", isSuccesful: false));
        try {
          final response = await _homeUsecase.businessEnroll(event.userData);
          if (response.status == true) {
            emit(state.copyWith(
              isLoading: false,
              error: "",
              isSuccesful: true,
              data: response,
            ));
          } else {
            emit(state.copyWith(
              isLoading: false,
              error: response.message,
              isSuccesful: false,
            ));
          }
        } on DioException catch (de) {
          emit(state.copyWith(
              isLoading: false, error: de.errorMessage(), isSuccesful: false));
        } catch (e) {
          emit(state.copyWith(
              isLoading: false, error: e.toString(), isSuccesful: false));
        }
      },
    );

    on<VerifyOtp>(
      (event, emit) async {
        emit(state.copyWith(isLoading: true, error: "", isSuccesfulOtp: false));
        try {
          final response = await _homeUsecase.verifyOtp(event.model);
          emit(state.copyWith(
              isLoading: false,
              error: "",
              isSuccesfulOtp: true,
              otpData: response,
              otpMessage: response.message));
        } on DioException catch (de) {
          emit(state.copyWith(
              isLoading: false,
              error: de.errorMessage(),
              isSuccesfulOtp: false));
        } catch (e) {
          emit(state.copyWith(
              isLoading: false, error: e.toString(), isSuccesfulOtp: false));
        }
      },
    );
    on<ResendOtp>(
      (event, emit) async {
        emit(state.copyWith(
            isLoading: true, error: "", isSuccesfulPassword: false));
        try {
          final response = await _homeUsecase.resendOtp(event.model);
          emit(state.copyWith(
            isLoading: false,
            error: "",
            isSuccesfulPassword: true,
            otpData: response,
          ));
        } on DioException catch (de) {
          emit(state.copyWith(
              isLoading: false,
              error: de.errorMessage(),
              isSuccesfulPassword: false));
        } catch (e) {
          emit(state.copyWith(
              isLoading: false,
              error: e.toString(),
              isSuccesfulPassword: false));
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
    on<GetPlan>(
      (event, emit) async {
        emit(state.copyWith(isLoading: true, error: ""));
        try {
          final response = await _homeUsecase.getplan(event.id);
          emit(state.copyWith(
            error: "",
            isLoading: false,
            choosePlanModal: response.data,
            //  loggedIn: loggedIn,
          ));
        } catch (e) {
          if (kDebugMode) {
            print('Debug-- FetchUserDetails ${e.toString()}');
          }
          if (e is DioException) {
            emit(state.copyWith(
              isLoading: false,
              choosePlanModal: null,
              error: e.errorMessage(),
              //loggedIn: loggedIn,
            ));
          } else {
            emit(state.copyWith(
              isLoading: false,
              choosePlanModal: null,
              error: e.toString(),
              //loggedIn: loggedIn,
            ));
          }
        }
      },
    );
  }
  void createBusinessUser(context, selectedBusinessType) {
    if (businessEnrollFormKey.currentState!.validate()) {
      if (confirmpasswordController.text == passwordController.text) {
        final userData = BusinessEnrollModel(
          mobile: phoneController.text,
          email: emailController.text,
          username: usernameController.text,
          businessName: businessNameController.text,
          password: passwordController.text,
          businessEstablishDate: businessEstablishDateController.text,
          businessBy: selectedBusinessType,
          businessType: businessTypeController.text,
          servicesOffered: servicesOfferedController.text,
          // location: locationController.text,
          street: streetController.text,
          zipcode: zipcodeController.text,
          state: pbState.id!,
          city: pbCity.id,
          operationHoursTo: operationHoursToController.text,
          operationHoursFrom: operationHoursFromController.text,
          file: imagePath,
        );
        request = userData;

        add(BusinessEnrollEvent.createBusinessUser(userData));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red, // Change background color of SnackBar
          content: Center(
            child: Text(
              'Please Enter required fields',
              style: TextStyle(
                color: Colors.white, // Change text color of SnackBar content
                fontSize: 16, // Change font size of SnackBar content
                // Add other text styles as needed
              ),
            ),
          ),
          duration: Duration(seconds: 3), // Adjust duration as needed
        ),
      );
    }
  }

  void verifyOtp(context) {
    String otpValueText = otpController1.text +
        otpController2.text +
        otpController3.text +
        otpController4.text +
        otpController5.text +
        otpController6.text;

    if (otpValueText.isEmpty) {
      // Show an error message for empty OTP value
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red, // Change background color of SnackBar
          content: Center(
            child: Text(
              'Please Enter Otp',
              style: TextStyle(
                color: Colors.white, // Change text color of SnackBar content
                fontSize: 16, // Change font size of SnackBar content
                // Add other text styles as needed
              ),
            ),
          ),
          duration: Duration(seconds: 3), // Adjust duration as needed
        ),
      );
      return;
    }

    int otpValue = int.parse(otpValueText);
    if (otpFormKey.currentState!.validate()) {
      final model = ForgotPasswordModel(mobile: globals.mobile, otp: otpValue);
      requestOtp = model;
      add(BusinessEnrollEvent.verifyOtp(model));
    }
  }

  void resendOtp() {
    //  if (webFormKey.currentState!.validate()) {
    final model = ForgotPasswordModel(
      mobile: globals.mobile,
    );
    request1 = model;

    add(BusinessEnrollEvent.resendOtp(model));
    // }
  }

  ForgotPasswordModel forgotPasswordRequest() {
    return request1;
  }

  uploadImage(imagePath) {
    add(BusinessEnrollEvent.uploadImage(imagePath));
  }

  void getCities(StateData stateId) async {
    add(BusinessEnrollEvent.getCities(stateId));
  }

  void getStates() async {
    add(BusinessEnrollEvent.getStates());
  }

  void getplan(String id) async {
    add(BusinessEnrollEvent.getplan(id));
  }

  updateCity(CityData city) {
    add(BusinessEnrollEvent.updateCity(city));
  }

  updateState(StateData name) {
    add(BusinessEnrollEvent.updateState(name));
  }

  disposeControllers() {
    emailController.clear();
    phoneController.clear();
    usernameController.clear();
    passwordController.clear();
    businessByController.clear();
    businessEstablishDateController.clear();
    businessNameController.clear();
    businessTypeController.clear();
    operationHoursFromController.clear();
    operationHoursToController.clear();
    servicesOfferedController.clear();
    locationController.clear();
    confirmpasswordController.clear();
    logoController.clear();
    cityController.clear();

    otpController1.clear();
    otpController2.clear();
    otpController3.clear();
    otpController4.clear();
    otpController5.clear();
    otpController6.clear();
    businessEnrollFormKey.currentState?.reset();
  }
}
