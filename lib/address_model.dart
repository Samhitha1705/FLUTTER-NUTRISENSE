class AddressModel {
  String houseNo;
  String area;
  String city;
  String state;
  String pincode;
  String receiverName;
  String receiverPhone;
  String countryCode;
  bool isDefault;

  AddressModel({
    required this.houseNo,
    required this.area,
    required this.city,
    required this.state,
    required this.pincode,
    required this.receiverName,
    required this.receiverPhone,
    required this.countryCode,
    this.isDefault = false,
  });

  Map<String, dynamic> toJson() {
    return {
      "houseNo": houseNo,
      "area": area,
      "city": city,
      "state": state,
      "pincode": pincode,
      "receiverName": receiverName,
      "receiverPhone": receiverPhone,
      "countryCode": countryCode,
      "isDefault": isDefault,
    };
  }

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      houseNo: json["houseNo"] ?? "",
      area: json["area"] ?? "",
      city: json["city"] ?? "",
      state: json["state"] ?? "",
      pincode: json["pincode"] ?? "",
      receiverName: json["receiverName"] ?? "",
      receiverPhone: json["receiverPhone"] ?? "",
      countryCode: json["countryCode"] ?? "+91",
      isDefault: json["isDefault"] ?? false, // ✅ FIXED HERE
    );
  }
}
