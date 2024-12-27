// homeStatePage used to display UI and manage Models.

import 'package:equatable/equatable.dart';
import 'package:lm_club/app/models/auth/response_model/notifications_response.dart';
import 'package:lm_club/app/models/auth/response_model/referalCode_response.dart';
import 'package:lm_club/app/models/auth/response_model/widgets_response.dart';
import '../../models/auth/response_model/user_details.dart';

class HomeState extends Equatable {
  final bool? isSuccesful;
  final bool isLoading;
  final UserData? userDetails;
  final String? error;
  final List<Widgets> widgets;
  final NotificationsData? unReadCount;
  final NotificationsData? getBeehiveUnreadCount;
  final NotificationsData? getBroadcastUnreadCount;
  final NotificationsData? getReferAndEarnUnreadCount;
  final ReferalCodeData? refeeralCode;
  final bool? accountDeleted;
  const HomeState(
      {this.isSuccesful,
      required this.isLoading,
      this.unReadCount,
      this.error,
      required this.widgets,
      required this.userDetails,
      required this.getBeehiveUnreadCount,
      required this.getBroadcastUnreadCount,
      required this.getReferAndEarnUnreadCount,
      this.refeeralCode,
      this.accountDeleted});

  HomeState.init()
      : error = "",
        isLoading = false,
        isSuccesful = false,
        widgets = [],
        unReadCount = NotificationsData(),
        getBeehiveUnreadCount = NotificationsData(),
        getBroadcastUnreadCount = NotificationsData(),
        getReferAndEarnUnreadCount = NotificationsData(),
        userDetails = UserData.fromJson({}),
        refeeralCode = ReferalCodeData.fromJson({}),
        accountDeleted = false;

  @override
  List<Object?> get props => [
        isSuccesful,
        isLoading,
        error,
        widgets,
        userDetails,
        unReadCount,
        getBeehiveUnreadCount,
        getReferAndEarnUnreadCount,
        getBroadcastUnreadCount,
        refeeralCode,
        accountDeleted,
      ];

  HomeState copyWith({
    String? error,
    bool? isLoading,
    bool? isSuccesful,
    final NotificationsData? unReadCount,
    final NotificationsData? getBeehiveUnreadCount,
    final NotificationsData? getBroadcastUnreadCount,
    final NotificationsData? getReferAndEarnUnreadCount,
    List<Widgets>? widgets,
    UserData? userDetails,
    ReferalCodeData? refeeralCode,
    bool? accountDeleted,
  }) {
    return HomeState(
        isSuccesful: isSuccesful ?? this.isSuccesful,
        error: error ?? this.error,
        isLoading: isLoading ?? this.isLoading,
        widgets: widgets ?? this.widgets,
        unReadCount: unReadCount ?? this.unReadCount,
        getBeehiveUnreadCount:
            getBeehiveUnreadCount ?? this.getBeehiveUnreadCount,
        getBroadcastUnreadCount:
            getBroadcastUnreadCount ?? this.getBroadcastUnreadCount,
        getReferAndEarnUnreadCount:
            getReferAndEarnUnreadCount ?? this.getReferAndEarnUnreadCount,
        userDetails: userDetails ?? this.userDetails,
        refeeralCode: refeeralCode ?? this.refeeralCode,
        accountDeleted: accountDeleted ?? this.accountDeleted);
  }
}
