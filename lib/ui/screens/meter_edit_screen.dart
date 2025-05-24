import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/entities/meter.dart';
import 'package:rh_collector/domain/entities/meter_value.dart';
import 'package:rh_collector/domain/states/meters_state.dart';
import 'package:rh_collector/ui/screens/meter_values_calculations_screen.dart';
import 'package:rh_collector/ui/widgets/delete_confirm_dialog.dart';
import 'package:rh_collector/ui/widgets/meter_editor/editor_text_input_field_widget.dart';
import 'package:rh_collector/ui/widgets/meter_editor/meter_values_widget.dart';
import 'package:rh_collector/l10n/app_localizations.dart';
import 'package:rh_collector/ui/widgets/meter_group_select_widget.dart';
import 'package:rh_collector/ui/widgets/meter_type_select_widget.dart';

class MeterEditScreen extends StatelessWidget {
  MeterEditScreen({super.key, required Meter meter})
      : _meter = meter.copyWith() {
    Get.replace<Meter>(_meter, tag: "meterEdit");
  }

  final Meter _meter;

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);
    if (local == null) return const Center(child: CircularProgressIndicator());
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
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 15,
                          children: [
                            EditorTextInputFieldWidget(
                              lable: local.name,
                              initValue: _meter.name,
                              setValue: (val) {
                                _meter.name = val;
                              },
                              key: const Key('NameInput'),
                            ),
                            EditorTextInputFieldWidget(
                              lable: local.unit,
                              initValue: _meter.unit ?? "",
                              setValue: (val) {
                                _meter.unit = val;
                              },
                              key: const Key('UnitInput'),
                            ),
                            const MeterGroupSelectWidget(),
                            EditorTextInputFieldWidget(
                              lable: local.correction,
                              initValue: _meter.correction.toString(),
                              setValue: (val) {
                                _meter.correction = int.parse(val);
                              },
                              keyboardType: TextInputType.number,
                              key: const Key('CorrectionInput'),
                            ),
                            GetX<Meter>(
                                tag: "meterEdit",
                                builder: (state) {
                                  return MeterTypeSelectWidget(
                                      initValueId: state.typeId,
                                      callback: (val) {
                                        state.typeId = val;
                                      });
                                }),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Flexible(
              flex: 3,
              child: MeterValuesWidget(),
            ),
          ],
        ),
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: _goToCalculationsScreen,
                icon: const Icon(Icons.calculate)),
            IconButton(onPressed: _addNewValue, icon: const Icon(Icons.add)),
            IconButton(onPressed: _submit, icon: const Icon(Icons.check)),
            IconButton(
                onPressed: _delete, icon: const Icon(Icons.delete_forever)),
          ],
        ),
      ),
    );
  }

  _goToCalculationsScreen() {
    Get.to(() => const MeterValuesCalculationsScreen());
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
