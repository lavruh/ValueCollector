import 'package:get/get.dart';

import 'package:rh_collector/domain/entities/calculation_result.dart';
import 'package:rh_collector/domain/entities/meter_production_cost.dart';
import 'package:rh_collector/domain/entities/meter_rate.dart';
import 'package:rh_collector/domain/entities/meter_value.dart';
import 'package:rh_collector/domain/entities/meter_value_delta.dart';
import 'package:rh_collector/domain/states/rates_state.dart';
import 'package:rh_collector/domain/states/values_calculations_state.dart';

abstract class IMeterCalculationStrategy {
  CalculationResult compute(MeterValue valueStart, MeterValue valueEnd);
}

class MeterValueDeltaCalculation implements IMeterCalculationStrategy {
  @override
  MeterValueDelta compute(MeterValue valueStart, MeterValue valueEnd) {
    return MeterValueDelta(v1: valueStart, v2: valueEnd);
  }
}

class MeterProductionCostCalculation implements IMeterCalculationStrategy {
  final ratesState = Get.find<RatesState>();
  final MeterType type;
  MeterProductionCostCalculation({
    required this.type,
  });

  @override
  MeterProductionCost compute(MeterValue valueStart, MeterValue valueEnd) {
    final delta = MeterValueDeltaCalculation().compute(valueStart, valueEnd);
    late MeterRate rate;
    try {
      rate =
          ratesState.getLatestRate(dateRange: delta.dateRange, meterType: type);
    } on MeterRatesException catch (e) {
      throw MeterCalculationException("$e");
    }

    if (delta.value <= 0) {
      return MeterProductionCost(timeRange: delta.dateRange, value: 0);
    }
    double resultValue = 0;
    double tmpVal = delta.value.toDouble();
    for (int limit in rate.rateLimits.keys) {
      final multiplier = rate.rateLimits[limit];
      if (tmpVal < limit) {
        resultValue += tmpVal * multiplier!;
        break;
      } else {
        resultValue += limit * multiplier!;
        tmpVal -= limit;
      }
    }

    return MeterProductionCost(timeRange: delta.timeRange, value: resultValue);
  }
}

class MeterCalculationException implements Exception {
  String msg;
  MeterCalculationException(this.msg);

  @override
  String toString() => 'MeterCalculationException($msg)';
}
