import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/entities/meter.dart';
import 'package:rh_collector/domain/entities/meter_value.dart';
import 'package:rh_collector/domain/states/meters_state.dart';
import 'package:rh_collector/ui/widgets/delete_confirm_dialog.dart';
import 'package:rh_collector/ui/widgets/meter_value_edit_widget.dart';

class MeterEditScreen extends StatefulWidget {
  MeterEditScreen({Key? key, required Meter meter})
      : _meter = meter,
        super(key: key) {
    Get.replace<Meter>(_meter, tag: "meterEdit");
  }

  final Meter _meter;

  @override
  State<MeterEditScreen> createState() => _MeterEditScreenState();
}

class _MeterEditScreenState extends State<MeterEditScreen> {
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController unitCtrl = TextEditingController();
  TextEditingController correctionCtrl = TextEditingController();

  @override
  void initState() {
    nameCtrl.text = widget._meter.name;
    unitCtrl.text = widget._meter.unit ?? "";
    correctionCtrl.text = widget._meter.correction.toString();
    super.initState();
  }

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
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 3,
                    runSpacing: 3,
                    children: [
                      Wrap(
                        direction: Axis.vertical,
                        children: [
                          Text("Name:",
                              style: Theme.of(context).textTheme.headline5),
                          EditorTextInputFieldWidget(
                            ctrl: nameCtrl,
                            key: const Key('NameInput'),
                          ),
                          Text("Unit:",
                              style: Theme.of(context).textTheme.headline5),
                          EditorTextInputFieldWidget(
                            ctrl: unitCtrl,
                            key: const Key('UnitInput'),
                          ),
                          Text("Correction:",
                              style: Theme.of(context).textTheme.headline5),
                          EditorTextInputFieldWidget(
                            ctrl: correctionCtrl,
                            keyboardType: TextInputType.number,
                            key: const Key('CorrectionInput'),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: _submit,
                        child: const Icon(Icons.check),
                      ),
                      ElevatedButton(
                        onPressed: _delete,
                        child: const Icon(Icons.delete_forever),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Flexible(
              child: Card(
                  elevation: 3,
                  child: GetBuilder<Meter>(
                      tag: "meterEdit",
                      builder: (_) {
                        return ListView(
                          reverse: true,
                          children: _.values
                              .map((element) => MeterValueEditWidget(
                                    meterValue: element,
                                    deleteCallback: _.deleteValue,
                                    updateCallback: _.updateValue,
                                  ))
                              .toList(),
                        );
                      })),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            widget._meter.addValue(MeterValue(DateTime.now(), 0));
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  _submit() {
    widget._meter.name = nameCtrl.text;
    widget._meter.unit = unitCtrl.text;
    widget._meter.correction = int.tryParse(correctionCtrl.text) ?? 0;
    widget._meter.updateDb();
    Navigator.pop(context);
  }

  _delete() async {
    if (await _deleteConfirmDialog()) {
      Get.find<MetersState>().deleteMeter(widget._meter.id);
      Navigator.pop(context);
    }
  }

  Future<bool> _deleteConfirmDialog() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const DeleteConfirmDialog();
      },
    );
  }
}

class EditorTextInputFieldWidget extends StatelessWidget {
  const EditorTextInputFieldWidget({
    Key? key,
    required this.ctrl,
    this.keyboardType,
  }) : super(key: key);
  final TextEditingController ctrl;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: TextField(
          controller: ctrl,
          showCursor: true,
          keyboardType: keyboardType,
          style: Theme.of(context).textTheme.headline5,
          textAlign: TextAlign.center,
        ));
  }
}
