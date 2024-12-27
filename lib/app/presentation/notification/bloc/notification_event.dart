// NotificationEvent helps to track all users actions to make API calls.

import 'package:lm_club/app/models/auth/request_model/readOrdelete_model.dart';

abstract class NotificationEvent {
  NotificationEvent._();
  factory NotificationEvent.getAllNotifications() => GetAllNotifications();
  factory NotificationEvent.viewNotification(String id) => ViewNotification(id);
  factory NotificationEvent.markAllAsReadNotification() =>
      MarkAllAsReadNotifications();
  factory NotificationEvent.readOrDeleteNotification(ReadOrDeleteModel model) =>
      ReadOrDeleteNotifications(model);
}

class GetAllNotifications extends NotificationEvent {
  GetAllNotifications() : super._();
}

class ViewNotification extends NotificationEvent {
  final String id;
  ViewNotification(this.id) : super._();
}

class MarkAllAsReadNotifications extends NotificationEvent {
  MarkAllAsReadNotifications() : super._();
}

class ReadOrDeleteNotifications extends NotificationEvent {
  final ReadOrDeleteModel model;
  ReadOrDeleteNotifications(this.model) : super._();
}
