import 'package:spring_pet_clinic_2021_flutter/entity/specialty.dart';

class Veterinarian {
  late int id;
  late String? firstName;
  late String? lastName;
  final List<Specialty> specialties = [];
  Veterinarian.fromJson(json) {
    id = json['id'] as int;
    firstName = json['firstName'] as String;
    lastName = json['lastName'] as String;
    specialties.addAll(
        (json['specialties'] as List).map((e) => Specialty.fromJson(e)));
  }

  String get fullName => '$firstName\n$lastName';
}
