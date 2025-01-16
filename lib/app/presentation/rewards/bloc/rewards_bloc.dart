// rewardsBloc here we can make API calls by defining functions.

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:lm_club/app/domain/usecase/home/home_usecase.dart';
import 'package:lm_club/app/presentation/rewards/bloc/rewards_event.dart';
import 'package:lm_club/app/presentation/rewards/bloc/rewards_state.dart';

import 'package:lm_club/utils/string_extention.dart';

@injectable
class RewardsBloc extends Bloc<RewardsEvent, RewardsState> {
  final HomeUsecase _homeUsecase;
  RewardsBloc(this._homeUsecase) : super(RewardsState.init(null)) {
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
  }

  void getUserPoints() async {
    add(RewardsEvent.getUserPoints());
  }
}
