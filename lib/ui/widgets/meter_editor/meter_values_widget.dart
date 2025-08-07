import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/states/meter_editor_state.dart';
import 'package:rh_collector/ui/widgets/meter_value_edit_widget.dart';

class MeterValuesWidget extends StatelessWidget {
  const MeterValuesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<MeterEditorState>(builder: (editor) {
      final values = editor.mValues;
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: values.reversed
              .map((element) => MeterValueEditWidget(
                    meterValue: element,
                    deleteCallback: editor.deleteValue,
                    updateCallback: editor.updateValue,
                  ))
              .toList(),
        ),
      );
    });
  }
}
