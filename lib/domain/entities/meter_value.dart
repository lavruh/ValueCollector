import 'package:flutter/material.dart';

class MeterValue {
  final String _id;
  DateTime date;
  int value;
  int? correction;
  MeterValue(this.date, this.value, {this.correction, String? id})
      : _id = id ?? UniqueKey().toString();

  String get id => _id;

  Map<String, dynamic> toJson() {
    return {
      "id": _id,
      "date": date.millisecondsSinceEpoch,
      "value": value,
      "correction": correction ?? 0,
    };
  }

  MeterValue.fromJson(Map<String, dynamic> map)
      : _id = map["id"] ?? UniqueKey().toString(),
        date = DateTime.fromMillisecondsSinceEpoch(map["date"]),
        value = map["value"],
        correction = map["correction"] ?? 0;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MeterValue &&
        other.date == date &&
        other.value == value &&
        other.correction == correction;
  }

  @override
  int get hashCode => date.hashCode ^ value.hashCode ^ correction.hashCode;

  @override
  String toString() =>
      'MeterValue(date: $date, value: $value, correction: $correction)';
}
