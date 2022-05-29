import 'package:flutter/material.dart';
import 'package:rh_collector/domain/entities/calculation_result.dart';
import 'package:rh_collector/domain/entities/meter_production_cost.dart';
import 'package:rh_collector/domain/entities/meter_value_delta.dart';
import 'package:rh_collector/domain/helpers/daterange_extension.dart';

class CalculationResultWidget extends StatelessWidget {
  const CalculationResultWidget({Key? key, required this.item})
      : super(key: key);
  final CalculationResult item;
  @override
  Widget build(BuildContext context) {
    String lable = "";
    if (item.runtimeType == MeterValueDelta) {
      lable = "∆";
    }
    if (item.runtimeType == MeterProductionCost) {
      lable = "＄";
    }
    return ListTile(
      leading: Text(
        lable,
        textScaleFactor: 2,
      ),
      title: Text(item.timeRange.formatedString),
      subtitle: Text(
          item.value.toString() + " in ${item.timeRange.durationInDays} days"),
    );
  }
}
