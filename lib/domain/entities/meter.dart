import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:rh_collector/data/dtos/meter_dto.dart';
import 'package:rh_collector/data/services/db_service.dart';
import 'package:rh_collector/domain/entities/meter_value.dart';

class Meter extends GetxController {
  final String _id;
  String name;
  String? unit;
  String groupId;
  int correction = 0;
  final _type = "rh".obs;
  final values = <MeterValue>[].obs;

  final db = Get.find<DbService>();

  Meter({
    String? id,
    required this.name,
    required this.groupId,
    this.unit,
    String? typeId,
    this.correction = 0,
  }) : _id = id ?? UniqueKey().toString() {
    _type.value = typeId ?? "rh";
    getValues();
  }

  String get id => _id;
  String get typeId => _type.value;

  set typeId(String val) {
    _type.value = val;
  }

  updateDb() async {
    await db.updateEntry(MeterDto.fromDomain(this).toMap(), table: "meters");
  }

  Future<void> getValues() async {
    values.clear();
    List res = await db.getEntries([], table: _id);
    for (var e in res) {
      values.add(MeterValue.fromJson(e));
    }
    values.sort(((a, b) =>
        a.date.millisecondsSinceEpoch - b.date.millisecondsSinceEpoch));
  }

  addValue(MeterValue v) async {
    v.correction ??= correction;
    if (!values.contains(v)) {
      values.add(v);
      await db.updateEntry(v.toJson(), table: _id);
    }
  }

  updateValue(MeterValue v) async {
    int index = values.indexWhere((element) => element.id == v.id);
    if (index == -1) {
      throw Exception("Update failure - Meter value does not exist");
    }
    values[index] = v;
    await db.updateEntry(v.toJson(), table: _id);
  }

  deleteValue(MeterValue v) async {
    if (values.contains(v)) {
      values.removeWhere((element) => element.id == v.id);
      await db.removeEntry(v.id, table: _id);
    }
  }

  int getLastValueCorrected() {
    if (values.isNotEmpty) {
      return values.last.correctedValue;
    } else {
      throw Exception("No values in meter $_id - $name");
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

  Meter copyWith({
    String? id,
    String? name,
    String? unit,
    String? groupId,
    String? typeId,
    int? correction,
  }) {
    return Meter(
      id: id ?? _id,
      name: name ?? this.name,
      unit: unit ?? this.unit,
      groupId: groupId ?? this.groupId,
      typeId: typeId ?? _type.value,
      correction: correction ?? this.correction,
    );
  }
}
