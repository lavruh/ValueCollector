import 'package:flutter/material.dart';
import 'package:rh_collector/domain/entities/calculation_result.dart';
import 'package:rh_collector/domain/entities/meter_production_cost.dart';
import 'package:rh_collector/domain/entities/meter_value_delta.dart';
import 'package:rh_collector/domain/helpers/daterange_extension.dart';
import 'package:rh_collector/l10n/app_localizations.dart';

class CalculationResultWidget extends StatelessWidget {
  const CalculationResultWidget({super.key, required this.item});
  final CalculationResult item;
  @override
  Widget build(BuildContext context) {
    String label = "＄";
    final loc = AppLocalizations.of(context);
    if (loc == null) return Center(child: CircularProgressIndicator());

    String resultString =
        "${item.value} ${loc.inDays}: ${item.timeRange.durationInDays}";

    if (item.runtimeType == MeterValueDelta) {
      label = "∆";
      resultString +=
          " ${loc.avaragePerDay} ${(item as MeterValueDelta).avaregePerDay.toStringAsFixed(2)}";
    }
    if (item.runtimeType == MeterProductionCost) {
      resultString +=
          " ${loc.reachedLimit} ${(item as MeterProductionCost).reachedLimit}";
    }
    return ListTile(
      leading: Text(label),
      title: Text(item.timeRange.formatedString),
      subtitle: Text(resultString),
    );
  }
}
