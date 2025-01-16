import 'dart:convert';

ReadOrDeleteNotifications readOrDeleteNotificationsFromJson(String str) =>
    ReadOrDeleteNotifications.fromJson(json.decode(str));

String readOrDeleteNotificationsToJson(ReadOrDeleteNotifications data) =>
    json.encode(data.toJson());

class ReadOrDeleteNotifications {
  ReadOrDeleteNotifications({
    required this.status,
    required this.message,
  });

  bool status;
  String message;

  factory ReadOrDeleteNotifications.fromJson(Map<String, dynamic> json) =>
      ReadOrDeleteNotifications(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
