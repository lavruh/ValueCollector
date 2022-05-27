import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rh_collector/di.dart';
import 'package:rh_collector/domain/entities/meter_rate.dart';

class MeterRateDto {
  final String id;
  final String meterType;
  final int timeRangeStart;
  final int timeRangeEnd;
  final Map<String, double> rateLimits;
  MeterRateDto({
    required this.id,
    required this.meterType,
    required this.timeRangeStart,
    required this.timeRangeEnd,
    required this.rateLimits,
  });

  factory MeterRateDto.formDomain(MeterRate rate) {
    return MeterRateDto(
      id: rate.id,
      meterType: rate.meterType,
      timeRangeStart: rate.timeRange.start.millisecondsSinceEpoch,
      timeRangeEnd: rate.timeRange.end.millisecondsSinceEpoch,
      rateLimits: rate.rateLimits
          .map<String, double>((key, value) => MapEntry(key.toString(), value)),
    );
  }

  MeterRate toDomain() {
    return MeterRate(
        id: id,
        meterType: meterType,
        timeRange: DateTimeRange(
            start: DateTime.fromMillisecondsSinceEpoch(timeRangeStart),
            end: DateTime.fromMillisecondsSinceEpoch(timeRangeEnd)),
        rateLimits:
            rateLimits.map((key, value) => MapEntry(int.parse(key), value)));
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'meterType': meterType,
      'timeRangeStart': timeRangeStart,
      'timeRangeEnd': timeRangeEnd,
      'rateLimits': rateLimits,
    };
  }

  factory MeterRateDto.fromMap(Map<String, dynamic> map) {
    return MeterRateDto(
      id: map['id'] ?? generateId(),
      meterType: map['meterType'] ?? "rh",
      timeRangeStart:
          map['timeRangeStart'] ?? DateTime.now().millisecondsSinceEpoch,
      timeRangeEnd:
          map['timeRangeEnd'] ?? DateTime.now().millisecondsSinceEpoch,
      rateLimits: Map<String, double>.from(map['rateLimits'] ?? {'1': 1.0}),
    );
  }

  String toJson() => json.encode(toMap());

  factory MeterRateDto.fromJson(String source) =>
      MeterRateDto.fromMap(json.decode(source));
}
