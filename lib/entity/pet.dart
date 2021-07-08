import 'package:spring_pet_clinic_2021_flutter/entity/owner.dart';
import 'package:spring_pet_clinic_2021_flutter/entity/pet_type.dart';
import 'package:spring_pet_clinic_2021_flutter/entity/visit.dart';

class Pet {
  late String? birthDate;
  late int id;
  late String? name;
  late Owner owner;
  final List<Visit> visits = [];
  late PetType petType;
  Pet.fromJson(json) {
    name = json['name'] as String;
    birthDate = json['birthDate'] as String;
    id = json['id'] as int;
    owner = Owner.fromJson(json['owner']);
    visits.addAll((json['visits'] as List).map((e) => Visit.fromJson(e)).toList());
    petType = PetType.fromJson(json['type']);
  }
  Map<String, dynamic> toJson() => {
      'id': id,
      'birthDate' : birthDate,
      'name': name,
      'owner' : owner.toJson(),
      'type': petType.toJson(),
  };

}