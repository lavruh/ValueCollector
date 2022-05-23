import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/states/values_calculations_state.dart';
import 'package:rh_collector/ui/widgets/calculation_result_widget.dart';
import 'package:rh_collector/ui/widgets/value_select_widget.dart';

class MeterValuesCalculationsScreen extends StatelessWidget {
  const MeterValuesCalculationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          const MeterTypeSelection(),
          GetX<ValuesCalculationsState>(builder: (state) {
            return ValueSelectWidget(
                items: state.calculationStrategiesId,
                callback: state.setCalculationStrategie,
                initValue: state.selectedCalculationStrategie.value);
          }),
        ],
      ),
      body: GetX<ValuesCalculationsState>(
        builder: (state) {
          return ListView.builder(
            itemCount: state.calculationResults.length,
            itemBuilder: (context, i) =>
                CalculationResultWidget(item: state.calculationResults[i]),
          );
        },
      ),
    );
  }
}

class MeterTypeSelection extends StatelessWidget {
  const MeterTypeSelection({Key? key}) : super(key: key);
  static final List<Widget> _meterTypeIcons = [
    Row(
      children: const [Text("Running hours"), Icon(Icons.alarm)],
    ),
    Row(
      children: const [
        Text("Cold water"),
        Icon(Icons.water_drop, color: Colors.blue)
      ],
    ),
    Row(
      children: const [
        Text("Hot water"),
        Icon(Icons.water_drop, color: Colors.red)
      ],
    ),
    Row(
      children: const [Text("Gas"), Icon(Icons.gas_meter)],
    ),
    Row(
      children: const [
        Text("Electricity"),
        Icon(Icons.electric_meter, color: Colors.yellow)
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GetX<ValuesCalculationsState>(builder: (state) {
      List<DropdownMenuItem<int>> entries = [];
      for (int i = 0; i < _meterTypeIcons.length; i++) {
        entries.add(DropdownMenuItem(child: _meterTypeIcons[i], value: i));
      }
      return DropdownButton(
        icon: const Icon(Icons.arrow_drop_down),
        value: state.meterType.value.index,
        elevation: 3,
        items: entries,
        onChanged: (value) {
          state.changeMeterType(MeterType.values[value as int]);
        },
      );
    });
  }
}
