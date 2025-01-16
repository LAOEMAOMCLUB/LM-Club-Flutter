class ServerError {
  ServerError({
    required this.message,
    required this.resultCode,
  });
  late final Message message;
  late final String resultCode;

  ServerError.fromJson(Map<String, dynamic> json) {
    message = Message.fromJson(json['message']);
    resultCode = json['resultCode'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['message'] = message.toJson();
    data['resultCode'] = resultCode;
    return data;
  }
}

class Message {
  Message({
    required this.timestamp,
    required this.system,
    required this.code,
    required this.description,
    required this.extraDetail,
  });
  late final String timestamp;
  late final String system;
  late final int code;
  late final String description;
  late final String extraDetail;

  Message.fromJson(Map<String, dynamic> json) {
    timestamp = json['timestamp'];
    system = json['system'];
    code = json['code'];
    description = json['description'];
    extraDetail = json['extraDetail'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['timestamp'] = timestamp;
    data['system'] = system;
    data['code'] = code;
    data['description'] = description;
    data['extraDetail'] = extraDetail;
    return data;
  }
}
