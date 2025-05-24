import 'package:flutter/material.dart';
import 'package:photo_data_picker/domain/data_picker_state.dart';
import 'package:photo_data_picker/ui/widget/data_picker_widget.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key, this.meterName});
  final String? meterName;

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  TextEditingController textCtrl = TextEditingController();
  late DataPickerState state = DataPickerState(
      onReadingChanged: (v) => setState(() => textCtrl.text = v));

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
    final screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.meterName ?? ""),
        ),
        body: SingleChildScrollView(
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
                child: TextField(
                  controller: textCtrl,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      suffix: IconButton(
                          onPressed: () {
                            final valString = textCtrl.text;
                            if (valString.isEmpty) return;
                            final v = int.tryParse(valString.replaceAll(
                                RegExp(r'[a-z \W]', caseSensitive: false), ""));
                            if (v == null) return;
                            Navigator.pop(context, v.toString());
                          },
                          icon: const Icon(Icons.check))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
