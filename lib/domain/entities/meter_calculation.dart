import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/entities/calculation_result.dart';
import 'package:rh_collector/domain/entities/meter_production_cost.dart';
import 'package:rh_collector/domain/entities/meter_rate.dart';
import 'package:rh_collector/domain/entities/meter_type.dart';
import 'package:rh_collector/domain/entities/meter_value.dart';
import 'package:rh_collector/domain/entities/meter_value_delta.dart';
import 'package:rh_collector/domain/states/rates_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

abstract class IMeterCalculationStrategy {
  String getLocalizedName(BuildContext context);
  String getLocalizedDescriprion(BuildContext context);
  CalculationResult compute(MeterValue valueStart, MeterValue valueEnd);
}

class MeterValueDeltaCalculation implements IMeterCalculationStrategy {
  @override
  MeterValueDelta compute(MeterValue valueStart, MeterValue valueEnd) {
    return MeterValueDelta(v1: valueStart, v2: valueEnd);
  }

  @override
  String getLocalizedDescriprion(BuildContext context) {
    return AppLocalizations.of(context)!.diffCalcDescr;
  }

  @override
  String getLocalizedName(BuildContext context) {
    return AppLocalizations.of(context)!.diffCalc;
  }
}

class MeterProductionCostCalculation implements IMeterCalculationStrategy {
  final ratesState = Get.find<RatesState>();
  MeterType? type;
  MeterProductionCostCalculation({
    this.type,
  });

  @override
  MeterProductionCost compute(MeterValue valueStart, MeterValue valueEnd) {
    if (type == null) {
      throw MeterCalculationException("Meter type [$type] is not correct");
    }
    final delta = MeterValueDeltaCalculation().compute(valueStart, valueEnd);
    late MeterRate rate;
    try {
      rate = ratesState.getLatestRate(
          dateRange: delta.dateRange, meterType: type!);
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
        tmpVal = 0;
        break;
      } else {
        resultValue += limit * multiplier!;
        tmpVal -= limit;
      }
    }
    resultValue += tmpVal * rate.rateLimits.values.last;
    return MeterProductionCost(timeRange: delta.timeRange, value: resultValue);
  }

  @override
  String getLocalizedDescriprion(BuildContext context) {
    return AppLocalizations.of(context)!.prodCostDescr1;
  }

  @override
  String getLocalizedName(BuildContext context) {
    return AppLocalizations.of(context)!.prodCostCalc1;
  }
}

class MeterCalculationException implements Exception {
  String msg;
  MeterCalculationException(this.msg);

  @override
  String toString() => 'MeterCalculationException($msg)';
}
