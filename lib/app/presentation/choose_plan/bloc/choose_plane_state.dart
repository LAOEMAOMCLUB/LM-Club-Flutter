// choosePlanStatePage used to display UI and manage Models.

import 'package:equatable/equatable.dart';
import 'package:lm_club/app/models/auth/response_model/choose_plan_response.dart';

class ChoosePlanState extends Equatable {
  final bool? isSuccesful;
  final bool isLoading;
  final ChoosePlanResponse? data;
  final String? error;
  final List<ChoosePlanModal> choosePlan;
  final String? planId;
  final String? colorValue;
  const ChoosePlanState(
      {this.isSuccesful,
      required this.isLoading,
      this.error,
      this.data,
      this.colorValue,
      required this.choosePlan,
      this.planId});

  ChoosePlanState.init(this.data)
      : error = "",
        isLoading = false,
        isSuccesful = false,
        planId = '',
        colorValue = '',
        choosePlan = [];

  @override
  List<Object?> get props =>
      [isSuccesful, isLoading, error, data, planId, choosePlan, colorValue];

  ChoosePlanState copyWith({
    String? error,
    bool? isLoading,
    bool? isSuccesful,
    ChoosePlanResponse? data,
    List<ChoosePlanModal>? choosePlan,
    String? planId,
    String? colorValue,
  }) {
    return ChoosePlanState(
        isSuccesful: isSuccesful ?? this.isSuccesful,
        error: error ?? this.error,
        data: data ?? this.data,
        isLoading: isLoading ?? this.isLoading,
        choosePlan: choosePlan ?? this.choosePlan,
        planId: planId ?? this.planId,
        colorValue: colorValue ?? this.colorValue);
  }
}
