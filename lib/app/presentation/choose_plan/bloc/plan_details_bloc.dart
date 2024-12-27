//planDetailsPage here every logic and functionality defined to make API calls

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:lm_club/app/domain/usecase/home/home_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:lm_club/app/models/auth/response_model/plan_details.dart';
import 'package:lm_club/app/presentation/choose_plan/bloc/plan_details_event.dart';
import 'package:lm_club/app/presentation/choose_plan/bloc/plan_details_state.dart';

import 'package:lm_club/utils/string_extention.dart';

@injectable
class PlanDetailsBloc extends Bloc<PlanDetailsEvent, PlanDetailsState> {
  final HomeUsecase _homeUsecase;
  late PlanDetailsResponse request;

  PlanDetailsBloc(this._homeUsecase) : super(PlanDetailsState.init(null)) {
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

  void getplan(String id) async {
    add(PlanDetailsEvent.getplan(id));
  }
}
