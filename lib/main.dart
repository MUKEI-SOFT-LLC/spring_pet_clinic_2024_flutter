import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:spring_pet_clinic_2024_flutter/di.dart';
import 'package:spring_pet_clinic_2024_flutter/entity/pet_type.dart';
import 'package:spring_pet_clinic_2024_flutter/entity/specialty.dart';

import 'ui/page/main_page.dart';

void main() async {
  await injectDependencies();
  runApp(PetClinicApp());
}

class PetClinicApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spring Pet Clinic by Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(),
    );
  }
}
