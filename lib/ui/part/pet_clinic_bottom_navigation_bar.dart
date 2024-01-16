import 'package:flutter/material.dart';

class PetClinicBottomNavigationBar extends BottomNavigationBar {
  final currentIndex;
  PetClinicBottomNavigationBar(this.currentIndex, ValueChanged onTap)
      : super(
            type: BottomNavigationBarType.fixed,
            onTap: onTap,
            currentIndex: currentIndex,
            backgroundColor: const Color.fromARGB(255, 95, 161, 34),
            selectedItemColor: Colors.white,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
              BottomNavigationBarItem(icon: Icon(Icons.people), label: 'owner'),
              BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'pet'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.local_hospital_outlined),
                  label: 'veterinarians'),
            ]);
}
