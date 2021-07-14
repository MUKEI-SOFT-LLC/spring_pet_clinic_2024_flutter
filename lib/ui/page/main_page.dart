import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spring_pet_clinic_2021_flutter/ui/page/tab/home_tab.dart';
import 'package:spring_pet_clinic_2021_flutter/ui/page/tab/owner_tab.dart';
import 'package:spring_pet_clinic_2021_flutter/ui/page/tab/pet_tab.dart';
import 'package:spring_pet_clinic_2021_flutter/ui/page/tab/veterinarian_tab.dart';
import 'package:spring_pet_clinic_2021_flutter/ui/part/pet_clinic_app_bar.dart';
import 'package:spring_pet_clinic_2021_flutter/ui/part/pet_clinici_bottom_navigation_bar.dart';

typedef TabPageResolver = Widget Function();

class MainPage extends ConsumerWidget {

  final _tabIndexProvider = StateProvider<int>((ref) => 0);
  
  final List<TabPageResolver> bodyResolver = [
    () => HomeTab(),
    () => OwnerTab(),
    () => PetTab(),
    () => VeterinarianTab(),
  ];

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    var watched = watch(_tabIndexProvider);
    return Scaffold(
      appBar: PetClinicAppBar(),
      body: bodyResolver[watched.state](),
      bottomNavigationBar: PetClinicBottomNavigationBar(
          watched.state, (tabIndex) => watched.state = tabIndex),
    );
  }
}
