import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rh_collector/domain/entities/meter_value.dart';

class MeterValueDto {
  final String _id;
  DateTime _date;
  num _value;
  num? _correction;

  MeterValueDto({
    String? id,
    DateTime? date,
    num value = 0,
    num correction = 0,
  })  : _id = id ?? UniqueKey().toString(),
        _date = date ?? DateTime.now(),
        _value = value,
        _correction = correction;

  factory MeterValueDto.fromDomain(MeterValue val) {
    return MeterValueDto(
      id: val.id,
      date: val.date,
      value: val.value,
      correction: val.correction ?? 0,
    );
  }

  MeterValue toDomain() {
    return MeterValue(
      _date,
      _value,
      id: _id,
      correct: _correction,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'date': _date.millisecondsSinceEpoch,
      'value': _value,
      'correction': _correction,
    };
  }

  factory MeterValueDto.fromMap(Map<String, dynamic> map) {
    return MeterValueDto(
      id: map['id'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      value: map['value'] ?? 0,
      correction: map['correction'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory MeterValueDto.fromJson(String source) =>
      MeterValueDto.fromMap(json.decode(source));

  MeterValueDto copyWith({
    String? id,
    DateTime? date,
    num? value,
    num? correction,
  }) {
    return MeterValueDto(
      id: id ?? _id,
      date: date ?? _date,
      value: value ?? _value,
      correction: correction ?? _correction ?? 0,
    );
  }
}
