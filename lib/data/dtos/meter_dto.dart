import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rh_collector/domain/entities/calculated_meter.dart';
import 'package:rh_collector/domain/entities/meter.dart';
import 'package:rh_collector/domain/entities/meter_value.dart';
import 'package:rh_collector/domain/entities/tank_level_meter.dart';
import 'package:rh_collector/domain/states/meter_types_state.dart';

class MeterDto {
  final String _id;
  String _name;
  String? _unit;
  String _groupId;
  String _typeId;
  int _correction = 0;
  List<String>? _formula;
  String? _soundingTablePath;
  bool? _isUllage;

  final List<MeterValue>? values;

  String get id => _id;
  String get name => _name;

  MeterDto({
    String? id,
    String? name,
    String? unit,
    String? groupId,
    String? typeId,
    int correction = 0,
    List<String>? formula,
    String? soundingTablePath,
    bool? isUllage,
    this.values = const [],
  })  : _id = id ?? UniqueKey().toString(),
        _name = name ?? "",
        _unit = unit,
        _groupId = groupId ?? "W",
        _typeId = typeId ?? "rh",
        _correction = correction,
        _formula = formula,
        _isUllage = isUllage,
        _soundingTablePath = soundingTablePath;

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'name': _name,
      'unit': _unit,
      'groupId': _groupId,
      'typeId': _typeId,
      'correction': _correction,
      "formula": _formula,
      "isUllage": _isUllage,
      "soundingTablePath": _soundingTablePath,
    };
  }

  factory MeterDto.fromMap(Map<String, dynamic> map) {
    final formula = (map['formula'] as List?)?.map((e) => '$e').toList() ?? [];
    return MeterDto(
      id: map['id'],
      name: map['name'],
      unit: map['unit'],
      groupId: map['groupId'],
      typeId: map['typeId'],
      correction: map['correction'] ?? 0,
      formula: formula,
      isUllage: map['isUllage'],
      soundingTablePath: map['soundingTablePath'],
    );
  }

  Meter toDomain() {
    if (_typeId == DefaultMeterTypes.calc.value.id) {
      return CalculatedMeter(
        id: _id,
        name: _name,
        unit: _unit ?? "",
        groupId: _groupId,
        correction: _correction,
        formula: _formula ?? <String>[],
        values: values ?? [],
      );
    }
    if (_typeId == DefaultMeterTypes.tank.value.id) {
      return TankLevelMeter(
        id: _id,
        name: _name,
        unit: _unit ?? "",
        groupId: _groupId,
        correction: _correction,
        values: values ?? [],
        isUllage: _isUllage ?? false,
        soundingTablePath: _soundingTablePath,
      );
    }
    return Meter(
      id: _id,
      name: _name,
      unit: _unit ?? "",
      groupId: _groupId,
      typeId: _typeId,
      correction: _correction,
      values: values ?? [],
    );
  }

  factory MeterDto.fromDomain(Meter m) {
    if (m is CalculatedMeter) {
      return MeterDto(
        id: m.id,
        name: m.name,
        unit: m.unit,
        groupId: m.groupId,
        typeId: m.typeId,
        correction: m.correction,
        formula: m.formula,
        values: m.values,
      );
    }
    if (m is TankLevelMeter) {
      return MeterDto(
        id: m.id,
        name: m.name,
        unit: m.unit,
        groupId: m.groupId,
        typeId: m.typeId,
        correction: m.correction,
        soundingTablePath: m.soundingTablePath,
        isUllage: m.isUllage,
        values: m.values,
      );
    }
    return MeterDto(
      id: m.id,
      name: m.name,
      unit: m.unit,
      groupId: m.groupId,
      typeId: m.typeId,
      correction: m.correction,
      values: m.values,
    );
  }

  String toJson() => json.encode(toMap());

  factory MeterDto.fromJson(String source) =>
      MeterDto.fromMap(json.decode(source));

  MeterDto copyWith({
    String? id,
    String? name,
    String? unit,
    String? groupId,
    String? typeId,
    int? correction,
    List<String>? formula,
    bool? isUllage,
    String? soundingTablePath,
    List<MeterValue>? values,
  }) {
    return MeterDto(
      id: id ?? _id,
      name: name ?? _name,
      unit: unit ?? _unit,
      groupId: groupId ?? _groupId,
      typeId: typeId ?? _typeId,
      correction: correction ?? _correction,
      formula: formula ?? _formula,
      isUllage: isUllage ?? _isUllage,
      soundingTablePath: soundingTablePath ?? _soundingTablePath,
      values: values ?? this.values,
    );
  }
}
