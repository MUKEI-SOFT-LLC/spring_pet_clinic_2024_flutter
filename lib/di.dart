import 'package:get/get.dart';
import 'package:spring_pet_clinic_2024_flutter/dio/pet_clinic_rest_client.dart';

Future injectDependencies() async {
  // For REST Client
  Get.put(PetClinicRestClient(), permanent: true);

  // Cache specialities & petTypes.
  final client = Get.find<PetClinicRestClient>();
  return Future.wait([
    Get.putAsync(() => client.specialties, permanent: true),
    Get.putAsync(() => client.petTypes, permanent: true)
  ]);
}
