import 'package:spring_pet_clinic_2024_flutter/entity/pet.dart';

class Owner {
  late int id;
  late String? firstName;
  late String? lastName;
  late String? address;
  late String? city;
  late String? telephone;
  final List<Pet> pets = [];
  Owner.fromJson(json) {
    id = json['id'] as int;
    firstName = json['firstName'] as String;
    lastName = json['lastName'] as String;
    address = json['address'] as String;
    city = json['city'] as String;
    telephone = json['telephone'] as String;
    pets.addAll(
        (json['pets'] as List).map((json) => Pet.fromJsonWithoutOwner(json)).toList());
  }
  Owner.fromJsonWithoutPets(json) {
    id = json['id'] as int;
    firstName = json['firstName'] as String;
    lastName = json['lastName'] as String;
    address = json['address'] as String;
    city = json['city'] as String;
    telephone = json['telephone'] as String;
  }

  get fullName => '$firstName\n$lastName';

  get petsShortString => pets.map((pet) => '${pet.petType.emoji} ${pet.name}').join('\n');

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'address': address,
        'city': city,
        'telephone': telephone,
      };
}
