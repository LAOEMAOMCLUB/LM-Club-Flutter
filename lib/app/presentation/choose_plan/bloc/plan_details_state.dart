// planDetailStatePage  used to display UI and manage Models

import 'package:equatable/equatable.dart';
import 'package:lm_club/app/models/auth/response_model/plan_details.dart';

class PlanDetailsState extends Equatable {
  final bool? isSuccesful;
  final bool isLoading;
  final PlanDetailsResponse? data;
  final String? error;
  final PlanDetailsData? choosePlanModal;

  const PlanDetailsState({
    this.isSuccesful,
    required this.isLoading,
    this.error,
    this.data,
    required this.choosePlanModal,
  });

  PlanDetailsState.init(this.data)
      : error = "",
        isLoading = false,
        isSuccesful = false,
        choosePlanModal = PlanDetailsData.fromMap({});

  @override
  List<Object?> get props =>
      [isSuccesful, isLoading, error, data, choosePlanModal];

  PlanDetailsState copyWith(
      {String? error,
      bool? isLoading,
      bool? isSuccesful,
      PlanDetailsResponse? data,
      PlanDetailsData? choosePlanModal}) {
    return PlanDetailsState(
        isSuccesful: isSuccesful ?? this.isSuccesful,
        error: error ?? this.error,
        data: data ?? this.data,
        isLoading: isLoading ?? this.isLoading,
        choosePlanModal: choosePlanModal ?? this.choosePlanModal);
  }
}
