import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spring_pet_clinic_2024_flutter/dio/pet_clinic_rest_client.dart';
import 'package:spring_pet_clinic_2024_flutter/entity/owner.dart';
import 'package:spring_pet_clinic_2024_flutter/entity/pet.dart';
import 'package:spring_pet_clinic_2024_flutter/entity/visit.dart';
import 'package:spring_pet_clinic_2024_flutter/ui/page/tab/_util.dart';
import 'package:spring_pet_clinic_2024_flutter/ui/page/tab/owner_tab.dart';

class PetTab extends GetView<PetTabController> {

  @override
  Widget build(BuildContext context) {
    Get.put(PetTabController());
    return controller.obx((pets) {
      return Stack(children: [
        ListView.builder(
            itemCount: pets!.length,
            itemBuilder: (context, index) => _buildCard(context, pets[index])),
      ]);
    }, onError: (error) {
      print(error);
      return Center(
          child: const Text(
        'Sorry an error occurred while reading...',
        style: TextStyle(color: Colors.red),
      ));
    }, onLoading: Center(child: CircularProgressIndicator()));
  }

  Widget _buildCard(BuildContext context, Pet pet) {
    return Card(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: InkWell(
            onTap: () => _showPetEditDialog(context, pet),
            child: Container(
              padding: EdgeInsets.all(15),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    pet.petType.emoji,
                    textScaler: TextScaler.linear(2.0),
                  ),
                  Table(
                    border: TableBorder.all(
                        width: 0, color: Colors.white.withOpacity(0)),
                    children: [
                      TableRow(children: [
                        const Text(
                          'Name',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Text('Birthday',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        const Text('Owner',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        const Text('Visited?',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ]),
                      TableRow(children: [
                        Container(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(pet.name ?? '')),
                        Container(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              pet.birthDate ?? '',
                            )),
                        TextButton(
                            child: Text(pet.owner.fullName ?? ''),
                            onPressed: () => _showOwner(context, pet.owner),
                            style: TextButton.styleFrom(
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.only(left: 0, top: 0),
                            )),
                        if (pet.visits.isNotEmpty)
                          TextButton(
                              child: const Text('Show'),
                              style: TextButton.styleFrom(
                                alignment: Alignment.topLeft,
                                padding: EdgeInsets.only(left: 0, top: 0),
                              ),
                              onPressed: () => _showVisits(context, pet.visits))
                        else
                          Container(
                              padding: EdgeInsets.only(top: 5),
                              child: Text('None')),
                      ]),
                    ],
                  ),
                ],
              ),
            )));
  }

  _showPetEditDialog(BuildContext context, Pet pet) {
    final nameController = TextEditingController(text: pet.name);
    final birthDateController = TextEditingController(text: pet.birthDate);
    showSaveOrCancelDialog<Pet>(
        context: context,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Name',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                    width: 150,
                    child: TextField(
                      maxLines: 1,
                      controller: nameController,
                      decoration: InputDecoration(
                        border: null,
                        counterStyle: null,
                        counter: null,
                      ),
                    ))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Birth\nDate',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                    width: 150,
                    child: TextField(
                      maxLines: 1,
                      maxLength: 10,
                      controller: birthDateController,
                    ))
              ],
            ),
          ],
        ),
        preProcessor: () {
          pet.name = nameController.value.text;
          pet.birthDate = birthDateController.value.text;
          return pet;
        },
        streamResolver: (pet) => Get.find<PetClinicRestClient>().update(pet),
        onSaved: () {
          controller.reload();
          if (Get.isRegistered<OwnerTabController>()) {
            Get.find<OwnerTabController>().reload();
          }
        });
  }

  _showOwner(BuildContext context, Owner owner) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text('Owner'),
              content: Table(
                border: TableBorder.all(
                    width: 0, color: Colors.white.withOpacity(0)),
                children: [
                  TableRow(children: [
                    const Text(
                      'first name',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(owner.firstName ?? '')
                  ]),
                  TableRow(children: [
                    const Text(
                      'last name',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(owner.lastName ?? '')
                  ]),
                  TableRow(children: [
                    const Text(
                      'address',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(owner.address ?? '')
                  ]),
                  TableRow(children: [
                    const Text(
                      'city',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(owner.city ?? '')
                  ]),
                  TableRow(children: [
                    const Text(
                      'telephone',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(owner.telephone ?? '')
                  ]),
                ],
              ));
        });
  }

  _showVisits(BuildContext context, List<Visit> visits) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text('Visits'),
              content: Table(
                border: TableBorder.all(
                    width: 0, color: Colors.white.withOpacity(0)),
                children: [
                  TableRow(children: [
                    const Text(
                      'date',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'description',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ]),
                  ...visits
                      .map((v) => TableRow(children: [
                            Text(v.date ?? ''),
                            Text(v.description ?? '')
                          ]))
                      .toList()
                ],
              ));
        });
  }
}

class PetTabController extends GetxController with StateMixin<List<Pet>> {

  @override
  void onInit() async {
    load();
    super.onInit();
  }

  void load() {
    change(List.empty(), status: RxStatus.loading());
    Get.find<PetClinicRestClient>().allPets.listen(
        (data) => change(data, status: RxStatus.success()), onError: (error) {
      print(error.toString());
      change(List.empty(), status: RxStatus.error(error.toString()));
    });
  }
  void reload() => load();
}
