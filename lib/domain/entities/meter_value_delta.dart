import 'package:flutter/material.dart';
import 'package:rh_collector/domain/entities/meter_value.dart';

class MeterValueDelta {
  late int _delta;
  late Color _color;
  late DateTimeRange _dateRange;
  MeterValueDelta({
    required MeterValue v1,
    required MeterValue v2,
  }) {
    _delta = v2.correctedValue - v1.correctedValue;
    try {
      _dateRange = DateTimeRange(start: v1.date, end: v2.date);
    } catch (e) {
      _dateRange = DateTimeRange(start: v1.date, end: v1.date);
    }
    _color = Colors.black;
    if (_delta < 0) {
      _color = Colors.redAccent;
    }
    if (_delta > _dateRange.duration.inHours) {
      _color = Colors.redAccent;
    }
  }

  int get delta => _delta;
  Color get color => _color;
  DateTimeRange get dateRange => _dateRange;

  @override
  String toString() =>
      'MeterValueDelta(_delta: $_delta, _color: $_color, _dateRange: $_dateRange)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MeterValueDelta &&
        other._delta == _delta &&
        other._color == _color &&
        other._dateRange == _dateRange;
  }

  @override
  int get hashCode => _delta.hashCode ^ _color.hashCode ^ _dateRange.hashCode;
}
