import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/entities/calculated_meter.dart';
import 'package:rh_collector/domain/entities/meter_value.dart';
import 'package:rh_collector/domain/states/meter_editor_state.dart';
import 'package:rh_collector/domain/states/meters_state.dart';
import 'package:rh_collector/ui/screens/calculation_editor_screen.dart';
import 'package:rh_collector/ui/screens/meter_values_calculations_screen.dart';
import 'package:rh_collector/ui/widgets/delete_confirm_dialog.dart';
import 'package:rh_collector/ui/widgets/meter_editor/editor_text_input_field_widget.dart';
import 'package:rh_collector/ui/widgets/meter_editor/meter_values_widget.dart';
import 'package:rh_collector/l10n/app_localizations.dart';
import 'package:rh_collector/ui/widgets/meter_group_select_widget.dart';
import 'package:rh_collector/ui/widgets/meter_type_select_widget.dart';

class MeterEditScreen extends StatelessWidget {
  const MeterEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);
    if (local == null) return const Center(child: CircularProgressIndicator());
    return SafeArea(
      child: GetX<MeterEditorState>(builder: (editor) {
        final meter = editor.get();
        return Scaffold(
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
                              initValue: meter.name,
                              setValue: (val) =>
                                  editor.set(meter.copyWith(name: val)),
                              key: const Key('NameInput'),
                            ),
                            EditorTextInputFieldWidget(
                              lable: local.unit,
                              initValue: meter.unit,
                              setValue: (val) =>
                                  editor.set(meter.copyWith(unit: val)),
                              key: const Key('UnitInput'),
                            ),
                            MeterGroupSelectWidget(
                              meter: meter,
                              onChanged: (m) => editor.set(m),
                            ),
                            SizedBox(
                              width: 80,
                              child: EditorTextInputFieldWidget(
                                lable: local.correction,
                                initValue: meter.correction.toString(),
                                setValue: (val) {
                                  final correction = int.tryParse(val);
                                  if (correction != null) {
                                    editor.set(
                                        meter.copyWith(correction: correction));
                                  }
                                },
                                keyboardType: TextInputType.number,
                                key: const Key('CorrectionInput'),
                              ),
                            ),
                            MeterTypeSelectWidget(
                                initValueId: meter.typeId,
                                callback: (val) =>
                                    editor.set(meter.copyWith(typeId: val))),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )),
              const Flexible(
                flex: 3,
                child: MeterValuesWidget(),
              ),
            ],
          ),
          appBar: AppBar(
            actions: [
              if (meter is CalculatedMeter)
                IconButton(
                    onPressed: () {
                      Get.to(() => CalculationEditorScreen(
                          meter: meter,
                          onFormulaChanged: (v) {
                            editor.set(meter.copyWith(formula: v));
                          }));
                    },
                    icon: const Icon(Icons.facebook)),
              IconButton(
                  onPressed: _goToCalculationsScreen,
                  icon: const Icon(Icons.calculate)),
              IconButton(onPressed: _addNewValue, icon: const Icon(Icons.add)),
              IconButton(onPressed: _submit, icon: const Icon(Icons.check)),
              IconButton(
                  onPressed: _delete, icon: const Icon(Icons.delete_forever)),
            ],
          ),
        );
      }),
    );
  }

  _goToCalculationsScreen() {
    Get.to(() => const MeterValuesCalculationsScreen());
  }

  _submit() async {
    final meter = Get.find<MeterEditorState>().get();
    await Get.find<MetersState>().updateMeter(meter);
    Get.back();
  }

  _delete() async {
    if (await Get.dialog(const DeleteConfirmDialog())) {
      try {
        final meter = Get.find<MeterEditorState>().get();
        final id = meter.id;
        Get.find<MetersState>().deleteMeter(id);
        Get.back();
      } on Exception catch (e) {
        Get.snackbar("Error", "$e");
      }
    }
  }

  _addNewValue() {
    final editor = Get.find<MeterEditorState>();
    editor.addValue(MeterValue(DateTime.now(), 0));
  }
}
