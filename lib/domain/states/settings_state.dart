import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rh_collector/data/services/db_service.dart';
import 'package:rh_collector/domain/entities/setting.dart';

class SettingsState extends GetxController {
  final _settings = <String, Setting>{
    'valueColorNotificationTime': Setting<int>(
      'valueColorNotificationTime',
      'Value Color Notification Time[h]',
      12,
      validator: (v) {
        final i = int.tryParse(v);
        if (i == null) return "Not correct";
        if (i < 1) return "less than 1";
        return null;
      },
    ),
    'highlightColor':
        Setting<Color>('highlightColor', "Value highlight color", Colors.green),
  }.obs;

  final DbService db;
  final tableName = "settings";

  SettingsState(this.db);

  List<Setting> get settings => _settings.values.toList();

  int get valueColorNotificationTime =>
      _settings['valueColorNotificationTime']!.value;

  Color get highlightColor => _settings['highlightColor']!.value;

  void setSetting(Setting val) {
    _settings[val.id] = val;
    db.updateEntry(val.toMap(), table: tableName);
  }

  Future<void> initSettings() async {
    final settingsFromDb = await db.getEntries([], table: tableName);
    if (settingsFromDb.isNotEmpty) {
      for (final settingFromDb in settingsFromDb) {
        final id = settingFromDb['id'];
        if (id == null || !_settings.containsKey(id)) continue;
        final s = _settings[id]!;
        _settings[id] = s.fromMap(settingFromDb);
      }
    }
  }

  @override
  void onInit() {
    initSettings();
    super.onInit();
  }
}

