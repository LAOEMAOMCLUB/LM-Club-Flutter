import 'dart:convert';

BeehiveCategory beehiveCategoriesResponseFromJson(String str) =>
    BeehiveCategory.fromJson(json.decode(str));

String beehiveCategoriesResponseToJson(BeehiveCategory data) =>
    json.encode(data.toJson());

class BeehiveCategoriesResponse {
  BeehiveCategoriesResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  List<BeehiveCategory> data;

  factory BeehiveCategoriesResponse.fromJson(Map<String, dynamic> json) =>
      BeehiveCategoriesResponse(
        status: json["status"],
        message: json["message"],
        data: List<BeehiveCategory>.from(json["data"] != null
            ? json['data'].map((x) => BeehiveCategory.fromJson(x))
            : {}),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class BeehiveCategory {
  BeehiveCategory({
    required this.id,
    required this.category,
    this.isActive,
  });
  int id;
  String category;
  bool? isActive;

  factory BeehiveCategory.fromJson(Map<String, dynamic> json) =>
      BeehiveCategory(
        id: json["id"],
        category: json["category_name"],
        isActive: json["is_active"],
      );

  Map<String, dynamic> toJson() =>
      {"id": id, "category_name": category, "is_active": isActive};
}
