import 'package:flutter/material.dart';
import 'package:rh_collector/domain/entities/meter.dart';
import 'package:rh_collector/domain/entities/meter_value.dart';
import 'package:rh_collector/domain/entities/meter_value_delta.dart';
import 'package:rh_collector/ui/screens/camera_screen.dart';
import 'package:rh_collector/ui/screens/meter_edit_screen.dart';
import 'package:rh_collector/ui/widgets/meter_value_delta_widget.dart';
import 'package:rh_collector/ui/widgets/meter_value_widget.dart';

class MeterWidget extends StatelessWidget {
  const MeterWidget({
    super.key,
    required Meter meter,
    this.newReadingSetCallBack,
    this.suffix,
  }) : _meter = meter;
  final Meter _meter;
  final Function? newReadingSetCallBack;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 3,
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              width: 120,
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
              child: Text(_meter.unit ?? ""),
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
            _meter.values.isNotEmpty
                ? MeterValueWidget(v: _meter.values.last)
                : const SizedBox.shrink(),
            IconButton(
                onPressed: () {
                  _addReading(context);
                },
                icon: const Icon(Icons.add_a_photo_outlined)),
            if (suffix != null) suffix!,
          ],
        ));
  }

  _openEditor(BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MeterEditScreen(
                  meter: _meter,
                )));
  }

  _addReading(BuildContext context) async {
    String? reading = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CameraScreen(
                  meterName: _meter.name,
                )));
    if (reading != null) {
      await _meter
          .addValue(MeterValue(DateTime.now(), int.tryParse(reading) ?? 0));
      if (newReadingSetCallBack != null) {
        newReadingSetCallBack!();
      }
    }
  }
}
