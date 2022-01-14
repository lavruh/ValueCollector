import 'package:flutter/material.dart';

class MeterValue {
  final String _id;
  DateTime date;
  int _value;
  int _correctedValue;
  int? _correction;

  MeterValue(this.date, this._value, {int? correct, String? id})
      : _id = id ?? UniqueKey().toString(),
        _correctedValue = _value + (correct ?? 0);

  String get id => _id;
  int get correctedValue => _correctedValue;
  int get value => _value;
  set value(int value) {
    _value = value;
    _correctedValue = value + (correction ?? 0);
  }

  int? get correction => _correction;
  set correction(int? correction) {
    _correction = correction;
    _correctedValue = value + (correction ?? 0);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": _id,
      "date": date.millisecondsSinceEpoch,
      "value": value,
      "correction": correction,
    };
  }

  MeterValue.fromJson(Map<String, dynamic> map)
      : _id = map["id"] ?? UniqueKey().toString(),
        date = DateTime.fromMillisecondsSinceEpoch(map["date"]),
        _value = map["value"],
        _correction = map["correction"],
        _correctedValue = map["value"] + (map["correction"] ?? 0);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MeterValue &&
        other._id == _id &&
        other.date == date &&
        other._value == _value &&
        other._correctedValue == _correctedValue &&
        other._correction == _correction;
  }

  @override
  int get hashCode {
    return _id.hashCode ^
        date.hashCode ^
        _value.hashCode ^
        _correctedValue.hashCode ^
        _correction.hashCode;
  }

  @override
  String toString() =>
      'MeterValue(date: $date, value: $_value, correction: $_correction)';
}
