import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/entities/calculated_meter.dart';
import 'package:rh_collector/domain/entities/meter.dart';
import 'package:rh_collector/domain/entities/meter_value.dart';
import 'package:rh_collector/domain/entities/meter_value_delta.dart';
import 'package:rh_collector/domain/helpers/reading_utils.dart';
import 'package:rh_collector/domain/states/meter_editor_state.dart';
import 'package:rh_collector/domain/states/meters_state.dart';
import 'package:rh_collector/domain/states/settings_state.dart';
import 'package:rh_collector/ui/screens/camera_screen.dart';
import 'package:rh_collector/ui/screens/meter_edit_screen.dart';
import 'package:rh_collector/ui/widgets/meter_value_delta_widget.dart';
import 'package:rh_collector/ui/widgets/meter_value_widget.dart';
import 'package:rh_collector/ui/widgets/remark_button.dart';

class MeterWidget extends StatefulWidget {
  const MeterWidget({
    super.key,
    required Meter meter,
    this.newReadingSetCallBack,
    this.suffix,
    required this.settings,
  }) : _meter = meter;
  final Meter _meter;
  final Function(MeterValue)? newReadingSetCallBack;
  final Widget? suffix;
  final SettingsState settings;

  @override
  State<MeterWidget> createState() => _MeterWidgetState();
}

class _MeterWidgetState extends State<MeterWidget>
    with SingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  late final slideController = SlidableController(this);

  @override
  Widget build(BuildContext context) {
    final lastValue =
        widget._meter.values.isNotEmpty ? widget._meter.values.last : null;

    return Slidable(
      controller: slideController,
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          CustomSlidableAction(
            onPressed: (context) {},
            child: Form(
              key: formKey,
              child: TextFormField(
                onFieldSubmitted: (v) {
                  if (!formKey.currentState!.validate()) return;
                  final fnk = widget.newReadingSetCallBack;
                  final reading = parseReading(v);
                  if (fnk != null && reading != null) {
                    fnk(MeterValue.current(reading));
                    slideController.close();
                  }
                },
                keyboardType: TextInputType.number,
                validator: (v) => readingValidator(context, v),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'New value',
                ),
              ),
            ),
          ),
          if (lastValue != null)
            RemarkButton(
                meterValue: lastValue, updateCallback: _editValueRemark),
        ],
      ),
      child: FractionallySizedBox(
        widthFactor: 1,
        child: Card(
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
                      widget._meter.name,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ),
                SizedBox(
                  width: 30,
                  child: Text(widget._meter.unit),
                ),
                widget._meter.values.length > 1
                    ? MeterValueDeltaWidget(
                        v: MeterValueDelta(
                        v1: widget._meter.values.reversed.toList()[1],
                        v2: widget._meter.values.last,
                      ))
                    : const SizedBox.shrink(),
                widget._meter.values.length > 1 && widget.suffix == null
                    ? MeterValueWidget(
                        v: widget._meter.values.reversed.toList()[1])
                    : const SizedBox.shrink(),
                if (lastValue != null)
                  MeterValueWidget(
                      v: lastValue,
                      textColor: _selectColorBasedOnValueDate(lastValue)),
                widget._meter is CalculatedMeter
                    ? IconButton(
                        onPressed: addCalculatedMeterValue,
                        icon: Icon(Icons.add))
                    : IconButton(
                        onPressed: () => _addReading(context),
                        icon: const Icon(Icons.add_a_photo_outlined)),
                if (widget.suffix != null) widget.suffix!,
              ],
            )),
      ),
    );
  }

  void addCalculatedMeterValue() async {
    final editor = Get.find<MeterEditorState>();
    final m = await editor.addValueToMeter(
        value: MeterValue.current(0), meter: widget._meter);
    Get.find<MetersState>().updateMeter(m);
  }

  void _openEditor(BuildContext context) {
    Get.find<MeterEditorState>().set(widget._meter);
    Get.to(() => MeterEditScreen());
  }

  void _addReading(BuildContext context) async {
    final reading = await Navigator.push<MeterValue>(
        context,
        MaterialPageRoute(
            builder: (context) => CameraScreen(
                  meterName: widget._meter.name,
                )));
    if (reading != null) {
      final fnk = widget.newReadingSetCallBack;
      if (fnk != null) fnk(reading);
    }
  }

  void _editValueRemark(MeterValue v) {
    final editor = Get.find<MeterEditorState>();
    editor.set(widget._meter);
    editor.updateValue(v);
    Get.find<MetersState>().updateMeter(editor.get());
    slideController.close();
  }

  Color _selectColorBasedOnValueDate(MeterValue lastValue) {
    final now = DateTime.now();
    final diff = now.difference(lastValue.date).inHours;
    if (diff > widget.settings.valueColorNotificationTime) return Colors.black;
    return widget.settings.highlightColor;
  }
}
