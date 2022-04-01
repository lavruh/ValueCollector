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

  updateDb() async {
    await db.updateEntry(toJson(), table: "meters");
  }

  getValues() async {
    values.clear();
    List res = await db.getEntries([], table: _id);
    res.forEach((e) {
      values.add(MeterValue.fromJson(e));
    });
    update();
  }

  addValue(MeterValue v) async {
    v.correction ??= _correction;
    if (!values.contains(v)) {
      values.add(v);
      await db.updateEntry(v.toJson(), table: _id);
    }
    update();
  }

  updateValue(MeterValue v) async {
    await db.updateEntry(v.toJson(), table: _id);
  }

  deleteValue(MeterValue v) async {
    if (values.contains(v)) {
      values.removeWhere((element) => element.id == v.id);
      await db.removeEntry(v.id, table: _id);
    }
    update();
  }

  int getLastValueCorrected() {
    if (values.isNotEmpty) {
      return values.last.correctedValue;
    } else {
      throw Exception("No values in meter $_id - $_name");
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

  @override
  String toString() {
    return 'Meter(_id: $_id, name: $name, unit: $unit, groupId: $groupId)';
  }
}
