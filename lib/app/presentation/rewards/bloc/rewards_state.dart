// rewardState used to display UI and manage Models.

import 'package:equatable/equatable.dart';
import 'package:lm_club/app/models/auth/response_model/referEarn_response.dart';

// ignore: must_be_immutable
class RewardsState extends Equatable {
  final bool? isSuccesful;
  final bool isLoading;
  ReferEarnData? pointsData;
  final String? error;
  final ReferEarnResponse? data;
  List<ReferEarnDataPoints>? userPoints;
  List<ReferEarnDataBeehivePoints>? beehivePoints;
  List<ReferEarnDataBroadcastPoints>? broadcastPoints;
  RewardsState({
    required this.isSuccesful,
    required this.isLoading,
    this.error,
    this.userPoints,
    this.beehivePoints,
    this.broadcastPoints,
    this.pointsData,
    this.data,
  });

  RewardsState.init(this.data)
      : error = "",
        isLoading = false,
        userPoints = [],
        beehivePoints = [],
        broadcastPoints = [],
        pointsData = ReferEarnData.fromJson({}),
        isSuccesful = false;

  @override
  List<Object?> get props => [
        isSuccesful,
        isLoading,
        error,
        data,
        userPoints,
        beehivePoints,
        broadcastPoints,
        pointsData,
      ];

  RewardsState copyWith(
      {String? error,
      bool? isLoading,
      bool? isSuccesful,
      ReferEarnResponse? data,
      ReferEarnData? pointsData,
      List<ReferEarnDataPoints>? userPoints,
      List<ReferEarnDataBeehivePoints>? beehivePoints,
      List<ReferEarnDataBroadcastPoints>? broadcastPoints}) {
    return RewardsState(
        isSuccesful: isSuccesful ?? this.isSuccesful,
        error: error ?? this.error,
        isLoading: isLoading ?? this.isLoading,
        data: data ?? this.data,
        pointsData: pointsData ?? this.pointsData,
        userPoints: userPoints ?? this.userPoints,
        beehivePoints: beehivePoints ?? this.beehivePoints,
        broadcastPoints: broadcastPoints ?? this.broadcastPoints);
  }
}
