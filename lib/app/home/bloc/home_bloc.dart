// homeBlocPage  here every logic and functionality defined to make API calls.

// ignore_for_file: non_constant_identifier_names
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:lm_club/app/domain/usecase/home/home_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:lm_club/app/home/bloc/home_event.dart';
import 'package:lm_club/app/home/bloc/home_state.dart';
import 'package:lm_club/utils/string_extention.dart';
import 'package:lm_club/utils/globals.dart' as globals;

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final webFormKey = GlobalKey<FormState>();
  final HomeUsecase _homeUsecase;

  HomeBloc(this._homeUsecase) : super(HomeState.init()) {
    on<FetchWidgets>(
      (event, emit) async {
        emit(state.copyWith(isLoading: true, error: ""));
        try {
          final response = await _homeUsecase.getWidgets(globals.userId);
          emit(state.copyWith(
            error: "",
            isLoading: false,
            widgets: response.data,
            //  loggedIn: loggedIn,
          ));
        } catch (e) {
          if (kDebugMode) {
            print('Debug-- Fetch Widgets ${e.toString()}');
          }
          if (e is DioException) {
            emit(state.copyWith(
              isLoading: false,
              widgets: null,
              error: e.errorMessage(),
              //loggedIn: loggedIn,
            ));
          } else {
            emit(state.copyWith(
              isLoading: false,
              widgets: null,
              error: e.toString(),
              //loggedIn: loggedIn,
            ));
          }
        }
      },
    );
    on<GetUserDetails>(
      (event, emit) async {
        emit(state.copyWith(isLoading: true, error: ""));
        try {
          final response = await _homeUsecase.getUserDetails(event.id);
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
    on<GetAllNotifications>(
      (event, emit) async {
        emit(state.copyWith(isLoading: true, error: ""));
        try {
          final response = await _homeUsecase.getUserNotifications();
          emit(state.copyWith(
            error: "",
            isLoading: false,
            unReadCount: response.data,
            //  loggedIn: loggedIn,
          ));
        } catch (e) {
          if (kDebugMode) {
            print('Debug-- FetchNotifications ${e.toString()}');
          }
          if (e is DioException) {
            emit(state.copyWith(
              isLoading: false,
              unReadCount: null,
              error: e.errorMessage(),
              //loggedIn: loggedIn,
            ));
          } else {
            emit(state.copyWith(
              isLoading: false,
              unReadCount: null,
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

    on<DeleteAccount>(
      (event, emit) async {
        emit(state.copyWith(isLoading: true, error: ""));
        try {
          final response = await _homeUsecase.deleteAccount();
          emit(state.copyWith(
            error: "",
            isLoading: false,
            accountDeleted: response.status,
          ));
        } catch (e) {
          if (e is DioException) {
            emit(state.copyWith(
              isLoading: false,
              accountDeleted: false,
              error: e.errorMessage(),
            ));
          } else {
            emit(state.copyWith(
              isLoading: false,
              accountDeleted: false,
              error: e.toString(),
            ));
          }
        }
      },
    );
  }
  void getReferalCode() async {
    add(HomeEvent.getReferalCode());
  }

  fetchwidgets() async {
    add(HomeEvent.fetchWidgets());
  }

  void getUserDetails(String id) async {
    add(HomeEvent.getUserDetails(id));
  }

  void getAllNotifications() async {
    add(HomeEvent.getAllNotifications());
  }

  void deleteAccount() async {
    add(HomeEvent.deleteAccount());
  }
}
