import 'dart:convert';

BeehiveDetails beehiveResponseFromJson(String str) =>
    BeehiveDetails.fromJson(json.decode(str));

String beehiveResponseToJson(BeehiveDetails data) => json.encode(data.toJson());

class BeehiveResponse {
  bool? status;
  String message;
  List<BeehiveDetails> data;

  BeehiveResponse({
    this.status,
    required this.message,
    required this.data,
  });

  factory BeehiveResponse.fromJson(Map<String, dynamic> json) {
    return BeehiveResponse(
      status: json["status"],
      message: json["message"],
      data: List<BeehiveDetails>.from(
        json["data"]?.map((x) => BeehiveDetails.fromJson(x)) ?? [],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "message": message,
      "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
  }
}

class BeehiveDetails {
  int? id;
  String? companyName;
  String? title;
  String? description;
  String? couponCode;
  DateTime? validFrom;
  DateTime? validUpto;
  DateTime? postedTime;
  DateTime? expiresAt;
  bool? isDraft;
  UserId? user;
  Status? status;
  BeehiveCategoryDetails? beehiveCategoryDetails;
  List<Media>? media;
  String? likesCount;
  bool? liked;
  bool? saved;
  String? startTime;
  String? endTime;
  BeehiveDetails(
      {this.id,
      this.companyName,
      this.title,
      this.description,
      this.couponCode,
      this.validFrom,
      this.validUpto,
      this.postedTime,
      this.expiresAt,
      this.isDraft,
      this.user,
      this.status,
      this.beehiveCategoryDetails,
      this.media,
      this.likesCount,
      this.liked,
      this.saved,
      this.startTime,
      this.endTime});

  factory BeehiveDetails.fromJson(Map<String, dynamic> json) {
    return BeehiveDetails(
      isDraft: json["is_draft"],
      id: json["id"],
      title: json["title"],
      description: json["description"] ?? '',
      couponCode: json["coupon_code"] ?? '',
      companyName: json["company_name"] ?? '',
      validFrom: json["valid_from"] != null
          ? DateTime.parse(json["valid_from"])
          : null,
      validUpto: json["valid_upto"] != null
          ? DateTime.parse(json["valid_upto"])
          : null,
      postedTime: json["posted_time"] != null
          ? DateTime.parse(json["posted_time"])
          : null,
      expiresAt: DateTime.parse(json["expires_at"]),
      user: json["user"] != null ? UserId.fromJson(json["user"]) : null,
      status: json["status"] != null ? Status.fromJson(json["status"]) : null,
      beehiveCategoryDetails: json["beehiveCategory"] != null
          ? BeehiveCategoryDetails.fromJson(json["beehiveCategory"])
          : null,
      media: json["media"] != null
          ? List<Media>.from(json["media"].map((x) => Media.fromJson(x)))
          : null,
      likesCount: json["likesCount"] is String
          ? json["likesCount"]
          : json["likesCount"].toString(),
      liked: json["liked"],
      saved: json["saved"],
      startTime: json['event_start_time'] ?? '',
      endTime: json['event_end_time'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "is_draft": isDraft,
      "id": id,
      "title": title,
      "description": description,
      "coupon_code": couponCode,
      "company_name": companyName,
      "valid_from": validFrom?.toIso8601String(),
      "valid_upto": validUpto?.toIso8601String(),
      "posted_time": postedTime?.toIso8601String(),
      "expires_at": expiresAt!.toIso8601String(),
      "user": user?.toJson(),
      "status": status?.toJson(),
      "beehiveCategory": beehiveCategoryDetails?.toJson(),
      "media": media != null
          ? List<dynamic>.from(media!.map((x) => x.toJson()))
          : null,
      "likesCount": likesCount,
      "liked": liked,
      "saved": saved,
      "event_start_time": startTime,
      'event_end_time': endTime
    };
  }
}

class UserId {
  int id;
  String userName;
  String? imagePath;

  UserId({
    required this.id,
    required this.userName,
    this.imagePath,
  });

  factory UserId.fromJson(Map<String, dynamic> json) {
    return UserId(
      id: json["id"],
      userName: json["user_name"],
      imagePath: json["image_path"] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "user_name": userName,
      "image_path": imagePath,
    };
  }
}

class Status {
  int id;
  String key;

  Status({
    required this.id,
    required this.key,
  });

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      id: json["id"],
      key: json["key"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "key": key,
    };
  }
}

class BeehiveCategoryDetails {
  String categoryname;

  BeehiveCategoryDetails({
    required this.categoryname,
  });

  factory BeehiveCategoryDetails.fromJson(Map<String, dynamic> json) {
    return BeehiveCategoryDetails(
      categoryname: json["category_name"] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "category_name": categoryname,
    };
  }
}

class Media {
  int id;
  String mediaType;
  String mediaPath;

  Media({
    required this.id,
    required this.mediaType,
    required this.mediaPath,
  });

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      id: json["id"],
      mediaType: json["media_type"],
      mediaPath: json["media_path"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "media_type": mediaType,
      "media_path": mediaPath,
    };
  }
}
