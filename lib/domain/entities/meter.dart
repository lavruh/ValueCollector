import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:rh_collector/data/services/db_service.dart';
import 'package:rh_collector/domain/entities/meter_value.dart';

class Meter extends GetxController {
  final String _id;
  String _name;
  String? _unit;
  String groupId;
  int _correction = 0;

  final values = <MeterValue>[].obs;

  final db = Get.find<DbService>();

  Meter({
    String? id,
    required String name,
    required this.groupId,
  })  : _id = id ?? UniqueKey().toString(),
        _name = name {
    getValues();
  }

  String get id => _id;
  String get name => _name;
  String? get unit => _unit;
  int get correction => _correction;

  set correction(int correction) {
    _correction = correction;
  }

  set unit(String? unit) {
    _unit = unit;
    update();
  }

  set name(String name) {
    _name = name;
    update();
  }

  Map<String, dynamic> toJson() {
    return {
      "id": _id,
      "name": name,
      "unit": unit,
      "groupId": groupId,
      "correction": correction,
    };
  }

  Meter.fromJson(Map<String, dynamic> map)
      : _name = map['name'] ?? "",
        _id = map['id'] ?? UniqueKey().toString(),
        _unit = map['unit'],
        groupId = map["groupId"],
        _correction = map["correction"] ?? 0 {
    getValues();
  }

  getValues() {
    db.selectTable(_id);
    values.clear();
    db.getEntries([
      ["date", ""]
    ]).forEach((e) {
      values.add(MeterValue.fromJson(e));
    });
  }

  addValue(MeterValue v) {
    if (!values.contains(v)) {
      values.add(v);
      db.selectTable(_id);
      db.updateEntry(v.toJson());
    }
    update();
  }

  updateValue(MeterValue v) {
    if (values.contains(v)) {
      values.removeWhere((element) => element.id == v.id);
    }
    values.add(v);
    db.selectTable(_id);
    db.updateEntry(v.toJson());
  }

  deleteValue(MeterValue v) {
    if (values.contains(v)) {
      values.removeWhere((element) => element.id == v.id);
      db.selectTable(_id);
      db.removeEntry(v.id);
    }
    update();
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

  @override
  String toString() {
    return 'Meter(_id: $_id, name: $name, unit: $unit, groupId: $groupId)';
  }
}
