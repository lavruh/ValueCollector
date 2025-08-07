import 'package:flutter/material.dart';

import 'package:rh_collector/domain/entities/meter_value.dart';

class Meter {
  final String id;
  final String name;
  final String unit;
  final String groupId;
  final int correction;
  final String typeId;
  final List<MeterValue> values;

  Meter({
    String? id,
    required this.name,
    this.unit = "",
    this.typeId = "rh",
    this.groupId = "W",
    this.correction = 0,
    this.values = const [],
  }) : id = id ?? UniqueKey().toString();

  Meter._({
    required this.id,
    required this.name,
    required this.unit,
    required this.typeId,
    required this.groupId,
    required this.correction,
    required this.values,
  });

  MeterValue processValue(MeterValue v) {
    v.correction ??= correction;
    return v;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Meter &&
        other.id == id &&
        other.name == name &&
        other.unit == unit &&
        other.groupId == groupId &&
        other.typeId == typeId &&
        other.correction == correction &&
        other.values == values;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        unit.hashCode ^
        groupId.hashCode ^
        typeId.hashCode ^
        correction.hashCode ^
        values.hashCode;
  }

  @override
  String toString() {
    return 'Meter(id: $id, name: $name, unit: $unit, groupId: $groupId)';
    // return 'Meter(_id: $id, \nname: $name, \nunit: $unit, \ngroupId: $groupId, \ntypeId: $typeId, \ncorrection: $correction, \nvalues: $values)';
  }

  Meter copyWith({
    String? id,
    String? name,
    String? unit,
    String? groupId,
    String? typeId,
    int? correction,
    List<MeterValue>? values,
  }) {
    return Meter._(
      id: id ?? this.id,
      name: name ?? this.name,
      unit: unit ?? this.unit,
      groupId: groupId ?? this.groupId,
      typeId: typeId ?? this.typeId,
      correction: correction ?? this.correction,
      values: values ?? this.values,
    );
  }

  int getLastValueCorrected() {
    if (values.isNotEmpty) {
      return values.last.correctedValue;
    } else {
      throw Exception("No values in meter $id - $name");
    }
  }
}
