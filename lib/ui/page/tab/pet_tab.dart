import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:spring_pet_clinic_2021_flutter/dio/pet_clinic_rest_client.dart';
import 'package:spring_pet_clinic_2021_flutter/entity/owner.dart';
import 'package:spring_pet_clinic_2021_flutter/entity/pet.dart';
import 'package:spring_pet_clinic_2021_flutter/entity/visit.dart';
import 'package:spring_pet_clinic_2021_flutter/ui/reload_trigger.dart';

final petsReloadProvider = StateProvider<ReloadTrigger>((_) => ReloadTrigger());

final petProvider = StreamProvider<List<Pet>>((ref) {
  ref.watch(petsReloadProvider);
  return GetIt.instance.get<PetClinicRestClient>().allPets;
});

class PetTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final watchedPetProvider = watch(petProvider);
    return watchedPetProvider.when(
      loading: () => Center(child: CircularProgressIndicator()),
      data: (pets) => Stack(children: [
        ListView.builder(
            itemCount: pets.length,
            itemBuilder: (context, index) => _buildCard(context, pets[index])),
      ]),
      error: (Object error, StackTrace? stackTrace) {
        print(stackTrace);
        return Center(
            child: const Text(
          'Sorry an error occurred while reading...',
          style: TextStyle(color: Colors.red),
        ));
      },
    );
  }

  Widget _buildCard(BuildContext context, Pet pet) {
    return Card(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: InkWell(
            onTap: () => _edit(context, pet),
            child: Container(
                padding: EdgeInsets.all(15),
                child: Table(
                  border: TableBorder.all(
                      width: 0, color: Colors.white.withOpacity(0)),
                  children: [
                    TableRow(children: [
                      const Text(
                        'Name',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Text('Birthday',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const Text('Owner',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const Text('Visited?',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ]),
                    TableRow(children: [
                      Row(children: [
                        Text(
                          pet.petType.emoji,
                          textScaleFactor: 1.5,
                        ),
                        Container(width: 5),
                        Text(pet.name ?? '')
                      ]),
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
                ))));
  }

  _edit(BuildContext context, Pet pet) async {
    final reloadProvider = context.read(petsReloadProvider);
    final nameController = TextEditingController(text: pet.name);
    final birthDateController = TextEditingController(text: pet.birthDate);
    final errorMessageController = TextEditingController();
    final progressHud = ProgressHUD(
      barrierEnabled: true,
      child: Builder(
          builder: (progressContext) => Column(
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
                            controller: birthDateController,
                          ))
                    ],
                  ),
                  Container(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.blueGrey),
                          onPressed: () => _cancelEdit(context),
                          child: const Text('cancel')),
                      ElevatedButton(
                          onPressed: () async {
                            // TODO barrier not work completely.
                            final progress = ProgressHUD.of(progressContext)!;
                            pet.name = nameController.value.text;
                            pet.birthDate = birthDateController.value.text;
                            try {
                              progress.show();
                              await GetIt.instance
                                  .get<PetClinicRestClient>()
                                  .save(pet);
                            } on DioError catch (e) {
                              final snackBar = SnackBar(
                                  content: Container(
                                    height: 90,
                                      child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'What went wrong!!',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(e.response!.data.toString())
                                      ])),
                                  duration: Duration(seconds: 10));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } finally {
                              progress.dismiss();
                              Navigator.pop(context, true);
                            }
                          },
                          child: const Text('save'))
                    ],
                  ),
                ],
              )),
    );

    final edit = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(child: progressHud);
        });
    if (edit) {
      print('will reload!');
      reloadProvider.state = ReloadTrigger();
    }
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

  void _cancelEdit(BuildContext context) {
    Navigator.pop(context, false);
  }
}
