import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/entities/calculation_result.dart';
import 'package:rh_collector/domain/entities/meter_production_cost.dart';
import 'package:rh_collector/domain/entities/meter_rate.dart';
import 'package:rh_collector/domain/entities/meter_type.dart';
import 'package:rh_collector/domain/entities/meter_value.dart';
import 'package:rh_collector/domain/entities/meter_value_delta.dart';
import 'package:rh_collector/domain/states/rates_state.dart';
import 'package:rh_collector/l10n/app_localizations.dart';

abstract class IMeterCalculationStrategy {
  void setMeterType(MeterType type);
  String getLocalizedName(BuildContext context);
  String getLocalizedDescription(BuildContext context);
  CalculationResult compute(MeterValue valueStart, MeterValue valueEnd);
}

class MeterValueDeltaCalculation implements IMeterCalculationStrategy {
  @override
  MeterValueDelta compute(MeterValue valueStart, MeterValue valueEnd) {
    return MeterValueDelta(v1: valueStart, v2: valueEnd);
  }

  @override
  String getLocalizedDescription(BuildContext context) {
    return AppLocalizations.of(context)!.diffCalcDescr;
  }

  @override
  String getLocalizedName(BuildContext context) {
    return AppLocalizations.of(context)!.diffCalc;
  }

  @override
  void setMeterType(MeterType type) {}
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
    final resultValue =
        MeterProductionCost(timeRange: delta.timeRange, value: 0);
    double tmpVal = delta.value.toDouble();
    for (int limit in rate.rateLimits.keys) {
      final multiplier = rate.rateLimits[limit];
      if (tmpVal < limit) {
        resultValue.value += tmpVal * multiplier!;
        tmpVal = 0;
        break;
      } else {
        resultValue.value += limit * multiplier!;
        tmpVal -= limit;
      }
      resultValue.reachedLimit = limit.toDouble();
    }
    resultValue.value += tmpVal * rate.rateLimits.values.last;
    return resultValue;
  }

  @override
  String getLocalizedDescription(BuildContext context) {
    return AppLocalizations.of(context)!.prodCostDescr1;
  }

  @override
  String getLocalizedName(BuildContext context) {
    return AppLocalizations.of(context)!.prodCostCalc1;
  }

  @override
  void setMeterType(MeterType val) {
    type = val;
  }
}

class MeterProductionCostMaxLimitCalculation
    implements IMeterCalculationStrategy {
  final ratesState = Get.find<RatesState>();
  MeterType? type;
  MeterProductionCostMaxLimitCalculation({
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
    MeterProductionCost resultValue =
        MeterProductionCost(timeRange: delta.timeRange, value: 0);
    double tmpVal = delta.value.toDouble();
    final limits = rate.rateLimits.keys.toList();

    for (int i = 1; i < limits.length; i++) {
      if (tmpVal < limits[i]) {
        resultValue.value = tmpVal * rate.rateLimits[limits[i - 1]]!;
        resultValue.reachedLimit = limits[i - 1].toDouble();
        final overlimit = resultValue.value - limits[i - 1].toDouble();
        resultValue.overLimit = overlimit > 0 ? overlimit : 0;
        break;
      } else {
        resultValue.value = tmpVal * rate.rateLimits[limits[i]]!;
        resultValue.reachedLimit = limits[i].toDouble();
        final overlimit = resultValue.value - limits[i].toDouble();
        resultValue.overLimit = overlimit > 0 ? overlimit : 0;
      }
    }
    return resultValue;
  }

  @override
  String getLocalizedDescription(BuildContext context) {
    return AppLocalizations.of(context)!.prodCostMaxLimDescr;
  }

  @override
  String getLocalizedName(BuildContext context) {
    return AppLocalizations.of(context)!.prodCostMaxLimCalc;
  }

  @override
  void setMeterType(MeterType val) {
    type = val;
  }
}

class MeterCalculationException implements Exception {
  String msg;
  MeterCalculationException(this.msg);

  @override
  String toString() => 'MeterCalculationException($msg)';
}
