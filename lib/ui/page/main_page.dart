import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spring_pet_clinic_2024_flutter/ui/page/tab/home_tab.dart';
import 'package:spring_pet_clinic_2024_flutter/ui/page/tab/owner_tab.dart';
import 'package:spring_pet_clinic_2024_flutter/ui/page/tab/pet_tab.dart';
import 'package:spring_pet_clinic_2024_flutter/ui/page/tab/veterinarian_tab.dart';
import 'package:spring_pet_clinic_2024_flutter/ui/part/pet_clinic_app_bar.dart';
import 'package:spring_pet_clinic_2024_flutter/ui/part/pet_clinic_bottom_navigation_bar.dart';

typedef TabPageResolver = Widget Function();

class MainPage extends StatelessWidget {

  final List<TabPageResolver> bodyResolver = [
    () => HomeTab(),
    () => OwnerTab(),
    () => PetTab(),
    () => VeterinarianTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(_MainPageController());
    return Obx(() => Scaffold(
      appBar: PetClinicAppBar(),
      body: bodyResolver[controller.tabIndex.value](),
      bottomNavigationBar: PetClinicBottomNavigationBar(
          controller.tabIndex.value, (tabIndex) => controller.updateTabIndex(tabIndex)),
    ));
  }
}

class _MainPageController {
  final tabIndex = 0.obs;
  updateTabIndex(int i) {
    tabIndex.value = i;
  }
}
