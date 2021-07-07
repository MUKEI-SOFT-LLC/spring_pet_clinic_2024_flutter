import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ui/page/main_page.dart';

void main() async {
  const androidHost = '10.0.2.2';
  const iosHost = 'localhost';
  try {
    print('iku--');
    var hostName = androidHost;
    if (Platform.isIOS) {
      hostName = iosHost;
    }
    final response =
        await new Dio().get('http://$hostName:9966/petclinic/api/pets');
    print(response);
  } catch (e, message) {
    print('$e : $message');
  }
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
