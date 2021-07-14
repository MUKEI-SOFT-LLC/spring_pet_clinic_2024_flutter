import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:spring_pet_clinic_2021_flutter/di.dart';
import 'package:spring_pet_clinic_2021_flutter/dio/pet_clinic_rest_client.dart';
import 'package:spring_pet_clinic_2021_flutter/entity/owner.dart';
import 'package:spring_pet_clinic_2021_flutter/entity/pet.dart';
import 'package:spring_pet_clinic_2021_flutter/entity/pet_type.dart';
import 'package:spring_pet_clinic_2021_flutter/ui/page/tab/_util.dart';
import 'package:spring_pet_clinic_2021_flutter/ui/page/tab/pet_tab.dart';
import 'package:spring_pet_clinic_2021_flutter/ui/reload_trigger.dart';

final ownersReloadProvider =
    StateProvider<ReloadTrigger>((_) => ReloadTrigger());

class OwnerTab extends ConsumerWidget {

  static final _ownersProvider = StreamProvider<List<Owner>>((ref) {
    ref.watch(ownersReloadProvider);
    return getIt.get<PetClinicRestClient>().allOwners;
  });

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final watchedOwnerProvider = watch(_ownersProvider);
    return watchedOwnerProvider.when(
        loading: () => Center(child: CircularProgressIndicator()),
        data: (owners) {
          return ListView.builder(
              itemCount: owners.length,
              itemBuilder: (context, index) =>
                  _buildCard(context, owners[index]));
        },
        error: (Object error, StackTrace? stackTrace) {
          print(stackTrace);
          return Center(
              child: const Text(
            'Sorry an error occurred while reading...',
            style: TextStyle(color: Colors.red),
          ));
        });
  }

  _buildCard(BuildContext context, Owner owner) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Expanded(
                child: Table(
              columnWidths: {0: FixedColumnWidth(120), 1: FlexColumnWidth()},
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              border:
                  TableBorder.all(width: 0, color: Colors.white.withOpacity(0)),
              children: [
                TableRow(children: [
                  const Text(
                    'Name',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(owner.fullName)
                ]),
                TableRow(children: [
                  const Text(
                    'Address',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(owner.address ?? '')
                ]),
                TableRow(children: [
                  const Text(
                    'City',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(owner.city ?? '')
                ]),
                TableRow(children: [
                  const Text(
                    'Telephone',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(owner.telephone ?? '')
                ]),
                TableRow(children: [
                  const Text(
                    'Pets',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(owner.petsShortString)
                ]),
              ],
            )),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () => _snowNewPetForm(context, owner),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.lightBlueAccent, shape: CircleBorder()),
                ),
                const Text(
                  'Add new Pet',
                  textScaleFactor: 0.8,
                ),
              ],
            ),
          ])),
    );
  }

  void _snowNewPetForm(BuildContext context, Owner owner) {
    final now = DateTime.now();
    final nameFieldController = TextEditingController();
    final birthDateWidget = _NewPetBirthDateWidget(
        StateProvider<DateTime?>((_) => null), now);
    final petTypeWidget =
        _NewPetDropdownWidget(StateProvider<PetType>((_) => PetType.unknown));
    final errorMessageStateProvider = StateProvider<String>((_) => '');
    showSaveOrCancelDialog<Pet>(
        context: context,
        child: Container(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Name',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(width: 20),
                SizedBox(
                    width: 150,
                    child: TextField(
                      controller: nameFieldController,
                      maxLength: 30,
                    ))
              ],
            ), // TODO should adjust pet.name column size.
            birthDateWidget,
            petTypeWidget,
          ]),
        ),
        preProcessor: () {
          final pet = Pet.from(
              owner,
              nameFieldController.value.text,
              birthDateWidget.selectedBirthDateAsText,
              petTypeWidget.selectedPetType);
          final validatedMessage = _validate(pet);
          if (validatedMessage.isNotEmpty) {
            context.read(errorMessageStateProvider).state =
                validatedMessage.join('\n');
            return null;
          }
          return pet;
        },
        streamResolver: (pet) => getIt.get<PetClinicRestClient>().save(pet),
        onSaved: () {
          context.read(ownersReloadProvider).state = ReloadTrigger();
          context.read(petsReloadProvider).state = ReloadTrigger();
        },
        bottomChild: _ErrorMessageWidget(errorMessageStateProvider));
  }

  List<String> _validate(Pet pet) {
    final List<String> message = [];
    if (null == pet.name || 0 == pet.name!.length) {
      message.add('[Name] must be specified');
    }
    if (null == pet.birthDate || 0 == pet.birthDate!.length) {
      message.add('[Birth date] must be specified');
    }
    if (PetType.unknown == pet.petType) {
      message.add('[Pet type] must be specified');
    }
    return message;
  }
}


class _NewPetDropdownWidget extends ConsumerWidget {
  final StateProvider<PetType> _stateProvider;
  late var _watchedNewPetProvider;

  _NewPetDropdownWidget(this._stateProvider);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    this._watchedNewPetProvider = watch(_stateProvider);
    final dropMenuItems = [
      DropdownMenuItem(
          value: PetType.unknown, child: Text(PetType.unknown.emojiAndName))
    ];
    dropMenuItems.addAll(getIt
        .get<List<PetType>>()
        .map((type) => DropdownMenuItem<PetType>(
              child: Text(type.emojiAndName),
              value: type,
            ))
        .toList());
    return DropdownButton<PetType>(
      items: dropMenuItems,
      onChanged: (type) {
        _watchedNewPetProvider.state = type!;
      },
      value: _watchedNewPetProvider.state,
    );
  }

  PetType get selectedPetType => _watchedNewPetProvider.state;
}

class _NewPetBirthDateWidget extends ConsumerWidget {
  static final formatter = DateFormat('yyyy/MM/dd');

  final StateProvider<DateTime?> _stateProvider;
  final DateTime _now;

  late var _watched;

  _NewPetBirthDateWidget(this._stateProvider, this._now);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    this._watched = watch(_stateProvider);
    return Column(
      children: [
        ElevatedButton(
            onPressed: () async {
              var picked = await showDatePicker(
                  context: context,
                  initialDate: _now,
                  firstDate: _now.subtract(Duration(days: 20 * 365)),
                  lastDate: _now);
              if (null != picked) {
                _watched.state = picked;
              }
            },
            child: const Text('Birth Date')),
        if (null != _watched.state)
          Text(formatter.format(_watched.state)),
      ],
    );
  }

  DateTime? get selectedBirthDate => _watched.state;
  String? get selectedBirthDateAsText =>
      null == selectedBirthDate ? null : formatter.format(selectedBirthDate!);
}

class _ErrorMessageWidget extends ConsumerWidget {
  final StateProvider<String> _stateProvider;
  late var _watched;
  _ErrorMessageWidget(this._stateProvider);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    this._watched = watch(_stateProvider);
    if (null == _watched.state || 0 == _watched.state.length) {
      return Container();
    } else {
      return Container(
          child: Text(
        _watched.state,
        style: TextStyle(color: Colors.red),
      ));
    }
  }
}
