import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/entities/meter_type.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rh_collector/domain/states/meter_types_state.dart';

class MeterTypeEditWidget extends StatelessWidget {
  MeterTypeEditWidget({
    Key? key,
    required this.meterType,
    required this.updateCallback,
  }) : super(key: key);

  final MeterType meterType;
  final Function(MeterType) updateCallback;
  final colors = [
    Colors.black.value,
    Colors.red.value,
    Colors.yellow.value,
    Colors.blue.value,
    Colors.green.value,
    Colors.orange.value,
    Colors.purple.value
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            children: [
              TextFormField(
                controller: TextEditingController(text: meterType.name),
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.name),
                onFieldSubmitted: _changeName,
              ),
              DropdownButton<int>(
                  value: meterType.iconCode,
                  items: Get.find<MeterTypesState>()
                      .icons
                      .map((e) => DropdownMenuItem(
                            child: Icon(e),
                            value: e.codePoint,
                          ))
                      .toList(),
                  onChanged: _changeIcon),
              DropdownButton<int>(
                  value: meterType.color,
                  items: colors
                      .map((e) => DropdownMenuItem(
                            child: Icon(
                              Icons.color_lens,
                              color: Color(e),
                            ),
                            value: e,
                          ))
                      .toList(),
                  onChanged: _changeColor)
            ],
          ),
        ),
      ),
    );
  }

  void _changeColor(int? val) {
    updateCallback(meterType.copyWith(color: val));
  }

  void _changeIcon(int? val) {
    updateCallback(meterType.copyWith(iconCode: val));
  }

  void _changeName(String value) {
    updateCallback(meterType.copyWith(name: value));
  }
}
