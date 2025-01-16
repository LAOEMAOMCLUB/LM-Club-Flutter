// chooseplanBlocPage here every logic and functionality defined to make API calls.

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:lm_club/app/core/di/locator.dart';
import 'package:lm_club/app/domain/usecase/home/home_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:lm_club/app/models/auth/response_model/choose_plan_response.dart';
import 'package:lm_club/app/presentation/choose_plan/bloc/choose_plan_event.dart';
import 'package:lm_club/app/presentation/choose_plan/bloc/choose_plane_state.dart';

import 'package:lm_club/utils/string_extention.dart';
import 'package:lm_club/app/domain/local_storage/shared_pref_repository.dart';
import 'package:lm_club/utils/globals.dart' as globals;

final SharedPrefRepository _sharedPrefRepository =
    getIt.get<SharedPrefRepository>();

@injectable
class ChoosePlanBloc extends Bloc<ChoosePlanEvent, ChoosePlanState> {
  final HomeUsecase _homeUsecase;
  late ChoosePlanResponse request;
  String planId = '';
  ChoosePlanBloc(this._homeUsecase) : super(ChoosePlanState.init(null)) {
    on<GetAllPlans>(
      (event, emit) async {
        emit(state.copyWith(isLoading: true, error: ""));
        try {
          final response = await _homeUsecase.getAllPlans();
          emit(state.copyWith(
            error: "",
            isLoading: false,
            choosePlan: response.data,
            //  loggedIn: loggedIn,
          ));
        } catch (e) {
          if (kDebugMode) {
            print('Debug-- FetchUserDetails ${e.toString()}');
          }
          if (e is DioException) {
            emit(state.copyWith(
              isLoading: false,
              choosePlan: null,
              error: e.errorMessage(),
              //loggedIn: loggedIn,
            ));
          } else {
            emit(state.copyWith(
              isLoading: false,
              choosePlan: null,
              error: e.toString(),
              //loggedIn: loggedIn,
            ));
          }
        }
      },
    );

    on<UpdatePlanId>(
      (event, emit) {
        String planId = event.id;
        planId = planId;

        globals.planId = planId;
        _sharedPrefRepository.storeData('planId', planId);
        final String colorV = event.color;
        globals.colorValue = colorV;
        _sharedPrefRepository.storeData('colorValue', colorV);
        emit(state.copyWith(isLoading: true));
        emit(state.copyWith(
          isLoading: false,
          planId: planId,
          colorValue: colorV,
          error: "",
        ));
      },
    );
  }

  getAllPlans() async {
    // final response = await _homeUsecase.getAllPlans();
    add(ChoosePlanEvent.getAllPlans());
  }

  updatePlanId(String id, String color) {
    add(ChoosePlanEvent.updatePlanId(id, color));
  }
}
