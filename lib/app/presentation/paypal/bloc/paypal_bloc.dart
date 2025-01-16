// paypalBlocPage here we can make API calls by defining functions

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:lm_club/app/domain/usecase/home/home_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:lm_club/app/presentation/paypal/bloc/paypal_event.dart';
import 'package:lm_club/app/presentation/paypal/bloc/paypal_state.dart';
import 'package:lm_club/utils/string_extention.dart';
import 'package:lm_club/utils/globals.dart' as globals;

@injectable
class PaypalBloc extends Bloc<PaypalEvent, PaypalState> {
  final webFormKey = GlobalKey<FormState>();
  final passwordFormKey = GlobalKey<FormState>();
  final HomeUsecase _homeUsecase;

  TextEditingController amountController = TextEditingController();
  TextEditingController nonceController = TextEditingController();

  PaypalBloc(this._homeUsecase) : super(const PaypalState.init(null)) {
    on<CheckOut>(
      (event, emit) async {
        emit(state.copyWith(isLoading: true, error: "", isSuccesful: false));
        try {
          DateTime currentDate = DateTime.now();
          DateTime futureDate = currentDate.add(const Duration(days: 30));
          String userIdStr = globals.userId;
          int userIdInt = int.parse(userIdStr);

          String planIdString = globals.planId;
          int planIdint = int.parse(planIdString);
          Map<String, dynamic> params = {
            'amount': event.amount,
            'userId': userIdInt,
            'planId': planIdint,
            'payment_for': "subscription",
            'subscription_from': formatDate(currentDate),
            'subscription_upto': formatDate(futureDate),
          };
          final response = await _homeUsecase.checkout(params);
          emit(state.copyWith(
              isLoading: false,
              error: "",
              isSuccesful: true,
              message: response.message,
              data: response));
        } on DioException catch (de) {
          emit(state.copyWith(
              isLoading: false, error: de.errorMessage(), isSuccesful: false));
        } catch (e) {
          emit(state.copyWith(
              isLoading: false, error: e.toString(), isSuccesful: false));
        }
      },
    );
    on<RenewalPay>(
      (event, emit) async {
        emit(state.copyWith(isLoading: true, error: "", isSuccesful: false));
        try {
          DateTime currentDate = DateTime.now();
          DateTime futureDate = currentDate.add(const Duration(days: 30));
          String userIdStr = globals.userId;
          int userIdInt = int.parse(userIdStr);

          int planID = int.parse(event.planId);

          Map<String, dynamic> params = {
            'amount': event.amount,
            'userId': userIdInt,
            'planId': planID,
            // 'planId': planIdint,
            'payment_for': "subscription",
            'subscription_from': formatDate(currentDate),
            'subscription_upto': formatDate(futureDate),
          };
          final response = await _homeUsecase.checkout(params);
          emit(state.copyWith(
              isLoading: false,
              error: "",
              isSuccesful: true,
              message: response.message,
              data: response));
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

  checkout(amount) {
    add(PaypalEvent.checkOut(amount));
  }

  renewalPay(amount, planId) {
    add(PaypalEvent.renewalPay(amount, planId));
  }

  disposeControllers() {
    amountController.clear();
    nonceController.clear();

    webFormKey.currentState?.reset();
  }
}

String formatDate(DateTime date) {
  return "${date.year}-${_twoDigits(date.month)}-${_twoDigits(date.day)}";
}

String _twoDigits(int n) {
  if (n >= 10) return "$n";
  return "0$n";
}
