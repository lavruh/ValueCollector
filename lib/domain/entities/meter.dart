import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:rh_collector/data/services/db_service.dart';
import 'package:rh_collector/domain/entities/meter_value.dart';

class Meter extends GetxController {
  final String _id;
  String name;
  String? unit;
  String groupId;
  final values = <MeterValue>[].obs;

  final db = Get.find<DbService>(tag: "meter");

  Meter({
    String? id,
    required this.name,
    required this.groupId,
  }) : _id = id ?? UniqueKey().toString();

  String get id => _id;

  Map<String, dynamic> toJson() {
    return {
      "id": _id,
      "name": name,
      "unit": unit,
      "groupId": groupId,
    };
  }

  Meter.fromJson(Map<String, dynamic> map)
      : name = map['name'] ?? "",
        _id = map['id'] ?? UniqueKey().toString(),
        unit = map['unit'],
        groupId = map["groupId"];

  getValues() {
    db.getEntries([
      ["date", ""]
    ]).forEach((e) {
      values.add(MeterValue.fromJson(e));
    });
  }

  addValue(MeterValue v) {
    if (!values.contains(v)) {
      values.add(v);
      db.updateEntry(v.toJson());
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Meter &&
        other._id == _id &&
        other.name == name &&
        other.unit == unit &&
        other.groupId == groupId;
  }

  @override
  int get hashCode {
    return _id.hashCode ^ name.hashCode ^ unit.hashCode ^ groupId.hashCode;
  }
}
