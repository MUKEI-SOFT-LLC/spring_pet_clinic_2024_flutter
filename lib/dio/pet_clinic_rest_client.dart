import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';

import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';
import 'package:spring_pet_clinic_2021_flutter/entity/owner.dart';
import 'package:spring_pet_clinic_2021_flutter/entity/pet.dart';
import 'package:spring_pet_clinic_2021_flutter/entity/pet_type.dart';
import 'package:spring_pet_clinic_2021_flutter/entity/specialty.dart';
import 'package:spring_pet_clinic_2021_flutter/entity/veterinarian.dart';

class PetClinicRestClient extends DioForNative {
  PetClinicRestClient()
      : super(BaseOptions(
            baseUrl:
                'http://${Platform.isAndroid ? '10.0.2.2' : 'localhost'}:9966/petclinic/api'));

  Stream<List<Pet>> get allPets {
    return super.get('/pets').asStream().map((response) =>
        (response.data as List).map((e) => Pet.fromJson(e)).toList());
  }

  Stream<List<Owner>> get allOwners {
    return super.get('/owners').asStream().map((response) =>
        (response.data as List).map((e) => Owner.fromJson(e)).toList());
  }

  Stream<List<Veterinarian>> get allVets {
    return super.get('/vets').asStream().map((response) =>
        (response.data as List).map((e) => Veterinarian.fromJson(e)).toList());
  }

  Stream<Response> update(Pet pet) {
    final json = jsonEncode(pet);
    return super.put('/pets/${pet.id}', data: json).asStream();
  }

  Stream<Response> save(Pet pet) {
    final json = jsonEncode(pet);
    return super.post('/pets', data: json).asStream();
  }

  Future<List<Specialty>> get specialties async {
    final response = await super.get('/specialties');
    return (response.data as List)
        .map((json) => Specialty.fromJson(json))
        .toList();
  }

  Future<List<PetType>> get petTypes async {
    final response = await super.get('/pettypes');
    return (response.data as List)
        .map((json) => PetType.fromJson(json))
        .toList();
  }
}
