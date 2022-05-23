import 'package:flutter/material.dart';
import 'package:rh_collector/domain/entities/calculation_result.dart';
import 'package:rh_collector/domain/entities/meter_value.dart';

class MeterValueDelta extends CalculationResult {
  bool _isValid = false;
  MeterValueDelta({
    required MeterValue v1,
    required MeterValue v2,
  }) : super(
            value: (v2.correctedValue - v1.correctedValue).toDouble(),
            timeRange: DateTimeRange(
                start: v1.date,
                end: v2.date.millisecondsSinceEpoch >
                        v1.date.millisecondsSinceEpoch
                    ? v2.date
                    : v1.date)) {
    _validate();
  }

  bool get isValid => _isValid;
  DateTimeRange get dateRange => timeRange;

  _validate() {
    if (value < 0 || value > timeRange.duration.inHours) {
      _isValid = false;
    } else {
      _isValid = true;
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MeterValueDelta &&
        other.value == value &&
        other.timeRange == timeRange;
  }

  @override
  int get hashCode => value.hashCode ^ timeRange.hashCode;
}
