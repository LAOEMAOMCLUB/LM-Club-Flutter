// NotificationStatePage used to display UI and manage Models.

import 'package:equatable/equatable.dart';
import 'package:lm_club/app/models/auth/response_model/notifications_response.dart';
import 'package:lm_club/app/models/auth/response_model/readOrdeleteNotification.dart';

// ignore: must_be_immutable
class NotificationState extends Equatable {
  final bool readordelete;
  final bool? isSuccesfulView;
  final bool isLoading;
  final String? error;
  final String? message;
  final NotificationResponseModel? data;
  final List<AllNotifications>? allNotifications;
  final String? viewNotificationMsg;
  final ReadOrDeleteNotifications? readOrDeleteResponse;
  final String isReadDelete;
  // final NotificationsData? unReadCount;
  // final NotificationsData? getBeehiveUnreadCount;
  // final NotificationsData? getBroadcastUnreadCount;
  // final NotificationsData? getReferAndEarnUnreadCount;
  final NotificationsData? countObjetcts;

  final String? markAllAsRead;
  final bool? isMarkNotification;
  const NotificationState(
      {required this.readordelete,
      required this.isLoading,
      this.error,
      this.message,
      this.data,
      this.allNotifications,
      this.viewNotificationMsg,
      this.readOrDeleteResponse,
      required this.isReadDelete,
      // this.unReadCount,
      // required this.getBeehiveUnreadCount,
      // required this.getBroadcastUnreadCount,
      // required this.getReferAndEarnUnreadCount,
      this.isSuccesfulView,
      this.isMarkNotification,
      this.markAllAsRead,
      this.countObjetcts});

  NotificationState.init(this.data, this.readOrDeleteResponse)
      : error = "",
        isLoading = false,
        readordelete = false,
        isSuccesfulView = false,
        allNotifications = [],
        viewNotificationMsg = '',
        isMarkNotification = false,
        markAllAsRead = '',
        isReadDelete = '',
        // unReadCount = NotificationsData(),
        // getBeehiveUnreadCount = NotificationsData(),
        // getBroadcastUnreadCount = NotificationsData(),
        // getReferAndEarnUnreadCount = NotificationsData(),
        countObjetcts = NotificationsData.fromJson({}),
        message = "";

  @override
  List<Object?> get props => [
        isLoading,
        readordelete,
        isSuccesfulView,
        error,
        message,
        data,
        allNotifications,
        viewNotificationMsg,
        isMarkNotification,
        markAllAsRead,
        isReadDelete,
        // unReadCount,
        // getBeehiveUnreadCount,
        // getReferAndEarnUnreadCount,
        // getBroadcastUnreadCount,
        countObjetcts,
        readOrDeleteResponse
      ];

  NotificationState copyWith(
      {String? error,
      bool? isLoading,
      bool? readordelete,
      bool? isSuccesfulView,
      String? message,
      final NotificationResponseModel? data,
      final List<AllNotifications>? allNotifications,
      String? viewNotificationMsg,
      String? markAllAsRead,
      bool? isMarkNotification,
      final NotificationsData? countObjetcts,
      final NotificationsData? unReadCount,
      final NotificationsData? getBeehiveUnreadCount,
      final NotificationsData? getBroadcastUnreadCount,
      final NotificationsData? getReferAndEarnUnreadCount,
      final ReadOrDeleteNotifications? readOrDeleteResponse,
      final String? isReadDelete}) {
    return NotificationState(
        readordelete: readordelete ?? this.readordelete,
        isReadDelete: isReadDelete ?? this.isReadDelete,
        isSuccesfulView: isSuccesfulView ?? isSuccesfulView,
        error: error ?? this.error,
        isLoading: isLoading ?? this.isLoading,
        message: message ?? this.message,
        data: data ?? this.data,
        isMarkNotification: isMarkNotification ?? this.isMarkNotification,
        markAllAsRead: markAllAsRead ?? this.markAllAsRead,
        viewNotificationMsg: viewNotificationMsg ?? this.viewNotificationMsg,
        allNotifications: allNotifications ?? this.allNotifications,
        readOrDeleteResponse: readOrDeleteResponse ?? this.readOrDeleteResponse,
        // unReadCount: unReadCount ?? this.unReadCount,
        // getBeehiveUnreadCount:
        //     getBeehiveUnreadCount ?? this.getBeehiveUnreadCount,
        // getBroadcastUnreadCount:
        //     getBroadcastUnreadCount ?? this.getBroadcastUnreadCount,
        // getReferAndEarnUnreadCount:
        //     getReferAndEarnUnreadCount ?? this.getReferAndEarnUnreadCount,
        countObjetcts: countObjetcts ?? this.countObjetcts);
  }
}
