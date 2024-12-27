import 'dart:convert';

MyPostBeehiveDetails beehiveResponseFromJson(String str) =>
    MyPostBeehiveDetails.fromJson(json.decode(str));

String beehiveResponseToJson(MyPostBeehiveDetails data) =>
    json.encode(data.toJson());

class MyPostBeehiveResponse {
  bool? status;
  String message;
  List<MyPostBeehiveDetails> data;

  MyPostBeehiveResponse({
    this.status,
    required this.message,
    required this.data,
  });

  factory MyPostBeehiveResponse.fromJson(Map<String, dynamic> json) {
    return MyPostBeehiveResponse(
      status: json["status"],
      message: json["message"],
      data: List<MyPostBeehiveDetails>.from(
        json["data"]?.map((x) => MyPostBeehiveDetails.fromJson(x)) ?? [],
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

class MyPostBeehiveDetails {
  bool? isDrafted;
  int? id;
  String? title;
  String? description;
  DateTime? validFrom;
  String? couponCode;
  DateTime? validUpto;
  DateTime? expiresAt;
  UserId? user;
  Status? status;
  String? companyName;
  MyPostBeehiveCategory? beehiveCategory;
  List<Media>? media;
   String? startTime;
  String? endTime;
bool ? expired;
  MyPostBeehiveDetails(
      {this.isDrafted,
      this.id,
      this.title,
      this.description,
      this.validFrom,
      this.validUpto,
      this.expiresAt,
      this.user,
      this.couponCode,
      this.status,
      this.beehiveCategory,
      this.media,
      this.companyName,
       this.startTime,
       this.expired,
    this.endTime});

  factory MyPostBeehiveDetails.fromJson(Map<String, dynamic> json) {
    return MyPostBeehiveDetails(
      isDrafted: json["is_draft"],
      id: json["id"],
      title: json["title"],
      description: json["description"],
      couponCode: json["coupon_code"] ?? '',
      companyName: json["company_name"] ?? '',
      validFrom: json["valid_from"] != null
          ? DateTime.parse(json["valid_from"])
          : null,
      validUpto: json["valid_upto"] != null
          ? DateTime.parse(json["valid_upto"])
          : null,
      expiresAt: DateTime.parse(json["expires_at"]),
      user: json["user"] != null ? UserId.fromJson(json["user"]) : null,
      status: json["status"] != null ? Status.fromJson(json["status"]) : null,
      beehiveCategory: json["beehiveCategory"] != null
          ? MyPostBeehiveCategory.fromJson(json["beehiveCategory"])
          : null,
      media: json["media"] != null
          ? List<Media>.from(json["media"].map((x) => Media.fromJson(x)))
          : null,
           startTime:  json['event_start_time'] ?? '',
      endTime: json['event_end_time'] ?? '',
      expired: json['expired'] ?? false
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "is_draft": isDrafted,
      "id": id,
      "title": title,
      "description": description,
      "coupon_code": couponCode,
      "company_name": companyName,
      "valid_from": validFrom?.toIso8601String(),
      "valid_upto": validUpto?.toIso8601String(),
      "expires_at": expiresAt!.toIso8601String(),
      "user": user?.toJson(),
      "status": status?.toJson(),
      "beehiveCategory": beehiveCategory?.toJson(),
      "media": media != null
          ? List<dynamic>.from(media!.map((x) => x.toJson()))
          : null,
             "event_start_time": startTime,
      'event_end_time': endTime,
      'expired':expired
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

class MyPostBeehiveCategory {
  String categoryName;

  MyPostBeehiveCategory({
    required this.categoryName,
  });

  factory MyPostBeehiveCategory.fromJson(Map<String, dynamic> json) {
    return MyPostBeehiveCategory(
      categoryName: json["category_name"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "category_name": categoryName,
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
