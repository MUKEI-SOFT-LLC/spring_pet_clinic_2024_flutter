
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spring_pet_clinic_2021_flutter/di.dart';

import 'ui/page/main_page.dart';

void main() async {
  injectDependencies();
  runApp(ProviderScope(child: PetClinicApp()));
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
