import 'dart:convert';

CustomSettings responseFromJson(String str) =>
    CustomSettings.fromJson(json.decode(str));

String responseToJson(CustomSettings data) => json.encode(data.toJson());

class CustomSettingsResponse {
  List<CustomSettings> data;

  CustomSettingsResponse({
    required this.data,
  });

  factory CustomSettingsResponse.fromJson(List<dynamic> json) {
    return CustomSettingsResponse(
      data: List<CustomSettings>.from(
        json.map((x) => CustomSettings.fromJson(x)),
      ),
    );
  }

  List<dynamic> toJson() {
    return List<dynamic>.from(data.map((x) => x.toJson()));
  }
}

class CustomSettings {
  int? id;
  String? flag;
  String? description;
  String? key;
  bool? isActive;
  CustomSettings(
      {this.id, this.flag, this.description, this.key, this.isActive});

  factory CustomSettings.fromJson(Map<String, dynamic> json) {
    return CustomSettings(
      key: json["key"] ?? '',
      id: json["id"] ?? 0,
      description: json["description"] ?? '',
      flag: json["flag"] ?? '',
      isActive: json["is_active"] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "key": key,
      "id": id,
      "description": description,
      "flag": flag,
      "is_active": isActive,
    };
  }
}
