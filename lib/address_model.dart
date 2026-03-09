class AddressModel {
  int? id;
  String line1;
  String line2;
  String city;
  String postCode;
  bool defaultAddress;

  AddressModel({
    this.id,
    required this.line1,
    required this.line2,
    required this.city,
    required this.postCode,
    this.defaultAddress = false,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json["id"],
      line1: json["line1"] ?? "",
      line2: json["line2"] ?? "",
      city: json["city"] ?? "",
      postCode: json["postCode"] ?? "",
      defaultAddress: json["defaultAddress"] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "line1": line1,
      "line2": line2,
      "city": city,
      "postCode": postCode,
      "defaultAddress": defaultAddress,
    };
  }
}