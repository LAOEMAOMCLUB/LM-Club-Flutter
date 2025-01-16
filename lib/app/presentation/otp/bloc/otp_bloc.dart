// otpBlocPage here we can make API calls by defining functions

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:lm_club/app/domain/usecase/home/home_usecase.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:lm_club/app/models/auth/request_model/forgot_password_model.dart';

import 'package:lm_club/app/presentation/otp/bloc/otp_event.dart';
import 'package:lm_club/app/presentation/otp/bloc/otp_state.dart';
import 'package:lm_club/utils/string_extention.dart';
import 'package:lm_club/utils/globals.dart' as globals;

@injectable
class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final otpFormKey = GlobalKey<FormState>();
  final HomeUsecase _homeUsecase;
  late ForgotPasswordModel requestOtp;
  late ForgotPasswordModel request;

  OtpBloc(this._homeUsecase) : super(const OtpState.init(null, null)) {
    on<VerifyOtp>(
      (event, emit) async {
        emit(state.copyWith(isLoading: true, error: "", isSuccesful: false));
        try {
          final response = await _homeUsecase.verifyOtp(event.model);
          emit(state.copyWith(
              isLoading: false,
              error: "",
              isSuccesful: true,
              otpData: response));
        } on DioException catch (de) {
          emit(state.copyWith(
              isLoading: false, error: de.errorMessage(), isSuccesful: false));
        } catch (e) {
          emit(state.copyWith(
              isLoading: false, error: e.toString(), isSuccesful: false));
        }
      },
    );

    on<ForgotPassword>(
      (event, emit) async {
        emit(state.copyWith(
            isLoading: true, error: "", isSuccesfulPassword: false));
        try {
          final response = await _homeUsecase.forgotPassword(event.model);
          emit(state.copyWith(
              isLoading: false,
              error: "",
              isSuccesfulPassword: true,
              data: response));
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
  }

  TextEditingController otpController1 = TextEditingController();
  TextEditingController otpController4 = TextEditingController();
  TextEditingController otpController2 = TextEditingController();
  TextEditingController otpController3 = TextEditingController();
  TextEditingController otpController5 = TextEditingController();
  TextEditingController otpController6 = TextEditingController();

  void verifyOtp() {
    int otpValue = int.parse(
      otpController1.text +
          otpController2.text +
          otpController3.text +
          otpController4.text +
          otpController5.text +
          otpController6.text,
    );
    if (otpFormKey.currentState!.validate()) {
      final model = ForgotPasswordModel(mobile: globals.mobile, otp: otpValue);
      requestOtp = model;
      //print(model);
      add(OtpEvent.verifyOtp(model));
    }
  }

  void forgotPassword() {
    final model = ForgotPasswordModel(
      mobile: globals.mobile,
    );
    request = model;

    add(OtpEvent.forgotPassword(model));
  }

  ForgotPasswordModel forgotPasswordRequest() {
    return request;
  }

  ForgotPasswordModel verifyOtpRequest() {
    return requestOtp;
  }

  disposeControllers() {
    otpController1.clear();
    otpController2.clear();
    otpController3.clear();
    otpController4.clear();
    otpFormKey.currentState?.reset();
  }
}
