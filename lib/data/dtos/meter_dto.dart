import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rh_collector/domain/entities/meter.dart';

class MeterDto {
  final String _id;
  String _name;
  String? _unit;
  String _groupId;
  String _typeId;
  int _correction = 0;

  String get id => _id;
  String get name => _name;

  MeterDto({
    String? id,
    String? name,
    String? unit,
    String? groupId,
    String? typeId,
    int correction = 0,
  })  : _id = id ?? UniqueKey().toString(),
        _name = name ?? "",
        _unit = unit,
        _groupId = groupId ?? "W",
        _typeId = typeId ?? "rh",
        _correction = correction;

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'name': _name,
      'unit': _unit,
      'groupId': _groupId,
      'typeId': _typeId,
      'correction': _correction,
    };
  }

  factory MeterDto.fromMap(Map<String, dynamic> map) {
    return MeterDto(
      id: map['id'],
      name: map['name'],
      unit: map['unit'],
      groupId: map['groupId'],
      typeId: map['typeId'],
      correction: map['correction'] ?? 0,
    );
  }

  Meter toDomain() {
    return Meter(
      id: _id,
      name: _name,
      unit: _unit ?? "",
      groupId: _groupId,
      typeId: _typeId,
      correction: _correction,
    );
  }

  factory MeterDto.fromDomain(Meter m) {
    return MeterDto(
      id: m.id,
      name: m.name,
      unit: m.unit,
      groupId: m.groupId,
      typeId: m.typeId,
      correction: m.correction,
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
  }) {
    return MeterDto(
      id: id ?? _id,
      name: name ?? _name,
      unit: unit ?? _unit,
      groupId: groupId ?? _groupId,
      typeId: typeId ?? _typeId,
      correction: correction ?? _correction,
    );
  }
}
