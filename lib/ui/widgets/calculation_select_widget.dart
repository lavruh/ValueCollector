import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/states/values_calculations_state.dart';

class CalculationSelectWidget extends StatelessWidget {
  const CalculationSelectWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: const RoundedRectangleBorder(),
        backgroundColor: Colors.transparent,
        child: Card(
          child: GetX<ValuesCalculationsState>(builder: (state) {
            List<Widget> children = [];
            for (int i = 0; i < state.calculationStrategies.length; i++) {
              children.add(RadioListTile<int>(
                title: Text(
                    state.calculationStrategies[i].getLocalizedName(context)),
                subtitle: Text(state.calculationStrategies[i]
                    .getLocalizedDescription(context)),
                value: i,
                groupValue: state.selectedCalculationStrategie.value,
                onChanged: (val) {
                  if (val != null) {
                    state.setCalculationStrategie(val);
                  }
                },
              ));
            }
            return Wrap(children: children);
          }),
        ));
  }
}
