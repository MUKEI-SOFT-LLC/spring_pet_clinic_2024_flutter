import 'package:flutter/material.dart';

class Specialty {
  late int id;
  late String? name;
  Specialty.fromJson(json) {
    id = json['id'] as int;
    name = json['name'] as String;
  }

  Icon get _icon =>
      Icon(IconData(name!.codeUnitAt(0)), size: 20, color: Colors.white);
  Color get _color {
    var color = Colors.white;
    switch(id) {
      case 1:
        color = Colors.brown;
        break;
      case 2:
        color = Colors.blue;
        break;
      case 3:
        color = Colors.amber;
        break;
    }
    return color;
  }

  Widget get icon {
    return Container(
      child: _icon,
      padding: EdgeInsets.only(bottom: 5),
      decoration: ShapeDecoration(
          shape: CircleBorder(),
          color: _color),
    );
  }

}
