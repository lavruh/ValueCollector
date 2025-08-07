import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/entities/meter.dart';
import 'package:rh_collector/domain/entities/meter_value.dart';
import 'package:rh_collector/domain/entities/meter_value_delta.dart';
import 'package:rh_collector/domain/states/meter_editor_state.dart';
import 'package:rh_collector/domain/states/meters_state.dart';
import 'package:rh_collector/ui/screens/camera_screen.dart';
import 'package:rh_collector/ui/screens/meter_edit_screen.dart';
import 'package:rh_collector/ui/widgets/meter_value_delta_widget.dart';
import 'package:rh_collector/ui/widgets/meter_value_widget.dart';
import 'package:rh_collector/ui/widgets/remark_button.dart';

class MeterWidget extends StatelessWidget {
  const MeterWidget({
    super.key,
    required Meter meter,
    this.newReadingSetCallBack,
    this.suffix,
  }) : _meter = meter;
  final Meter _meter;
  final Function(MeterValue)? newReadingSetCallBack;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    final lastValue = _meter.values.isNotEmpty ? _meter.values.last : null;
    return Card(
        elevation: 3,
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              width: 100,
              child: TextButton(
                onPressed: () {
                  _openEditor(context);
                },
                child: Text(
                  _meter.name,
                  overflow: TextOverflow.clip,
                ),
              ),
            ),
            SizedBox(
              width: 30,
              child: Text(_meter.unit),
            ),
            _meter.values.length > 1
                ? MeterValueDeltaWidget(
                    v: MeterValueDelta(
                    v1: _meter.values.reversed.toList()[1],
                    v2: _meter.values.last,
                  ))
                : const SizedBox.shrink(),
            _meter.values.length > 1 && suffix == null
                ? MeterValueWidget(v: _meter.values.reversed.toList()[1])
                : const SizedBox.shrink(),
            if (lastValue != null) MeterValueWidget(v: lastValue),
            if (lastValue != null)
              RemarkButton(
                  meterValue: lastValue, updateCallback: _editValueRemark),
            IconButton(
                onPressed: () {
                  _addReading(context);
                },
                icon: const Icon(Icons.add_a_photo_outlined)),
            if (suffix != null) suffix!,
          ],
        ));
  }

  _openEditor(BuildContext context) {
    Get.find<MeterEditorState>().set(_meter);
    Get.to(() => MeterEditScreen());
  }

  _addReading(BuildContext context) async {
    final reading = await Navigator.push<MeterValue>(
        context,
        MaterialPageRoute(
            builder: (context) => CameraScreen(
                  meterName: _meter.name,
                )));
    if (reading != null) {
      final fnk = newReadingSetCallBack;
      if (fnk != null) fnk(reading);
    }
  }

  _editValueRemark(MeterValue v) {
    final editor = Get.find<MeterEditorState>();
    editor.set(_meter);
    editor.updateValue(v);
    Get.find<MetersState>().updateMeter(editor.get());
  }
}
