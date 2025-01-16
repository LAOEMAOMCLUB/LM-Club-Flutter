// signInBlocPage here we can make API calls by defining functions.

import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lm_club/app/domain/usecase/home/home_usecase.dart';
import 'package:lm_club/app/models/auth/request_model/login_req_model.dart';
import 'package:lm_club/app/presentation/signin/bloc/sign_in_event.dart';
import 'package:lm_club/app/presentation/signin/bloc/sign_in_state.dart';
import 'package:lm_club/constants/string_constanta.dart';
import 'package:lm_club/utils/string_extention.dart';

@injectable
class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final HomeUsecase _homeUsecase;
  final webFormKey = GlobalKey<FormState>();

  SignInBloc(this._homeUsecase) : super(const SignInState.init(null)) {
    on<SignInUsingEmail>(
      (event, emit) async {
        try {
          emit(state.copyWith(isLoading: true, error: "", message: ""));
          final response = await _homeUsecase.login(event.userData);
          emit(state.copyWith(
              isLoading: false,
              data: response,
              error: "",
              message: response.message,
              loginSuccesful: response.message != Constants.notEnrolled));
        } on DioException catch (e) {
          emit(state.copyWith(
              isLoading: false,
              error: e.errorMessage(),
              message: e.errorMessage(),
              loginSuccesful: false));
        } catch (e) {
          emit(state.copyWith(
              isLoading: false,
              error: e.toString(),
              message: e.toString(),
              loginSuccesful: false));
        }
      },
    );
  }

  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  void signIn() {
    if (webFormKey.currentState!.validate()) {
      final userData = LoginReqModel(
          email: emailController.text, password: passwordController.text);
      add(SignInEvent.signInUser(userData));
    }
  }

  disposeControllers() {
    emailController.clear();
    passwordController.clear();
    webFormKey.currentState?.reset();
  }
}
