

class ImageModel {
  ImageModel({
    this.fieldname,
    this.size,
    this.buffer,
    this.originalname,
    this.mimetype,
    this.encoding
    // this.url,
  });

  String? fieldname;
  int? size;
  String? buffer;
  String? originalname;
  String? mimetype;
  String? encoding;
  // String? url;

  factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
        fieldname: json["fieldname"] ?? '',
        size: json["size"] ?? 0,
        buffer: json["buffer"],
        originalname: json["originalname"],
        mimetype: json["mimetype"],
        encoding: json["encoding"]
      );
  // url: json['url']);

  Map<String, dynamic> toJson() => {
    "fieldname": fieldname, 
    "size": size,
     "buffer": buffer,
     "originalname" : originalname,
     "mimetype" : mimetype,};
}
