import 'package:lm_club/utils/string_extention.dart';

class MySharesBroadcastResponse {
  MySharesBroadcastResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  final bool status;
  final String message;
  final List<MySharesBroadcast> data;

  factory MySharesBroadcastResponse.fromJson(Map<String, dynamic> json) =>
      MySharesBroadcastResponse(
        status: json['status'] ?? false,
        message: json.extractMessage(),
        data: List<MySharesBroadcast>.from(
            (json['data'] ?? []).map((x) => MySharesBroadcast.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class MySharesBroadcast {
  MySharesBroadcast({
    this.id,
    this.isCreated,
    this.isShared,
    this.modeOfShare,
    this.broadcastPost,
    this.media,
  });

  final int? id;
  final dynamic isCreated;
  final bool? isShared;
  final String? modeOfShare;
  final BroadcastPost? broadcastPost;
  final List<Media>? media;

  factory MySharesBroadcast.fromJson(Map<String, dynamic> json) =>
      MySharesBroadcast(
        id: json['id'],
        isCreated: json['is_created'],
        isShared: json['is_shared'],
        modeOfShare: json['mode_of_share'] ?? '',
        broadcastPost: BroadcastPost.fromJson(json['broadcastPost'] ?? {}),
        media: List<Media>.from(json["media"] != null
            ? json['media'].map((x) => Media.fromJson(x))
            : {}),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'is_created': isCreated,
        'is_shared': isShared,
        'mode_of_share': modeOfShare,
        'broadcastPost': broadcastPost!.toJson(),
        'media': List<dynamic>.from(media!.map((x) => x.toJson())),
      };
}

// class BroadcastPostTracking {
//   BroadcastPostTracking({
//     this.id,
//     this.isCreated,
//     this.isShared,
//     this.modeOfShare,
//     this.broadcastPost,
//   });

//   final int? id;
//   final dynamic isCreated;
//   final bool? isShared;
//   final String? modeOfShare;
//   final BroadcastPost? broadcastPost;

//   factory BroadcastPostTracking.fromJson(Map<String, dynamic> json) =>
//       BroadcastPostTracking(
//         id: json['id'],
//         isCreated: json['is_created'],
//         isShared: json['is_shared'],
//         modeOfShare: json['mode_of_share'] ?? '',
//         broadcastPost: BroadcastPost.fromJson(json['broadcastPost']),
//       );

//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'is_created': isCreated,
//         'is_shared': isShared,
//         'mode_of_share': modeOfShare,
//         'broadcastPost': broadcastPost!.toJson(),
//       };
// }

class BroadcastPost {
  BroadcastPost({
    this.id,
    this.title,
    this.description,
    this.couponCode,
    this.user,
  });

  final int? id;
  final String? title;
  final String? description;
  final String? couponCode;
  final User? user;

  factory BroadcastPost.fromJson(Map<String, dynamic> json) => BroadcastPost(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        couponCode: json['coupon_code'],
        user: User.fromJson(json['user']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'coupon_code': couponCode,
        'user': user!.toJson(),
      };
}

class User {
  User({
    this.id,
    this.userName,
    this.imagePath,
  });

  final int? id;
  final String? userName;
  final String? imagePath;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        userName: json['user_name'],
        imagePath: json['image_path'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_name': userName,
        'image_path': imagePath,
      };
}

class Media {
  Media({
    this.id,
    this.mediaType,
    this.mediaPath,
  });

  final int? id;
  final String? mediaType;
  final String? mediaPath;

  factory Media.fromJson(Map<String, dynamic> json) => Media(
        id: json['id'],
        mediaType: json['media_type'],
        mediaPath: json['media_path'],
      );

  get isNotEmpty => null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'media_type': mediaType,
        'media_path': mediaPath,
      };
}
