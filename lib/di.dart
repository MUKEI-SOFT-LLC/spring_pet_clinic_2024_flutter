import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:spring_pet_clinic_2021_flutter/dio/pet_clinic_rest_client.dart';

void injectDependencies() {
  GetIt.instance.registerSingleton(PetClinicRestClient());
}
