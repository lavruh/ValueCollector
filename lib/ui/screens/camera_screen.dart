import 'package:flutter/material.dart';
import 'package:photo_data_picker/domain/data_picker_state.dart';
import 'package:photo_data_picker/ui/widget/data_picker_widget.dart';
import 'package:rh_collector/domain/entities/meter_value.dart';
import 'package:rh_collector/l10n/app_localizations.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key, this.meterName});
  final String? meterName;

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final _formKey = GlobalKey<FormState>();
  final textCtrl = TextEditingController();
  final remarkCtrl = TextEditingController();
  late DataPickerState state = DataPickerState(
      onReadingChanged: (v) => setState(() {
            final int = parseReading(v);
            textCtrl.text = "${int ?? ""}";
          }));

  @override
  void initState() {
    state.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    state.dispose();
    state.disposeCamera();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    if (loc == null) return Container();
    final screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.meterName ?? ""),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: screenWidth * 0.95,
                  child: DataPickerWidget(state: state),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: readingValidator,
                    controller: textCtrl,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        labelText: loc.reading,
                        border: const OutlineInputBorder(),
                        suffix: IconButton(
                            onPressed: confirm, icon: const Icon(Icons.check)),
                        prefixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () => setState(() => textCtrl.clear()))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: remarkCtrl,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        labelText: loc.remarks,
                        border: const OutlineInputBorder(),
                        suffix: IconButton(
                            onPressed: confirm, icon: const Icon(Icons.check)),
                        prefixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () =>
                                setState(() => remarkCtrl.clear()))),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? readingValidator(v) {
    final loc = AppLocalizations.of(context);
    if (v == null || v.isEmpty) {
      return loc!.warningReadingEmpty;
    }
    if (parseReading(v) == null) return loc!.warningReadingIsNotInteger;
    return null;
  }

  void confirm() {
    if (!_formKey.currentState!.validate()) return;
    final valString = textCtrl.text;
    if (valString.isEmpty) return;
    final v = parseReading(valString);
    final remark = remarkCtrl.text.isNotEmpty ? remarkCtrl.text : null;
    if (v == null) return;
    Navigator.pop<MeterValue>(context, MeterValue.current(v, remark: remark));
  }

  num? parseReading(String valString) {
    return num.tryParse(
        valString.replaceAll(RegExp(r'[^. 0-9]', caseSensitive: false), ""));
  }
}
