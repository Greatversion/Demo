class AddressModel {
  AddressModel({
    required this.addressId,
    required this.name,
    required this.phoneNumber,
    required this.country,
    required this.state,
    required this.city,
    required this.postcode,
    required this.localAddress,
  });
  final int addressId;
  final String? name;
  final String? phoneNumber;
  final String? country;
  final String? state;
  final String? city;
  final String? postcode;
  final String? localAddress;

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      name: json["name"],
      phoneNumber: json["phone_number"],
      country: json["country"],
      state: json["state"],
      city: json["city"],
      postcode: json["postcode"],
      localAddress: json["local_address"],
      addressId: json['addressId'],
    );
  }

  Map<String, dynamic> toJson() => {
        "addressId": addressId,
        "name": name,
        "phone_number": phoneNumber,
        "country": country,
        "state": state,
        "city": city,
        "postcode": postcode,
        "local_address": localAddress,
      };
}
