// enrollBloc here every logic and functionality defined to make API calls.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:lm_club/app/domain/usecase/home/home_usecase.dart';
import 'package:lm_club/app/models/auth/request_model/enroll_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:lm_club/app/models/auth/request_model/forgot_password_model.dart';
import 'package:lm_club/app/models/auth/request_model/validateReferal_model.dart';
import 'package:lm_club/app/models/auth/response_model/cities_response.dart';
import 'package:lm_club/app/models/auth/response_model/state_response.dart';
import 'package:lm_club/app/presentation/enroll/bloc/enroll_event.dart';
import 'package:lm_club/app/presentation/enroll/bloc/enroll_state.dart';
import 'package:lm_club/utils/string_extention.dart';
import 'package:lm_club/utils/globals.dart' as globals;

@injectable
class EnrollBloc extends Bloc<EnrollEvent, EnrollState> {
  final enrollFormKey = GlobalKey<FormState>();
  final otpFormKey = GlobalKey<FormState>();
  final HomeUsecase _homeUsecase;
  String stateId = '';
  String cityId = '';
  bool? validateSuccessStatus = false;
  List<CityData>? cities = [];
  StateData pbState = StateData.fromJson({});
  CityData pbCity = CityData.fromJson({});
  final int planIdint = int.parse(globals.planId.trim());

  EnrollBloc(this._homeUsecase) : super(EnrollState.init(null, null)) {
    on<EnrollUser>(
      (event, emit) async {
        emit(state.copyWith(
            isLoading: true,
            error: "",
            message: '',
            signUpSuccesful: false,
            isSuccesful: false));
        try {
          final response = await _homeUsecase.enroll(event.userData);
          // forgotPassword();
          emit(state.copyWith(
            isLoading: false,
            error: "",
            message: response.message,
            signUpSuccesful: true,
            data: response,
          ));
        } on DioException catch (de) {
          emit(state.copyWith(
              isLoading: false,
              error: de.errorMessage(),
              signUpSuccesful: false));
        } catch (e) {
          emit(state.copyWith(
              isLoading: false, error: e.toString(), signUpSuccesful: false));
        }
      },
    );

    on<ValidateReferalCode>(
      (event, emit) async {
        emit(state.copyWith(
            isLoading: true, error: "", validateSuccessful: false));
        try {
          final response =
              await _homeUsecase.validateReferalCode(event.model.toJson());
          // forgotPassword();
          emit(state.copyWith(
            isLoading: false,
            error: "",
            validateSuccessful: true,
            validateSuccessStatus: response.status,
            validateSuccessfulMessage: response.message,
          ));
        } on DioException catch (de) {
          emit(state.copyWith(
              isLoading: false,
              error: de.errorMessage(),
              validateSuccessful: false));
        } catch (e) {
          emit(state.copyWith(
              isLoading: false,
              error: e.toString(),
              validateSuccessful: false));
        }
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

    on<VerifyOtp>(
      (event, emit) async {
        emit(state.copyWith(
            isLoading: true,
            error: "",
            isSuccesful: false,
            isSuccesfulPassword: false,
            signUpSuccesful: false));
        try {
          final response = await _homeUsecase.verifyOtp(event.model);
          emit(state.copyWith(
              isLoading: false,
              error: "",
              isSuccesful: true,
              otpData: response,
              otpMessage: response.message));
        } on DioException catch (de) {
          emit(state.copyWith(
              isLoading: false, error: de.errorMessage(), isSuccesful: false));
        } catch (e) {
          emit(state.copyWith(
              isLoading: false, error: e.toString(), isSuccesful: false));
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

    on<ClearValidationStatus>((event, emit) {
      validateSuccessStatus = null;
      emit(state.copyWith());
      emit(state.copyWith(
        validateSuccessStatus: null,
        error: "",
      ));
    });
  }

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
  TextEditingController pinController = TextEditingController();
  FocusNode focusNode = FocusNode();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // TextEditingController planeController = TextEditingController();
  late EnrollModel request;
  late ForgotPasswordModel request1;
  late ForgotPasswordModel requestOtp;
  late ValidateReferal referalCodeRequest;
  void verifyOtp(context) {
    String otpValueText = pinController.text;

    if (otpValueText.isEmpty || otpValueText.length != 6) {
      // Show an error message for empty OTP value
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red, // Change background color of SnackBar
          content: Center(
            child: Text(
              otpValueText.isEmpty
                  ? 'Please Enter Otp'
                  : 'Please Enter 6 digit Otp',
              style: const TextStyle(
                color: Colors.white, // Change text color of SnackBar content
                fontSize: 16, // Change font size of SnackBar content
                // Add other text styles as needed
              ),
            ),
          ),
          duration: const Duration(seconds: 3), // Adjust duration as needed
        ),
      );
      return;
    }

    int otpValue = int.parse(otpValueText);
    if (otpFormKey.currentState!.validate()) {
      final model = ForgotPasswordModel(mobile: globals.mobile, otp: otpValue);
      requestOtp = model;
      add(EnrollEvent.verifyOtp(model));
    }
  }

  void clearValidationStatus() {
    // Set the validation status to null or any appropriate default value
    // For example:

    add(EnrollEvent.clearValidationStatus());
  }

  void createUser(context, plan) {
    if (enrollFormKey.currentState!.validate()) {
      if (confirmpasswordController.text == passwordController.text) {
        if (referalCodeContoller.text.isNotEmpty &&
            state.validateSuccessful != true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor:
                  Colors.red, // Change background color of SnackBar
              content: Center(
                child: Text(
                  'Please Enter valid referal code',
                  style: TextStyle(
                    color:
                        Colors.white, // Change text color of SnackBar content
                    fontSize: 16, // Change font size of SnackBar content
                    // Add other text styles as needed
                  ),
                ),
              ),
              duration: Duration(seconds: 3), // Adjust duration as needed
            ),
          );
        } else if (referalCodeContoller.text.isEmpty ||
            (referalCodeContoller.text.isNotEmpty &&
                state.validateSuccessful == true)) {
          //  final int cityIdInt = int.parse(cityId.trim());
          final userData = EnrollModel(
              email: emailController.text,
              mobile: phoneController.text,
              username: usernameController.text,
              street: streetController.text,
              zipcode: zipcodeController.text,
              state: pbState.id!,
              referalCode: referalCodeContoller.text,
              password: passwordController.text,
              planType: plan,
              planId: planIdint,
              city: pbCity.id);
          request = userData;

          add(EnrollEvent.createUser(userData));
          // String mobile = userData.mobile;
          // globals.mobile = mobile;
          // _sharedPrefRepository.storeData('mobile', mobile);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red, // Change background color of SnackBar
            content: Center(
              child: Text(
                state.error!,
                style: const TextStyle(
                  color: Colors.white, // Change text color of SnackBar content
                  fontSize: 16, // Change font size of SnackBar content
                  // Add other text styles as needed
                ),
              ),
            ),
            duration: const Duration(seconds: 3), // Adjust duration as needed
          ),
        );
      }
    }
  }

  void resendOtp() {
    //  if (webFormKey.currentState!.validate()) {
    final model = ForgotPasswordModel(
      mobile: globals.mobile,
    );
    request1 = model;

    add(EnrollEvent.resendOtp(model));
    // }
  }

  ForgotPasswordModel forgotPasswordRequest() {
    return request1;
  }

  void validateReferalCode(String value) {
    final data = ValidateReferal(referralCode: value);
    referalCodeRequest = data;

    add(EnrollEvent.validateReferalCode(data));
  }

  void getplan(String id) async {
    add(EnrollEvent.getplan(id));
  }

  void getCities(StateData stateId) async {
    add(EnrollEvent.getCities(stateId));
  }

  void getStates() async {
    add(EnrollEvent.getStates());
  }

  EnrollModel getSignUpRequest() {
    return request;
  }

  updateCity(CityData city) {
    add(EnrollEvent.updateCity(city));
  }

  updateState(StateData name) {
    add(EnrollEvent.updateState(name));
  }

  disposeControllers() {
    emailController.clear();
    phoneController.clear();
    usernameController.clear();
    passwordController.clear();
    referalCodeContoller.clear();
    confirmpasswordController.clear();
    streetController.clear();
    cityController.clear();
    statesController.clear();
    zipcodeController.clear();
    pinController.clear();
    enrollFormKey.currentState?.reset();
  }
}
