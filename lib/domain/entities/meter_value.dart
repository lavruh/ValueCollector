import 'package:flutter/material.dart';

class MeterValue {
  final String _id;
  DateTime date;
  num _value;
  num _correctedValue;
  num? _correction;
  String? remark;

  MeterValue(this.date, this._value, {num? correct, String? id})
      : _id = id ?? UniqueKey().toString(),
        _correction = correct,
        _correctedValue = _value + (correct ?? 0);

  MeterValue.current(this._value, {num? correct, String? id, this.remark})
      : _id = id ?? UniqueKey().toString(),
        date = DateTime.now(),
        _correction = correct,
        _correctedValue = _value + (correct ?? 0);

  MeterValue._(this._id, this.date, this._value, this._correctedValue,
      this._correction, this.remark);

  String get id => _id;
  num get correctedValue => _correctedValue;
  num get value => _value;
  set value(num value) {
    _value = value;
    _correctedValue = value + (correction ?? 0);
  }

  num? get correction => _correction;
  set correction(num? correction) {
    _correction = correction;
    _correctedValue = value + (correction ?? 0);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": _id,
      "date": date.millisecondsSinceEpoch,
      "value": value,
      "correction": correction,
      "correctedValue": correctedValue,
      "remark": remark,
    };
  }

  MeterValue.fromJson(Map<String, dynamic> map)
      : _id = map["id"] ?? UniqueKey().toString(),
        date = DateTime.fromMillisecondsSinceEpoch(map["date"]),
        _value = map["value"],
        _correction = map["correction"],
        _correctedValue =
            map["correctedValue"] ?? (map["value"] + (map["correction"] ?? 0)),
        remark = map["remark"];

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MeterValue &&
        other._id == _id &&
        other.date == date &&
        other._value == _value &&
        other._correctedValue == _correctedValue &&
        other._correction == _correction &&
        other.remark == remark;
  }

  @override
  int get hashCode {
    return _id.hashCode ^
        date.hashCode ^
        _value.hashCode ^
        _correctedValue.hashCode ^
        _correction.hashCode ^
        remark.hashCode;
  }

  @override
  String toString() =>
      'MeterValue(date: $date, value: $_value, correction: $_correction)';

  MeterValue copyWith({
    String? id,
    DateTime? date,
    num? value,
    num? correctedValue,
    num? correction,
    String? remark,
  }) {
    return MeterValue._(
      id ?? _id,
      date ?? this.date,
      value ?? _value,
      correctedValue ?? _correctedValue,
      correction ?? _correction,
      remark ?? this.remark,
    );
  }
}
