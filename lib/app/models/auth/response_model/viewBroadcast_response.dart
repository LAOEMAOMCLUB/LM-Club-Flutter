import 'dart:convert';

ViewBroadcastDetailsResponse viewbroadcastDetailsResponseFromJson(String str) =>
    ViewBroadcastDetailsResponse.fromJson(json.decode(str));

String viewbroadcastDetailsResponseToJson(ViewBroadcastDetailsResponse data) =>
    json.encode(data.toJson());

class ViewBroadcastDetailsResponse {
  ViewBroadcastDetailsResponse({
    this.status,
    required this.message,
   
    this.broadcastData,
  });

  bool? status;
  String message;
  
  ViewBroadcastDetails? broadcastData;

  factory ViewBroadcastDetailsResponse.fromJson(Map<String, dynamic> json) =>
      ViewBroadcastDetailsResponse(
          status: json["status"] ?? false,
          message: json["message"] ?? '',
         
          broadcastData: ViewBroadcastDetails.fromJson(json["data"] ?? {}));

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
     
        "data": broadcastData!.toJson()
      };
}

class ViewBroadcastDetails {
  ViewBroadcastDetails({
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
    this.couponCode,
    this.postDuration ,
    this.postDurationId,
    this.whatPromoting,
  });

  bool? isDrafted;
  UserId? userId;
  String? title;
  String? description;
  List<String>? image;
  List<ImagesList>? images;
  String? video;
  Status? status;
  int? id;
  String? validDate;
  String? couponCode;
  String? postDuration;
  String? whatPromoting;
  int? postDurationId;

  factory ViewBroadcastDetails.fromJson(Map<String, dynamic> json) =>
      ViewBroadcastDetails(
        isDrafted: json["is_draft"] ?? false,
        userId: UserId.fromJson(json["user"] ?? {}),
        status: Status.fromJson(json["status"] ?? {}),
        image: json.containsKey("image")
            ? List<String>.from(json["image"].map((x) => x))
            : [],
        title: json["title"] ?? '',
        description: json["description"] ?? '',
        video: json["video"] ?? '',
        id: json['id'] ?? 0,
        validDate: json['valid_from'] ?? '',
        couponCode: json['coupon_code'] ?? '',
        images: List<ImagesList>.from(json["media"] != null
            ? json['media'].map((x) => ImagesList.fromJson(x))
            : {}),
            postDuration: json["post_duration"],
            whatPromoting: json['what_are_you_promoting'],
postDurationId: json['postDurationId']
      );

  Map<String, dynamic> toJson() => {
        "is_draft": isDrafted,
        "user": userId!.toJson(),
        "status": status!.toJson(),
        "title": title,
        "description": description,
        "image": List<dynamic>.from(image!.map((x) => x)),
        "video": video,
        "id": id,
        "coupon_code": couponCode,
        "valid_from": validDate,
        "images": List<dynamic>.from(images!.map((x) => x.toJson())),
        "post_duration" : postDuration,
        "what_are_you_promoting":whatPromoting,
        'postDurationId' : postDurationId
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
  });
  int? id;
  String? path;

  factory ImagesList.fromJson(Map<String, dynamic> json) => ImagesList(
        id: json["id"] ?? 0,
        path: json["media_path"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "media_path": path,
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
