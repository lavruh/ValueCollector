import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/entities/meter.dart';
import 'package:rh_collector/domain/entities/meter_value.dart';
import 'package:rh_collector/domain/states/meters_state.dart';
import 'package:rh_collector/ui/widgets/delete_confirm_dialog.dart';
import 'package:rh_collector/ui/widgets/meter_editor/editor_text_input_field_widget.dart';
import 'package:rh_collector/ui/widgets/meter_editor/meter_values_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MeterEditScreen extends StatelessWidget {
  MeterEditScreen({Key? key, required Meter meter})
      : _meter = meter.copyWith(),
        super(key: key) {
    Get.replace<Meter>(_meter, tag: "meterEdit");
  }

  final Meter _meter;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(
              child: SingleChildScrollView(
                child: Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        Wrap(
                          direction: Axis.vertical,
                          children: [
                            EditorTextInputFieldWidget(
                              lable: AppLocalizations.of(context)?.name,
                              initValue: _meter.name,
                              setValue: (val) {
                                _meter.name = val;
                              },
                              key: const Key('NameInput'),
                            ),
                            EditorTextInputFieldWidget(
                              lable: AppLocalizations.of(context)?.unit,
                              initValue: _meter.unit ?? "",
                              setValue: (val) {
                                _meter.unit = val;
                              },
                              key: const Key('UnitInput'),
                            ),
                            EditorTextInputFieldWidget(
                              lable: AppLocalizations.of(context)?.correction,
                              initValue: _meter.correction.toString(),
                              setValue: (val) {
                                _meter.correction = int.parse(val);
                              },
                              keyboardType: TextInputType.number,
                              key: const Key('CorrectionInput'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Flexible(
              flex: 2,
              child: MeterValuesWidget(),
            ),
          ],
        ),
        appBar: AppBar(
          actions: [
            IconButton(onPressed: _addNewValue, icon: const Icon(Icons.add)),
            IconButton(onPressed: _submit, icon: const Icon(Icons.check)),
            IconButton(
                onPressed: _delete, icon: const Icon(Icons.delete_forever)),
          ],
        ),
      ),
    );
  }

  _submit() {
    Get.find<MetersState>().updateMeter(_meter);
    Get.back();
  }

  _delete() async {
    if (await Get.dialog(const DeleteConfirmDialog())) {
      Get.find<MetersState>().deleteMeter(_meter.id);
      Get.back();
    }
  }

  _addNewValue() {
    _meter.addValue(MeterValue(DateTime.now(), 0));
  }
}
