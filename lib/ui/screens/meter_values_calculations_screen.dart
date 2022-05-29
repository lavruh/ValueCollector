import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/states/values_calculations_state.dart';
import 'package:rh_collector/ui/widgets/calculation_result_widget.dart';
import 'package:rh_collector/ui/widgets/calculation_select_widget.dart';

class MeterValuesCalculationsScreen extends StatelessWidget {
  const MeterValuesCalculationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.find<ValuesCalculationsState>().calculate();
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Get.dialog(const CalculationSelectWidget());
              },
              icon: const Icon(Icons.calculate)),
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
