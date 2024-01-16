import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:spring_pet_clinic_2024_flutter/dio/pet_clinic_rest_client.dart';
import 'package:spring_pet_clinic_2024_flutter/entity/owner.dart';
import 'package:spring_pet_clinic_2024_flutter/entity/pet.dart';
import 'package:spring_pet_clinic_2024_flutter/entity/pet_type.dart';
import 'package:spring_pet_clinic_2024_flutter/ui/page/tab/_util.dart';
import 'package:spring_pet_clinic_2024_flutter/ui/page/tab/pet_tab.dart';

class OwnerTab extends GetView<OwnerTabController> {
  @override
  Widget build(BuildContext context) {
    Get.put(OwnerTabController());
    return controller.obx(
        (owners) {
          return ListView.builder(
              itemCount: owners!.length,
              itemBuilder: (context, index) =>
                  _buildCard(context, owners[index]));
        },
        onLoading: Center(child: CircularProgressIndicator()),
        onError: (error) {
          print(error);
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
                      backgroundColor: Colors.lightBlueAccent,
                      shape: CircleBorder()),
                ),
                const Text(
                  'Add new Pet',
                  textScaler: TextScaler.linear(0.8),
                ),
              ],
            ),
          ])),
    );
  }

  void _snowNewPetForm(BuildContext context, Owner owner) {

    final nameFieldController = TextEditingController();

    final birthDateWidget = _initControllerAndWidget<_NewPetBirthDateWidgetController, _NewPetBirthDateWidget>(
            () => _NewPetBirthDateWidgetController(),
            (controller) => _NewPetBirthDateWidget(controller),
            (controller) => controller.updateBirthDate(DateTime.now()));

    final petTypeWidget = _initControllerAndWidget(
            () => _NewPetDropdownWidgetController(),
            (controller) => _NewPetDropdownWidget(controller),
            (controller) => controller.updatePetType(PetType.unknown));

    final errorMessageWidget = _initControllerAndWidget(
            () => _ErrorMessageController(),
            (controller) => _ErrorMessageWidget(controller),
            (controller) => controller.updateMessage(''));

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
            Get.find<_ErrorMessageController>()
                .updateMessage(validatedMessage.join('\n'));
            return null;
          }
          return pet;
        },
        streamResolver: (pet) => Get.find<PetClinicRestClient>().save(pet),
        onSaved: () {
          Get.find<OwnerTabController>().reload();
          if (Get.isRegistered<PetTabController>()) {
            Get.find<PetTabController>().reload();
          }
        },
        bottomChild: errorMessageWidget);
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

class OwnerTabController extends GetxController with StateMixin<List<Owner>> {
  @override
  void onInit() async {
    load();
    super.onInit();
  }

  void load() {
    change(List.empty(), status: RxStatus.loading());
    Get.find<PetClinicRestClient>().allOwners.listen(
        (data) => change(data, status: RxStatus.success()), onError: (error) {
      print(error.toString());
      change(List.empty(), status: RxStatus.error(error.toString()));
    });
  }

  void reload() => load();
}

class _NewPetDropdownWidget extends StatelessWidget {
  final _NewPetDropdownWidgetController controller;

  _NewPetDropdownWidget(this.controller);

  @override
  Widget build(BuildContext context) {
    final dropMenuItems = [
      DropdownMenuItem(
          value: PetType.unknown, child: Text(PetType.unknown.emojiAndName))
    ];
    dropMenuItems.addAll(Get.find<List<PetType>>()
        .map((type) => DropdownMenuItem<PetType>(
              child: Text(type.emojiAndName),
              value: type,
            ))
        .toList());
    return Obx(() => DropdownButton<PetType>(
          items: dropMenuItems,
          onChanged: (type) {
            controller.updatePetType(type!);
          },
          value: selectedPetType,
        ));
  }

  PetType get selectedPetType => controller.petType.value;
}

class _NewPetDropdownWidgetController {
  var petType = Rx<PetType>(PetType.unknown);
  void updatePetType(PetType pt) {
    petType.value = pt;
  }
}

class _NewPetBirthDateWidget extends StatelessWidget {
  static final formatter = DateFormat('yyyy/MM/dd');
  final _NewPetBirthDateWidgetController controller;

  _NewPetBirthDateWidget(this.controller);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
            onPressed: () async {
              var picked = await showDatePicker(
                  context: context,
                  initialDate: selectedBirthDate,
                  firstDate:
                      selectedBirthDate.subtract(Duration(days: 20 * 365)),
                  lastDate: selectedBirthDate);
              if (null != picked) {
                controller.updateBirthDate(picked);
              }
            },
            child: const Text('Birth Date')),
        Obx(() => Text(selectedBirthDateAsText))
      ],
    );
  }

  DateTime get selectedBirthDate => controller.birthDate.value;
  String get selectedBirthDateAsText => formatter.format(selectedBirthDate);
}

class _NewPetBirthDateWidgetController {
  var birthDate = Rx<DateTime>(DateTime.now());

  void updateBirthDate(DateTime dt) {
    birthDate.value = dt;
  }
}

class _ErrorMessageWidget extends StatelessWidget {
  final _ErrorMessageController controller;
  _ErrorMessageWidget(this.controller);

  @override
  Widget build(context) {
    return Container(
        child: Obx(() => Text(
              "${controller.message}",
              style: TextStyle(color: Colors.red),
            )));
  }
}

class _ErrorMessageController {
  var message = ''.obs;
  void updateMessage(String msg) {
    message.value = msg;
  }
}

typedef ControllerCreator<CT> = CT Function();
typedef WidgetCreator<CT, WT> = WT Function(CT controller);
typedef ControllerResetter<CT> = void Function(CT controller);

WT _initControllerAndWidget<CT, WT>(ControllerCreator<CT> ifControllerAbsent, WidgetCreator<CT, WT> ifWidgetAbsent, ControllerResetter<CT> ifControllerPresent) {
  if (Get.isRegistered<CT>()) {
    ifControllerPresent(Get.find<CT>());
  } else {
    final CT controller = Get.put(ifControllerAbsent());
    Get.put(ifWidgetAbsent(controller));
  }
  return Get.find<WT>();
}