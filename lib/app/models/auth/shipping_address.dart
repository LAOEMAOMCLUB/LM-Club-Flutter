class ShippingAddress {
  ShippingAddress(
      {this.recipientName,
      this.line1,
      this.city,
      this.postalCode,
      this.phone,
      this.state});

  String? recipientName;
  String? line1;
  String? city;
  String? postalCode;
  String? phone;
  String? state;

  factory ShippingAddress.fromJson(Map<String, dynamic> json) =>
      ShippingAddress(
          recipientName: json["recipient_name"] ?? '',
          line1: json["line1"] ?? '',
          city: json["city"],
          postalCode: json["postal_code"],
          phone: json["phone"],
          state: json["state"]);

  Map<String, dynamic> toJson() => {
        "recipient_name": recipientName,
        "line1": line1,
        "city": city,
        "postal_code": postalCode,
        "phone": phone,
        "state": state
      };
}
