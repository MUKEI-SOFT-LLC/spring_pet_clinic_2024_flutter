import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:spring_pet_clinic_2024_flutter/entity/owner.dart';
import 'package:spring_pet_clinic_2024_flutter/entity/pet.dart';
import 'package:spring_pet_clinic_2024_flutter/entity/pet_type.dart';
import 'package:spring_pet_clinic_2024_flutter/entity/specialty.dart';
import 'package:spring_pet_clinic_2024_flutter/entity/veterinarian.dart';

class PetClinicRestClient {
  final Dio _dio = Dio(BaseOptions(
      baseUrl:
      'http://${Platform.isAndroid ? '10.0.2.2' : 'localhost'}:9966/petclinic/api'));

  Stream<List<Pet>> get allPets {
    return _dio.get('/pets').asStream().map((response) =>
        (response.data as List).map((e) => Pet.fromJson(e)).toList());
  }

  Stream<List<Owner>> get allOwners {
    return _dio.get('/owners').asStream().map((response) =>
        (response.data as List).map((e) => Owner.fromJson(e)).toList());
  }

  Stream<List<Veterinarian>> get allVets {
    return _dio.get('/vets').asStream().map((response) =>
        (response.data as List).map((e) => Veterinarian.fromJson(e)).toList());
  }

  Stream<Response> update(Pet pet) {
    final json = jsonEncode(pet);
    return _dio.put('/pets/${pet.id}', data: json).asStream();
  }

  Stream<Response> save(Pet pet) {
    final json = jsonEncode(pet);
    return _dio.post('/pets', data: json).asStream();
  }

  Future<List<Specialty>> get specialties async {
    final response = await _dio.get('/specialties');
    return (response.data as List)
        .map((json) => Specialty.fromJson(json))
        .toList();
  }

  Future<List<PetType>> get petTypes async {
    final response = await _dio.get('/pettypes');
    return (response.data as List)
        .map((json) => PetType.fromJson(json))
        .toList();
  }
}
