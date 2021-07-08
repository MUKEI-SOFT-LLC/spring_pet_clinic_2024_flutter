class Owner {
  late int id;
  late String? firstName;
  late String? lastName;
  late String? address;
  late String? city;
  late String? telephone;
  Owner.fromJson(json) {
    id = json['id'] as int;
    firstName = json['firstName'] as String;
    lastName = json['lastName'] as String;
    address = json['address'] as String;
    city = json['city'] as String;
    telephone = json['telephone'] as String;
  }

  get fullName => '$firstName $lastName';

  Map<String, dynamic> toJson() => {
    'id': id,
    'firstName': firstName,
    'lastName': lastName,
    'address' : address,
    'city' : city,
    'telephone' : telephone,
  };

}