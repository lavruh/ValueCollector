import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/entities/setting.dart';
import 'package:rh_collector/domain/states/settings_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: GetX<SettingsState>(
        builder: (SettingsState state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: state.settings
                .map((e) => SettingWidget(
                      item: e,
                      updateValue: state.setSetting,
                    ))
                .toList(),
          );
        },
      ),
    );
  }
}

class SettingWidget extends StatefulWidget {
  const SettingWidget(
      {super.key, required this.item, required this.updateValue});
  final Setting item;
  final void Function(Setting val) updateValue;

  @override
  State<SettingWidget> createState() => _SettingWidgetState();
}

class _SettingWidgetState extends State<SettingWidget> {
  final key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.item.title),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                width: 100,
                height: 50,
                child: Form(key: key, child: generateInput(context))),
          ),
        ],
      ),
    );
  }

  Widget generateInput(BuildContext context) {
    final initVal = widget.item.value;
    if (initVal is int) {
      return _intValue(initVal);
    }
    if (initVal is Color) {
      return _colorValue(context, initVal);
    }
    if (initVal is bool) {
      return _boolValue(initVal);
    }
    return Text(initVal.toString());
  }

  Switch _boolValue(bool initVal) {
    return Switch(
        value: initVal,
        onChanged: (value) {
          widget.updateValue(widget.item.setValue(value));
        });
  }

  IconButton _colorValue(BuildContext context, Color initVal) {
    return IconButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: SizedBox(
                    height: MediaQuery.of(context).size.width,
                    // width: 200,
                    child: SingleChildScrollView(
                      child: ColorPicker(
                          pickerColor: initVal,
                          pickerAreaHeightPercent: 0.8,
                          onColorChanged: (val) {
                            widget.updateValue(widget.item.setValue(val));
                          }),
                    ),
                  ),
                );
              });
        },
        icon: Icon(
          Icons.circle,
          color: initVal,
        ));
  }

  Widget _intValue(int initVal) {
    return TextFormField(
      controller: TextEditingController(text: initVal.toString()),
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      decoration: const InputDecoration(border: OutlineInputBorder()),
      validator: widget.item.validator,
      onFieldSubmitted: (value) {
        if (!key.currentState!.validate()) return;
        final number = int.tryParse(value);
        if (number == null) return;
        widget.updateValue(widget.item.setValue(number));
      },
    );
  }
}
