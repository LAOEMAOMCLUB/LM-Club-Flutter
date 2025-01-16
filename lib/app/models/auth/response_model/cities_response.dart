import 'package:lm_club/utils/string_extention.dart';

class CitiesResponse {
  bool? status;
  String? message;
  List<CityData>? data;
  int? count;
  int? total;

  CitiesResponse({
     this.status,
     this.message,
     this.data,
     this.count,
     this.total,
  });

  factory CitiesResponse.fromJson(Map<String, dynamic> json) {
    return CitiesResponse(
      status: json['status'],
      message: json.extractMessage(),
      data: (json['data'] as List<dynamic>)
          .map((item) => CityData.fromJson(item))
          .toList(),
      count: json['count'],
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data!.map((item) => item.toJson()).toList(),
      'count': count,
      'total': total,
    };
  }
}

class CityData {
  int? id;
  String? city;
  StatesData? state;
//  ZipcodeData? zipcode;
  String? cityName;
  
//  LocationData? location;
  bool? activeStatus;
  String? country;
  bool? isPopular;

  CityData({
     this.id,
     this.city,
     this.state,
   //  this.zipcode,
     this.cityName,
   //  this.location,
     this.activeStatus,
     this.country,
     this.isPopular,
  });

  factory CityData.fromJson(Map<String, dynamic> json) {
    return CityData(
      id: json['id'],
      city: json['city'],
      state: StatesData.fromJson(json["state"] ?? {}),
    //  zipcode: ZipcodeData.fromJson(json['zipcode'] ?? {}),
      cityName: json['city_name'],
    //  location: LocationData.fromJson(json['location'] ?? ''),
      activeStatus: json['is_active'],
      country: json['country'],
      isPopular: json['isPopular'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'city': city,
      'state': state!.toJson(),
      //'zipcode': zipcode!.toJson(),
      'cityName': cityName,
      //'location': location!.toJson(),
      'is_active': activeStatus,
      'country': country,
      'isPopular': isPopular,
    };
  }
}

class StatesData {
  int? id;
  String? name;
  String? code;
  bool? activeStatus;
  String? createdAt;
  String? updatedAt;

  StatesData({
     this.id,
     this.name,
     this.code,
     this.activeStatus,
     this.createdAt,
     this.updatedAt,
  });

  factory StatesData.fromJson(Map<String, dynamic> json) {
    return StatesData(
      id: json['id'],
      name: json['city_name'],
      code: json['code'],
      activeStatus: json['activeStatus'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'city_name': name,
      'code': code,
      'activeStatus': activeStatus,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class ZipcodeData {
  int? id;
  String? zipcode;
  int? price;
  String? status;
  bool? reserved;
  bool? isExclusive;
  bool? activeStatus;
  String? createdAt;
  String? updatedAt;

  ZipcodeData({
     this.id,
     this.zipcode,
     this.price,
     this.status,
     this.reserved,
     this.isExclusive,
     this.activeStatus,
     this.createdAt,
     this.updatedAt,
  });

  factory ZipcodeData.fromJson(Map<String, dynamic> json) {
    return ZipcodeData(
      id: json['id'] ?? '',
      zipcode: json['zipcode'] ?? '',
      price: json['price'] ?? '',
      status: json['status'] ?? '',
      reserved: json['reserved'] ?? '',
      isExclusive: json['isExclusive'] ?? '',
      activeStatus: json['activeStatus'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'zipcode': zipcode,
      'price': price,
      'status': status,
      'reserved': reserved,
      'isExclusive': isExclusive,
      'activeStatus': activeStatus,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class LocationData {
  double latitude;
  double longitude;

  LocationData({
     required this.latitude,
     required this.longitude,
  });

  factory LocationData.fromJson(Map<String, dynamic> json) {
    String lat = json['latitude'].toString();
    String long = json['longitude'].toString();

    return LocationData(
      latitude: double.parse(lat),
      longitude: double.parse(long),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
