import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/entities/meter.dart';
import 'package:rh_collector/ui/widgets/meter_value_edit_widget.dart';

class MeterValuesWidget extends StatelessWidget {
  const MeterValuesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<Meter>(
        tag: "meterEdit",
        builder: (state) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: state.values.reversed
                  .map((element) => MeterValueEditWidget(
                        meterValue: element,
                        deleteCallback: state.deleteValue,
                        updateCallback: state.updateValue,
                      ))
                  .toList(),
            ),
          );
        });
  }
}
