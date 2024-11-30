import 'package:flutter/material.dart';
import 'package:rh_collector/domain/entities/calculation_result.dart';
import 'package:rh_collector/domain/entities/meter_production_cost.dart';
import 'package:rh_collector/domain/entities/meter_value_delta.dart';
import 'package:rh_collector/domain/helpers/daterange_extension.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CalculationResultWidget extends StatelessWidget {
  const CalculationResultWidget({Key? key, required this.item})
      : super(key: key);
  final CalculationResult item;
  @override
  Widget build(BuildContext context) {
    String lable = "＄";
    String resultString = "${item.value} " +
        AppLocalizations.of(context)!.inDays +
        ": ${item.timeRange.durationInDays}";

    if (item.runtimeType == MeterValueDelta) {
      lable = "∆";
      resultString += " " +
          AppLocalizations.of(context)!.avaragePerDay +
          " ${(item as MeterValueDelta).avaregePerDay.toStringAsFixed(2)}";
    }
    if (item.runtimeType == MeterProductionCost) {
      resultString += " " +
          AppLocalizations.of(context)!.reachedLimit +
          " ${(item as MeterProductionCost).reachedLimit}";
    }
    return ListTile(
      leading: Text(
        lable,
        textScaleFactor: 2,
      ),
      title: Text(item.timeRange.formatedString),
      subtitle: Text(resultString),
    );
  }
}
