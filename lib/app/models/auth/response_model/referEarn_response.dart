import 'dart:convert';

import 'package:lm_club/utils/string_extention.dart';

ReferEarnData planResponseFromJson(String str) =>
    ReferEarnData.fromJson(json.decode(str));

class ReferEarnResponse {
  final bool status;
  final String message;
  final ReferEarnData? data;

  ReferEarnResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory ReferEarnResponse.fromMap(Map<String, dynamic> map) {
    return ReferEarnResponse(
      status: map['status'] ?? false,
      message: map.extractMessage(),
      data: ReferEarnData.fromJson(map['data'] ?? {}),
    );
  }
}

class ReferEarnData {
  int? referalSum;
  String? beehiveSum;
   String? broadcastSum;
  List<ReferEarnDataPoints>? myReferalPoints;
  List<ReferEarnDataBeehivePoints>? mybeehivePoints;
  List<ReferEarnDataBroadcastPoints>? myBroadcastPoints;
  ReferEarnData(
      {this.referalSum,
      this.myReferalPoints,
      this.beehiveSum,
      this.broadcastSum,
      this.mybeehivePoints,
      this.myBroadcastPoints});

  factory ReferEarnData.fromJson(Map<String, dynamic> json) {
    return ReferEarnData(
      referalSum: json["referalSum"],
      beehiveSum: json["beehiveSum"],
      broadcastSum: json['broadcastSum'],
      myReferalPoints: List<ReferEarnDataPoints>.from(json["myReferalPoints"] !=
              null
          ? json['myReferalPoints'].map((x) => ReferEarnDataPoints.fromJson(x))
          : []),
      mybeehivePoints: List<ReferEarnDataBeehivePoints>.from(
          json["mybeehivePoints"] != null
              ? json['mybeehivePoints']
                  .map((x) => ReferEarnDataBeehivePoints.fromJson(x))
              : []),
               myBroadcastPoints: List<ReferEarnDataBroadcastPoints>.from(
          json["myBroadcastPoints"] != null
              ? json['myBroadcastPoints']
                  .map((x) => ReferEarnDataBroadcastPoints.fromJson(x))
              : []),
    );
  }

  Map<String, dynamic> toJson() => {
        "referalSum": referalSum,
        "beehiveSum": beehiveSum,
        "broadcastSum":broadcastSum,
        "myReferalPoints":
            List<dynamic>.from(myReferalPoints!.map((x) => x.toJson())),
        "mybeehivePoints":
            List<dynamic>.from(mybeehivePoints!.map((x) => x.toJson())),
            "myBroadcastPoints":
            List<dynamic>.from(myBroadcastPoints!.map((x) => x.toJson())),
      };
}

class ReferEarnDataPoints {
  ReferEarnDataPoints(
      {this.id, this.points, this.transactionDate, this.userReferral});

  int? id;
  String? points;
  UserReferral? userReferral;
  String? transactionDate;

  factory ReferEarnDataPoints.fromJson(Map<String, dynamic> json) =>
      ReferEarnDataPoints(
        id: json["id"] ?? 0,
        points: json["points"] ?? '',
        transactionDate: json["transaction_date"] ?? '',
        userReferral: UserReferral.fromJson(json["userReferral"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "points": points,
        "transaction_date": transactionDate,
        "userReferral": userReferral!.toJson()
      };
}

class ReferEarnDataBeehivePoints {
  ReferEarnDataBeehivePoints(
      {this.id,
      this.points,
      this.transactionDate,
      this.userData,
      this.beehivePostTracking,
      this.message});

  int? id;
  String? points;
  UserIDData? userData;
  String? transactionDate;
  String? message;
  BeehiveTrakingDetails? beehivePostTracking;

  factory ReferEarnDataBeehivePoints.fromJson(Map<String, dynamic> json) =>
      ReferEarnDataBeehivePoints(
          id: json["id"] ?? 0,
          points: json["points"] ?? '',
          transactionDate: json["transaction_date"] ?? '',
          userData: UserIDData.fromJson(json["user"] ?? {}),
          beehivePostTracking:
              BeehiveTrakingDetails.fromJson(json["beehivePostTracking"] ?? {}),
          message: json["message"] ?? '');

  Map<String, dynamic> toJson() => {
        "id": id,
        "points": points,
        "transaction_date": transactionDate,
        "user": userData!.toJson(),
        "beehivePostTracking": beehivePostTracking!.toJson(),
        "message": message
      };
}

class UserIDData {
  UserIDData({
    this.id,
  });

  int? id;

  factory UserIDData.fromJson(Map<String, dynamic> json) => UserIDData(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}

class UserReferral {
  UserReferral({this.id, this.userData});

  int? id;
  UserIDData? userData;
  factory UserReferral.fromJson(Map<String, dynamic> json) => UserReferral(
        id: json["id"],
        userData: UserIDData.fromJson(json["user"] ?? {}),
      );

  Map<String, dynamic> toJson() => {"id": id, "user": userData!.toJson()};
}

class BeehiveTrakingDetails {
  BeehiveTrakingDetails({this.id, this.isLiked, this.isCreated});

  int? id;
  bool? isCreated;
  bool? isLiked;
  factory BeehiveTrakingDetails.fromJson(Map<String, dynamic> json) =>
      BeehiveTrakingDetails(
          id: json["id"],
          isCreated: json["is_created"],
          isLiked: json["is_liked"]);

  Map<String, dynamic> toJson() =>
      {"id": id, "is_liked": isLiked, "is_created": isCreated};
}

class ReferEarnDataBroadcastPoints {
  ReferEarnDataBroadcastPoints(
      {this.id,
      this.points,
      this.transactionDate,
      this.userData,
      this.broadcastPostTracking,
      this.message});

  int? id;
  String? points;
  UserIDData? userData;
  String? transactionDate;
  String? message;
  BroadcastTrakingDetails? broadcastPostTracking;

  factory ReferEarnDataBroadcastPoints.fromJson(Map<String, dynamic> json) =>
      ReferEarnDataBroadcastPoints(
          id: json["id"] ?? 0,
          points: json["points"] ?? '',
          transactionDate: json["transaction_date"] ?? '',
          userData: UserIDData.fromJson(json["user"] ?? {}),
          broadcastPostTracking: BroadcastTrakingDetails.fromJson(
              json["broadcastPostTracking"] ?? {}),
          message: json["message"] ?? '');

  Map<String, dynamic> toJson() => {
        "id": id,
        "points": points,
        "transaction_date": transactionDate,
        "user": userData!.toJson(),
        "broadcastPostTracking": broadcastPostTracking!.toJson(),
        "message": message
      };
}

class BroadcastTrakingDetails {
  BroadcastTrakingDetails({this.id, this.isShared, this.isCreated});

  int? id;
  bool? isCreated;
  bool? isShared;
  factory BroadcastTrakingDetails.fromJson(Map<String, dynamic> json) =>
      BroadcastTrakingDetails(
          id: json["id"],
          isCreated: json["is_created"],
          isShared: json["is_shared"]);

  Map<String, dynamic> toJson() =>
      {"id": id, "is_shared": isShared, "is_created": isCreated};
}
