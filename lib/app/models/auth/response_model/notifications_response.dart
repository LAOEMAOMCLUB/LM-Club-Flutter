import 'dart:convert';

import 'package:lm_club/utils/string_extention.dart';

NotificationResponseModel notificationResponseModelFromJson(String str) =>
    NotificationResponseModel.fromJson(json.decode(str));

String notificationResponseModelToJson(NotificationResponseModel data) =>
    json.encode(data.toJson());

class NotificationResponseModel {
  NotificationResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  NotificationsData data;

  factory NotificationResponseModel.fromJson(Map<String, dynamic> json) =>
      NotificationResponseModel(
        status: json["status"],
        message: json["message"],
        data: NotificationsData.fromJson(json["data"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class NotificationsData {
  NotificationsData({
    // this.unreadCount,
    this.getTotalUnreadCount,
    this.getBeehiveUnreadCount,
    this.getBroadcastUnreadCount,
    this.getReferAndEarnUnreadCount,
    this.getAllNotificationList,
  });

  int? getTotalUnreadCount;
  int? getBeehiveUnreadCount;
  int? getBroadcastUnreadCount;
  int? getReferAndEarnUnreadCount;
  List<AllNotifications>? getAllNotificationList;

  factory NotificationsData.fromJson(Map<String, dynamic> json) =>
      NotificationsData(
        getTotalUnreadCount: json["getTotalUnreadCount"] ?? 0,
        getBeehiveUnreadCount: json["getBeehiveUnreadCount"] ?? 0,
        getBroadcastUnreadCount: json["getBroadcastUnreadCount"] ?? 0,
        getReferAndEarnUnreadCount: json["getReferAndEarnUnreadCount"] ?? 0,
        getAllNotificationList: List<AllNotifications>.from(
            json["getAllNotificationList"] != null
                ? json['getAllNotificationList']
                    .map((x) => AllNotifications.fromJson(x))
                : {}),
      );

  Map<String, dynamic> toJson() => {
        "getTotalUnreadCount": getTotalUnreadCount,
        "getBeehiveUnreadCount": getBeehiveUnreadCount,
        "getBroadcastUnreadCount": getBroadcastUnreadCount,
        "getReferAndEarnUnreadCount": getReferAndEarnUnreadCount,
        "getAllNotificationList":
            List<dynamic>.from(getAllNotificationList!.map((x) => x.toJson())),
      };
}

class AllNotifications {
  AllNotifications(
      {this.id,
      this.username,
      this.actionType,
      this.message,
      this.postId,
      this.isViewed,
      this.isRead,
      this.isActive,
      this.createdBy,
      this.createdOn,
      this.modifiedBy,
      this.modifiedOn,
      this.actionBy,
      this.widget});

  int? id;
  String? actionType;
  String? username;
  bool? isActive;
  String? createdOn;
  String? modifiedOn;
  String? createdBy;
  String? modifiedBy;
  String? message;
  int? postId;
  bool? isViewed;
  bool? isRead;
  ActionBy? actionBy;
  WidgetDetails? widget;

  factory AllNotifications.fromJson(Map<String, dynamic> json) =>
      AllNotifications(
        id: json["id"] ?? 0,
        username: json['user_name'],
        createdBy: json["created_by"],
        modifiedBy: json["modified_by"],
        createdOn: json["created_on"],
        modifiedOn: json["modified_on"],
        isActive: json["is_active"],
        isRead: json['is_read'],
        isViewed: json['is_viewed'],
        postId: json['post_id'],
        message: json.extractMessage(),
        actionType: json['action_type'],
        actionBy: ActionBy.fromJson(json["actionBy"] ?? {}),
        widget: WidgetDetails.fromJson(json["widget"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_name": username,
        "action_type": actionType,
        "message": message,
        "post_id": postId,
        "is_viewed": isViewed,
        "is_read": isRead,
        "is_active": isActive,
        "created_on": createdOn,
        "modified_on": modifiedOn,
        "created_by": createdBy,
        "modified_by": modifiedBy,
        "actionBy": actionBy!.toJson(),
        "widget": widget!.toJson()
      };
}

class ActionBy {
  ActionBy({
    this.id,
    this.username,
    this.email,
    this.mobile,
    this.activeStatus,
    this.isVerifiedUser,
    this.street,
    this.imagePath,
    this.zipcode,
    this.referralCodeApplied,
    this.createdBy,
    this.createdOn,
    this.modifiedBy,
    this.modifiedOn,
  });

  int? id;
  String? username;

  String? email;
  String? mobile;
  bool? activeStatus;

  String? street;
  String? referralCodeApplied;
  bool? isVerifiedUser;

  String? imagePath;
  String? zipcode;

  String? createdOn;
  String? modifiedOn;

  String? createdBy;
  String? modifiedBy;

  factory ActionBy.fromJson(Map<String, dynamic> json) => ActionBy(
        id: json["id"],
        username: json["user_name"],
        email: json["email_id"] ?? '',
        mobile: json["mobile_number"] ?? '',
        activeStatus: json["is_active"],
        isVerifiedUser: json['is_verified_user'],
        imagePath: json["image_path"] ?? '',
        zipcode: json["zipcode"],
        street: json["street"],
        createdBy: json["created_by"] ?? '',
        modifiedBy: json["modified_by"] ?? '',
        createdOn: json["created_on"] ?? '',
        modifiedOn: json["modified_on"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_name": username,
        // "password": password,
        "email_id": email,
        "mobile_number": mobile,
        "image_path": imagePath,
        "street": street,

        "referral_code_applied": referralCodeApplied,
        "zipcode": zipcode,
        "is_active": activeStatus,

        "created_on": createdOn,
        "modified_on": modifiedOn,
        "created_by": createdBy,
        "modified_by": modifiedBy,
      };
}

class WidgetDetails {
  WidgetDetails({
    this.id,
    this.widgetName,
    this.imagePath,
    this.description,
    this.isActive,
    this.createdBy,
    this.createdOn,
    this.modifiedBy,
    this.modifiedOn,
  });

  int? id;
  String? widgetName;
  String? description;
  String? imagePath;
  bool? isActive;
  String? createdOn;
  String? modifiedOn;

  String? createdBy;
  String? modifiedBy;

  factory WidgetDetails.fromJson(Map<String, dynamic> json) => WidgetDetails(
        id: json["id"],
        widgetName: json['widget_name'],
        description: json['description'],
        imagePath: json['image_path'],
        isActive: json['is_active'],
        createdBy: json["created_by"] ?? '',
        modifiedBy: json["modified_by"] ?? '',
        createdOn: json["created_on"] ?? '',
        modifiedOn: json["modified_on"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "widget_name": widgetName,
        "image_path": imagePath,
        "description": description,
        "is_active": isActive,
        "created_by": createdBy,
        "created_on": createdOn,
        "modified_by": modifiedBy,
        "modified_on": modifiedOn
      };
}
