import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rh_collector/di.dart';

class MeterRate {
  final String id;
  final String meterType;
  final DateTimeRange timeRange;
  final Map<int, double> rateLimits;
  MeterRate({
    String? id,
    required this.meterType,
    required this.timeRange,
    required this.rateLimits,
  }) : id = id ?? generateId();

  MeterRate.empty()
      : id = generateId(),
        meterType = "rh",
        timeRange = DateTimeRange(start: DateTime.now(), end: DateTime.now()),
        rateLimits = {0: 1};

  MeterRate copyWith({
    String? id,
    String? meterType,
    DateTimeRange? timeRange,
    Map<int, double>? rateLimits,
  }) {
    return MeterRate(
      id: id ?? this.id,
      meterType: meterType ?? this.meterType,
      timeRange: timeRange ?? this.timeRange,
      rateLimits: rateLimits ?? this.rateLimits,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MeterRate &&
        other.id == id &&
        other.meterType == meterType &&
        other.timeRange == timeRange &&
        mapEquals(other.rateLimits, rateLimits);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        meterType.hashCode ^
        timeRange.hashCode ^
        rateLimits.hashCode;
  }

  @override
  String toString() {
    return 'MeterRate(id: $id, meterType: $meterType, timeRange: $timeRange, rateLimits: $rateLimits)';
  }
}
