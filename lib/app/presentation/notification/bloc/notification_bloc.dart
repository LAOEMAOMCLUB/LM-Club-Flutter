// NotificationBlocPage here every logic and functionality defined to make API calls(getNotification,readNotification,viewNotification,deleteNotification)

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lm_club/app/domain/usecase/home/home_usecase.dart';
import 'package:lm_club/app/models/auth/request_model/readOrdelete_model.dart';
import 'package:lm_club/app/presentation/notification/bloc/notification_event.dart';
import 'package:lm_club/app/presentation/notification/bloc/notification_state.dart';
import 'package:lm_club/utils/string_extention.dart';

@injectable
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final HomeUsecase _homeUsecase;
  late ReadOrDeleteModel request;
  NotificationBloc(this._homeUsecase)
      : super(NotificationState.init(null, null)) {
    on<GetAllNotifications>(
      (event, emit) async {
        emit(state.copyWith(
          isLoading: true,
          error: "",
          readordelete: false,
        ));
        try {
          final response = await _homeUsecase.getUserNotifications();
          emit(state.copyWith(
              error: "",
              isLoading: false,
              readordelete: false,
              allNotifications: response.data.getAllNotificationList!,
              countObjetcts: response.data
              //  loggedIn: loggedIn,
              ));
        } catch (e) {
          if (kDebugMode) {
            print('Debug-- FetchNotifications ${e.toString()}');
          }
          if (e is DioException) {
            emit(state.copyWith(
              isLoading: false,
              allNotifications: null,
              error: e.errorMessage(),
              //loggedIn: loggedIn,
            ));
          } else {
            emit(state.copyWith(
              isLoading: false,
              allNotifications: null,
              error: e.toString(),
              //loggedIn: loggedIn,
            ));
          }
        }
      },
    );

    on<ViewNotification>(
      (event, emit) async {
        emit(state.copyWith(
          isLoading: true,
          error: "",
          isSuccesfulView: false,
        ));
        try {
          final response = await _homeUsecase.viewNotification(event.id);
          emit(state.copyWith(
              isLoading: false,
              error: "",
              isSuccesfulView: true,
              viewNotificationMsg: response.message
              // data: response,
              ));
        } on DioException catch (de) {
          emit(state.copyWith(
              isLoading: false,
              error: de.errorMessage(),
              isSuccesfulView: false));
        } catch (e) {
          emit(state.copyWith(
              isLoading: false, error: e.toString(), isSuccesfulView: false));
        }
      },
    );

    on<MarkAllAsReadNotifications>(
      (event, emit) async {
        emit(state.copyWith(
            isLoading: true, error: "", isMarkNotification: false));
        try {
          final response = await _homeUsecase.markAllAsRead();
          emit(state.copyWith(
            error: "",
            isLoading: false,
            markAllAsRead: response.message,
            isMarkNotification: true,
          ));
        } catch (e) {
          if (kDebugMode) {
            print('Debug-- FetchMarkAllAsReadNotifications ${e.toString()}');
          }
          if (e is DioException) {
            emit(state.copyWith(
              isLoading: false,
              isMarkNotification: false,
              error: e.errorMessage(),
            ));
          } else {
            emit(state.copyWith(
              isLoading: false,
              isMarkNotification: false,

              error: e.toString(),
              //loggedIn: loggedIn,
            ));
          }
        }
      },
    );
    on<ReadOrDeleteNotifications>(
      (event, emit) async {
        emit(state.copyWith(
          isLoading: true,
          error: "",
          readordelete: false,
        ));
        try {
          final response =
              await _homeUsecase.readOrDeleteNotifications(event.model);
          emit(state.copyWith(
              isLoading: false,
              error: "",
              readordelete: true,
              readOrDeleteResponse: response,
              isReadDelete: response.message));
        } on DioException catch (de) {
          emit(state.copyWith(
            isLoading: false,
            error: de.errorMessage(),
            readordelete: false,
          ));
        } catch (e) {
          emit(state.copyWith(
            isLoading: false,
            error: e.toString(),
            readordelete: false,
          ));
        }
      },
    );
  }
  void readNotification(List<int>? ids, int widgetId) {
    final model =
        ReadOrDeleteModel(actionType: "read", widgetId: widgetId, ids: ids);
    request = model;
    add(NotificationEvent.readOrDeleteNotification(model));
  }

  void deleteNotification(List<int>? ids, int widgetId) {
    final model =
        ReadOrDeleteModel(actionType: "delete", widgetId: widgetId, ids: ids);
    request = model;
    add(NotificationEvent.readOrDeleteNotification(model));
  }
  // void readNotification() {
  //   final model =
  //       ReadOrDeleteModel(actionType: "read", widgetId: 3, ids: [319]);
  //   request = model;
  //   add(NotificationEvent.readOrDeleteNotification(model));
  // }

  void getAllNotifications() async {
    add(NotificationEvent.getAllNotifications());
  }

  void viewNotification(String id) {
    add(NotificationEvent.viewNotification(id));
  }

  void markAllAsReadNotification() async {
    add(NotificationEvent.markAllAsReadNotification());
  }
}
