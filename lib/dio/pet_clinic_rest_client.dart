import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';

import 'package:spring_pet_clinic_2021_flutter/entity/pet.dart';

class PetClinicRestClient extends DioForNative {
  PetClinicRestClient()
      : super(BaseOptions(
            baseUrl:
                'http://${Platform.isAndroid ? '10.0.2.2' : 'localhost'}:9966/petclinic/api'));

  Stream<List<Pet>> get allPets {
    return super.get('/pets').asStream().map((response) =>
        (response.data as List).map((e) => Pet.fromJson(e)).toList());
  }

  Future<Response> save(Pet pet) {
    final json = jsonEncode(pet);
    return super.put('/pets/${pet.id}', data: json);
  }
}
