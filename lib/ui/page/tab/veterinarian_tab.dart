import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spring_pet_clinic_2024_flutter/dio/pet_clinic_rest_client.dart';
import 'package:spring_pet_clinic_2024_flutter/entity/specialty.dart';
import 'package:spring_pet_clinic_2024_flutter/entity/veterinarian.dart';

class VeterinarianTab extends GetView<_VeterinarianTabController> {
  @override
  Widget build(BuildContext context) {
    Get.put(_VeterinarianTabController());
    return controller.obx(
      (vets) {
        final rows = vets!
            .map((v) => TableRow(children: [
                  Container(
                      padding: EdgeInsets.all(5), child: Text(v.fullName)),
                  Container(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        children: [
                          ...v.specialties
                              .map((s) => Container(
                                    child: s.icon,
                                    padding: EdgeInsets.only(right: 3),
                                  ))
                              .toList()
                        ],
                      )),
                ]))
            .toList();
        return Stack(children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: Table(
              border: TableBorder.symmetric(
                  inside: BorderSide(
                      color: const Color.fromARGB(255, 95, 161, 34),
                      width: 1,
                      style: BorderStyle.solid)),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 95, 161, 34)),
                    children: [
                      const Center(
                          child: Text(
                        'Name',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      )),
                      const Center(
                          child: Text(
                        'Specialties',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      )),
                    ]),
                ...rows,
              ],
            ),
          ),
          Container(
              color: Colors.white.withOpacity(0.0),
              alignment: Alignment.centerRight,
              child: Container(
                height: 100,
                width: 100,
                child: Column(
                  children: [
                    ...Get.find<List<Specialty>>().map((s) => Row(
                          children: [
                            s.icon,
                            Container(
                                padding: EdgeInsets.only(left: 5),
                                child: Text(
                                  s.name!,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ))
                          ],
                        ))
                  ],
                ),
                //color: Colors.white.withOpacity(0.0),
              ))
        ]);
      },
      onError: (error) {
        return Center(
            child: const Text(
          'Sorry an error occurred while reading...',
          style: TextStyle(color: Colors.red),
        ));
      },
      onLoading: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _VeterinarianTabController extends GetxController with StateMixin<List<Veterinarian>> {
  @override
  void onInit() async {
    change(List.empty(), status: RxStatus.loading());
    Get.find<PetClinicRestClient>().allVets.listen(
        (data) => change(data, status: RxStatus.success()), onError: (error) {
      print(error.toString());
      change(List.empty(), status: RxStatus.error(error.toString()));
    });
    super.onInit();
  }
}
