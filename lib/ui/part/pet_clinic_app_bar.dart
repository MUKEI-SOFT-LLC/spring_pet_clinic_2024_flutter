import 'package:flutter/material.dart';

class PetClinicAppBar extends AppBar {
  PetClinicAppBar()
      : super(
            title: const Text('Pet Clinic 2024'),
            leadingWidth: 220,
            leading:
                Image(
                    image:
                        AssetImage('assets/images/spring-pivotal-logo.png')));
}
