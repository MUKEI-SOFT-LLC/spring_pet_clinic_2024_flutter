import 'package:get_it/get_it.dart';
import 'package:spring_pet_clinic_2021_flutter/dio/pet_clinic_rest_client.dart';

final getIt = GetIt.instance;
void injectDependencies() {
  getIt
    ..registerSingleton(PetClinicRestClient())
    ..registerSingletonAsync(
        () async => await getIt.get<PetClinicRestClient>().specialties)
    ..registerSingletonAsync(
        () async => await getIt.get<PetClinicRestClient>().petTypes);
}
