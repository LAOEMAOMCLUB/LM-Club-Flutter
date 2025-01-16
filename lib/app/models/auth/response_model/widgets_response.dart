import 'dart:convert';


Widgets widgetsResponseFromJson(String str) =>
    Widgets.fromJson(json.decode(str));

String widgetsResponseToJson(Widgets data) =>
    json.encode(data.toJson());

class WidgetsResponse {
  WidgetsResponse({
   required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  List<Widgets> data;

  factory WidgetsResponse.fromJson(Map<String, dynamic> json) =>
      WidgetsResponse(
        status: json["status"],
        message: json["message"],
        data: List<Widgets>.from(json["data"] != null
            ? json['data'].map((x) => Widgets.fromJson(x))
            : {}),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Widgets {
  Widgets({
    required this.id,
    required this.name,
    this.description,
    this.imagePath,
      this.isActive,
      this.createdBy,
      this.createdOn,
      this.modifiedBy,
      this.modifiedOn
     
  });
  String id;
  String name;
  String? description;
  String? imagePath;
  bool? isActive;
  String? createdOn;
  String? modifiedOn;
  String? createdBy;
  String? modifiedBy;

  factory Widgets.fromJson(Map<String, dynamic> json) =>
      Widgets(
        id: json["widget_name"],
        name: json["widget_name"],
        createdBy: json["created_by"],
        modifiedBy: json["modified_by"],
        createdOn: json["created_on"],
        modifiedOn: json["modified_on"],
        isActive: json["is_active"],
        imagePath: json["image_path"],
        description: json["description"]
      );

  Map<String, dynamic> toJson() =>
      {"id": id, 
      "widget_name": name,  
      "is_active": isActive,
        "created_on": createdOn,
        "modified_on": modifiedOn,
        "created_by": createdBy,
        "modified_by": modifiedBy,
        "description" : description,
        "imagePath" : imagePath};
}
