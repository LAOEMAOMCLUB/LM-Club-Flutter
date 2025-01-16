// forgotPasswordBloc here every logic and functionality defined to make API calls.

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:lm_club/app/domain/usecase/home/home_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:lm_club/app/models/auth/request_model/forgot_password_model.dart';
import 'package:lm_club/app/presentation/forgot-password/bloc/forgot_password_event.dart';
import 'package:lm_club/app/presentation/forgot-password/bloc/forgot_password_state.dart';
import 'package:lm_club/utils/string_extention.dart';
import 'package:lm_club/utils/globals.dart' as globals;

@injectable
class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final webFormKey = GlobalKey<FormState>();
  final passwordFormKey = GlobalKey<FormState>();
  final HomeUsecase _homeUsecase;

  final TextEditingController mobleController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  late ForgotPasswordModel request;

  ForgotPasswordBloc(this._homeUsecase)
      : super(const ForgotPasswordState.init(null)) {
    on<ForgotPassword>(
      (event, emit) async {
        emit(state.copyWith(isLoading: true, error: "", isSuccesful: false));
        try {
          final response = await _homeUsecase.forgotPassword(event.model);
          emit(state.copyWith(
              isLoading: false, error: "", isSuccesful: true, data: response));
        } on DioException catch (de) {
          emit(state.copyWith(
              isLoading: false, error: de.errorMessage(), isSuccesful: false));
        } catch (e) {
          emit(state.copyWith(
              isLoading: false, error: e.toString(), isSuccesful: false));
        }
      },
    );

    on<ResetPassword>(
      (event, emit) async {
        emit(state.copyWith(isLoading: true, error: "", isSuccesful: false));
        try {
          final response = await _homeUsecase.resetPassword(event.model);
          emit(state.copyWith(
              isLoading: false, error: "", isSuccesful: true, data: response));
        } on DioException catch (de) {
          emit(state.copyWith(
              isLoading: false, error: de.errorMessage(), isSuccesful: false));
        } catch (e) {
          emit(state.copyWith(
              isLoading: false, error: e.toString(), isSuccesful: false));
        }
      },
    );
  }

  void forgotPassword() {
    if (webFormKey.currentState!.validate()) {
      final model = ForgotPasswordModel(
        mobile: mobleController.text,
      );
      request = model;

      add(ForgotPasswordEvent.forgotPassword(model));
    }
  }

  ForgotPasswordModel forgotPasswordRequest() {
    return request;
  }

  void resetPassword() {
    if (passwordFormKey.currentState!.validate()) {
      final model = ForgotPasswordModel(
          mobile: globals.mobile,
          newPassword: passwordController.text,
          confirmPassword: confirmPasswordController.text);
      request = model;

      add(ForgotPasswordEvent.resetPassword(model));
    }
  }

  ForgotPasswordModel resetPasswordRequest() {
    return request;
  }

  disposeControllers() {
    mobleController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    webFormKey.currentState?.reset();
  }
}
