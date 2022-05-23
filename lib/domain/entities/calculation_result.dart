import 'package:flutter/material.dart';

class CalculationResult {
  DateTimeRange timeRange;
  final double value;
  CalculationResult({
    required this.value,
    required this.timeRange,
  });
}
