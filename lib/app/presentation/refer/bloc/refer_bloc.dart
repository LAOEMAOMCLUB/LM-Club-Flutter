// referEarnBlocPage here we can make API calls by defining functions.

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:lm_club/app/domain/usecase/home/home_usecase.dart';
import 'package:lm_club/app/presentation/refer/bloc/refer_event.dart';
import 'package:lm_club/app/presentation/refer/bloc/refer_state.dart';
import 'package:lm_club/utils/string_extention.dart';

@injectable
class ReferEarnBloc extends Bloc<ReferEarnEvent, ReferEarnState> {
  final HomeUsecase _homeUsecase;
  ReferEarnBloc(this._homeUsecase) : super(ReferEarnState.init(null)) {
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
    add(ReferEarnEvent.getReferalCode());
  }
}
