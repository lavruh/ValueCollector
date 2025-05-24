import 'package:rh_collector/domain/entities/calculation_result.dart';

class MeterProductionCost extends CalculationResult {
  MeterProductionCost({
    required super.timeRange,
    required super.value,
  });

  double reachedLimit = 0;
  double overLimit = 0;
}
