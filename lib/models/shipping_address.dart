class ShippingAddress {
  String shippingTo;
  String firstName;
  String lastName;
  String country;
  String address;
  String city;
  String state;
  String postalCode;
  String phoneNumber;

  ShippingAddress({
    this.shippingTo = 'Home',
    this.firstName = '',
    this.lastName = '',
    this.country = 'Sri Lanka',
    this.address = '',
    this.city = '',
    this.state = '',
    this.postalCode = '',
    this.phoneNumber = '',
  });

  Map<String, dynamic> toJson() => {
    'shippingTo': shippingTo,
    'firstName': firstName,
    'lastName': lastName,
    'country': country,
    'address': address,
    'city': city,
    'state': state,
    'postalCode': postalCode,
    'phoneNumber': phoneNumber,
  };

  factory ShippingAddress.fromJson(Map<String, dynamic> json) =>
      ShippingAddress(
        shippingTo: json['shippingTo'] ?? 'Home',
        firstName: json['firstName'] ?? '',
        lastName: json['lastName'] ?? '',
        country: json['country'] ?? 'Sri Lanka',
        address: json['address'] ?? '',
        city: json['city'] ?? '',
        state: json['state'] ?? '',
        postalCode: json['postalCode'] ?? '',
        phoneNumber: json['phoneNumber'] ?? '',
      );
}
