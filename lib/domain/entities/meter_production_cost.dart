import 'package:flutter/material.dart';
import 'package:rh_collector/domain/entities/calculation_result.dart';

class MeterProductionCost extends CalculationResult {
  MeterProductionCost({
    required DateTimeRange timeRange,
    required double value,
  }) : super(value: value, timeRange: timeRange);
}
