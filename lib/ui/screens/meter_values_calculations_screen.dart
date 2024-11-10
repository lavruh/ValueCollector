import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphic/graphic.dart';
import 'package:intl/intl.dart';
import 'package:rh_collector/domain/entities/calculation_result.dart';
import 'package:rh_collector/domain/states/values_calculations_state.dart';
import 'package:rh_collector/ui/widgets/calculation_result_widget.dart';
import 'package:rh_collector/ui/widgets/calculation_select_widget.dart';

class MeterValuesCalculationsScreen extends StatelessWidget {
  const MeterValuesCalculationsScreen({super.key});

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
      body: Column(
        children: [
          Flexible(child: GetX<ValuesCalculationsState>(builder: (state) {
            if (state.calculationResults.isEmpty) {
              return Container();
            }
            return ResultsChartWidget(data: state.calculationResults.toList());
          })),
          Flexible(
            flex: 2,
            child: GetX<ValuesCalculationsState>(
              builder: (state) {
                return ListView.builder(
                  itemCount: state.calculationResults.length,
                  itemBuilder: (context, i) => CalculationResultWidget(
                      item: state.calculationResults[i]),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class ResultsChartWidget extends StatelessWidget {
  const ResultsChartWidget({super.key, required this.data});
  final List<CalculationResult> data;

  @override
  Widget build(BuildContext context) {
    return Chart(
      data: data,
      variables: {
        'time': Variable(
          accessor: (CalculationResult d) => d.timeRange.end,
          scale: TimeScale(
            formatter: (time) => DateFormat("MM-dd").format(time),
          ),
        ),
        'value': Variable(accessor: (CalculationResult d) => d.value),
      },
      coord: RectCoord(color: const Color(0xffdddddd)),
      axes: [
        Defaults.horizontalAxis,
        Defaults.verticalAxis,
      ],
      selections: {
        'touchMove': PointSelection(
          on: {
            GestureType.scaleUpdate,
            GestureType.tapDown,
            GestureType.longPressMoveUpdate
          },
          dim: Dim.x,
        )
      },
      tooltip: TooltipGuide(
        followPointer: [false, true],
        align: Alignment.topLeft,
        offset: const Offset(-20, -20),
      ),
      crosshair: CrosshairGuide(followPointer: [false, true]),
      marks: [LineMark()],
    );
  }
}
