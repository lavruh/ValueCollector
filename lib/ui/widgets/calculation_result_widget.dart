import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rh_collector/domain/entities/calculation_result.dart';
import 'package:rh_collector/domain/entities/meter_production_cost.dart';
import 'package:rh_collector/domain/entities/meter_value_delta.dart';

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
      leading: Text(lable),
      title: Text(DateFormat("y-MM-dd").format(item.timeRange.start) +
          " - " +
          DateFormat("y-MM-dd").format(item.timeRange.end)),
      subtitle: Text(item.value.toString()),
    );
  }
}
