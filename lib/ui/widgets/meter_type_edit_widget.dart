import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/entities/meter_type.dart';
import 'package:rh_collector/l10n/app_localizations.dart';
import 'package:rh_collector/domain/states/meter_types_state.dart';

class MeterTypeEditWidget extends StatelessWidget {
  MeterTypeEditWidget({
    super.key,
    required this.meterType,
    required this.updateCallback,
  });

  final MeterType meterType;
  final Function(MeterType) updateCallback;
  final colors = [
    Colors.black.toARGB32(),
    Colors.red.toARGB32(),
    Colors.yellow.toARGB32(),
    Colors.blue.toARGB32(),
    Colors.green.toARGB32(),
    Colors.orange.toARGB32(),
    Colors.purple.toARGB32()
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
                            value: e.codePoint,
                            child: Icon(e),
                          ))
                      .toList(),
                  onChanged: _changeIcon),
              DropdownButton<int>(
                  value: meterType.color,
                  items: colors
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Icon(
                              Icons.color_lens,
                              color: Color(e),
                            ),
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
