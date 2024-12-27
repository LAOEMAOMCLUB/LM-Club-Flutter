import 'dart:convert';

BroadcastDetailsResponse broadcastDetailsResponseFromJson(String str) =>
    BroadcastDetailsResponse.fromJson(json.decode(str));

String broadcastDetailsResponseToJson(BroadcastDetailsResponse data) =>
    json.encode(data.toJson());

class BroadcastDetailsResponse {
  BroadcastDetailsResponse({
    this.status,
    required this.message,
    required this.data,
  });

  bool? status;
  String message;
  List<BroadcastDetails> data;

  factory BroadcastDetailsResponse.fromJson(Map<String, dynamic> json) =>
      BroadcastDetailsResponse(
        status: json["status"] ?? false,
        message: json["message"] ?? '',
        data: List<BroadcastDetails>.from(json["data"] != null
            ? json['data'].map((x) => BroadcastDetails.fromJson(x))
            : []),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class BroadcastDetails {
  BroadcastDetails({
    this.isDrafted,
    this.userId,
    this.title,
    this.description,
    this.image,
    this.video,
    this.images,
    this.status,
    this.id,
    this.validDate,
    this.expiresAt,
    this.couponCode,
    this.isEdited
  });

  bool? isDrafted;
  bool? isEdited;
  UserId? userId;
  String? title;
  String? description;
  List<String>? image;
  List<ImagesList>? images;
  String? video;
  Status? status;
  int? id;
  DateTime? validDate;
  DateTime? expiresAt;
  String? couponCode;

  factory BroadcastDetails.fromJson(Map<String, dynamic> json) =>
      BroadcastDetails(
        isDrafted: json["is_draft"] ?? false,
        isEdited: json["is_edited"] ?? false,
        userId: UserId.fromJson(json["user"] ?? {}),
        status: Status.fromJson(json["status"] ?? {}),
        image: json.containsKey("image")
            ? List<String>.from(json["image"].map((x) => x))
            : [],
        title: json["title"] ?? '',
        description: json["description"] ?? '',
        video: json["video"] ?? '',
        id: json['id'] ?? 0,
        validDate: DateTime.parse(json['valid_from'] ?? ''),
        expiresAt: DateTime.parse(json["expires_at"]),
        couponCode: json['coupon_code'] ?? '',
        images: List<ImagesList>.from(json["media"] != null
            ? json['media'].map((x) => ImagesList.fromJson(x))
            : {}),
      );

  Map<String, dynamic> toJson() => {
        "is_draft": isDrafted,
        'is_edited':isEdited,
        "user": userId!.toJson(),
        "status": status!.toJson(),
        "title": title,
        "description": description,
        "image": List<dynamic>.from(image!.map((x) => x)),
        "video": video,
        "id": id,
        "coupon_code":couponCode,
        "valid_from":validDate!.toIso8601String() ,
        'expires_at': expiresAt!.toIso8601String(),
        "images": List<dynamic>.from(images!.map((x) => x.toJson())),
      };
}

class UserId {
  UserId({
    this.id,
    this.username,
    this.imagePath,
  });

  int? id;
  String? username;

  String? imagePath;

  factory UserId.fromJson(Map<String, dynamic> json) => UserId(
        id: json["id"],
        username: json["user_name"] ?? '',
        imagePath: json["image_path"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_name": username,
        "image_path": imagePath,
      };
}

class ImagesList {
  ImagesList({
    this.id,
    this.path,
    this.type,
  });
  int? id;
  String? path;
  String? type;

  factory ImagesList.fromJson(Map<String, dynamic> json) => ImagesList(
        id: json["id"] ?? 0,
        path: json["media_path"],
        type: json['media_type']
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "media_path": path,
        'media_type':type
      };

  split(String s) {}
}

class Status {
  Status({this.id, this.key});
  int? id;
  String? key;
  factory Status.fromJson(Map<String, dynamic> json) => Status(
        id: json["id"] ?? 0,
        key: json["key"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "key": key,
      };
}
