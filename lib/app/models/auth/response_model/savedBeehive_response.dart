import 'package:lm_club/utils/string_extention.dart';

class UserModel {
  final int? id;
  final String? userName;
  final String? imagePath;

  UserModel({
    required this.id,
    required this.userName,
    required this.imagePath,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      userName: json['user_name'],
      imagePath: json['image_path'],
    );
  }
}

class StatusModel {
  final int? id;
  final String? key;

  StatusModel({
    required this.id,
    required this.key,
  });

  factory StatusModel.fromJson(Map<String, dynamic> json) {
    return StatusModel(
      id: json['id'],
      key: json['key'],
    );
  }
}

class BeehiveCategoryModel {
  final String categoryName;

  BeehiveCategoryModel({
    required this.categoryName,
  });

  factory BeehiveCategoryModel.fromJson(Map<String, dynamic> json) {
    return BeehiveCategoryModel(
      categoryName: json['category_name'],
    );
  }
}

class BeehivePostModel {
  final int? id;
  final String? companyName;
  final String? title;
  final String? description;
  final String? couponCode;
  final DateTime? validFrom;
  final DateTime? validUpto;
  final DateTime? postedTime;
  final DateTime? expiresAt;
  final bool? isDraft;
  final UserModel? user;
  final StatusModel? status;
  final BeehiveCategoryModel? beehiveCategory;

  BeehivePostModel({
    this.id,
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
    this.beehiveCategory,
  });

  factory BeehivePostModel.fromJson(Map<String, dynamic> json) {
    return BeehivePostModel(
      isDraft: json["is_draft"],
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
      user: json["user"] != null ? UserModel.fromJson(json["user"]) : null,
      status:
          json["status"] != null ? StatusModel.fromJson(json["status"]) : null,
      beehiveCategory: json["beehiveCategory"] != null
          ? BeehiveCategoryModel.fromJson(json["beehiveCategory"])
          : null,
    );
  }
}

class MediaModel {
  final int id;
  final String mediaType;
  final String mediaPath;

  MediaModel({
    required this.id,
    required this.mediaType,
    required this.mediaPath,
  });

  factory MediaModel.fromJson(Map<String, dynamic> json) {
    return MediaModel(
      id: json['id'],
      mediaType: json['media_type'],
      mediaPath: json['media_path'],
    );
  }
}

class PostModel {
  final int? id;
  final bool? isSaved;
  final BeehivePostModel? beehivePost;
  final List<MediaModel>? media;
  final String? likesCount;
  final bool? liked;
  final bool? saved;

  PostModel({
    this.id,
    this.isSaved,
    this.beehivePost,
    this.media,
    this.likesCount,
    this.liked,
    this.saved,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      isSaved: json['is_saved'],
      beehivePost: BeehivePostModel.fromJson(json['beehivePost']),
      media: (json['media'] as List)
          .map((media) => MediaModel.fromJson(media))
          .toList(),
      likesCount: json["likesCount"] is String
          ? json["likesCount"]
          : json["likesCount"].toString(),
      liked: json['liked'],
      saved: json['saved'],
    );
  }
}

class SavedBeehiveResponse {
  final bool? status;
  final String? message;
  final List<PostModel>? data;

  SavedBeehiveResponse({
    this.status,
    this.message,
    this.data,
  });

  factory SavedBeehiveResponse.fromJson(Map<String, dynamic> json) {
    return SavedBeehiveResponse(
      status: json['status'],
      message: json.extractMessage(),
      data: (json['data'] as List)
          .map((post) => PostModel.fromJson(post))
          .toList(),
    );
  }
}
