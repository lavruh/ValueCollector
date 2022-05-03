import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class Reminder {
  final int _id;
  final String _text;
  final String _channelKey;
  final ValidSchedule _schedule;
  bool isChanged = false;

  int get id => _id;
  String get text => _text;
  ValidSchedule get schedule => _schedule;

  Reminder({
    int? id,
    String? text,
    String? channelKey,
    ValidSchedule? schedule,
    this.isChanged = false,
  })  : _id = id ?? DateTime.now().microsecondsSinceEpoch.remainder(100000),
        _text = text ?? "",
        _channelKey = channelKey ?? "basic_channel",
        _schedule = schedule ?? ValidSchedule();

  factory Reminder.fromNotification(NotificationModel model) {
    if (model.content == null || model.schedule == null) {
      throw Exception("Invalid notification data");
    }
    return Reminder(
        id: model.content?.id,
        text: model.content?.body,
        channelKey: model.content?.channelKey,
        schedule: ValidSchedule.fromMap(model.schedule!.toMap()));
  }

  NotificationContent toNotificationContent() {
    return NotificationContent(
      id: id,
      channelKey: _channelKey,
      title: "Value Collector",
      body: text,
      notificationLayout: NotificationLayout.Default,
    );
  }

  NotificationCalendar? toNotificationCalendar() {
    if (schedule.isAnyFieldSet()) {
      return schedule.toNotificationCalendar();
    }
    return null;
  }

  Reminder copyWith({
    int? id,
    String? text,
    String? channelKey,
    ValidSchedule? schedule,
    bool? isChanged,
  }) {
    return Reminder(
      id: id ?? _id,
      text: text ?? _text,
      channelKey: channelKey ?? _channelKey,
      schedule: schedule ?? _schedule,
      isChanged: isChanged ?? false,
    );
  }

  Reminder updateValue({
    int? id,
    String? text,
    String? channelKey,
    ValidSchedule? schedule,
    bool? isChanged,
  }) {
    return Reminder(
      id: id ?? _id,
      text: text ?? _text,
      channelKey: channelKey ?? _channelKey,
      schedule: schedule ?? _schedule,
      isChanged: true,
    );
  }
}

class ValidSchedule {
  int? _month;
  int? _day;
  int? _hour;
  int? _minute;
  int? _weekday;
  bool repeat = false;

  ValidSchedule(
      {int? month, int? day, int? h, int? min, int? weekday, bool? repeat}) {
    this.month = month;
    this.day = day;
    hour = h;
    minute = min;
    this.weekday = weekday;
    this.repeat = repeat ?? false;
  }

  factory ValidSchedule.fromMap(Map m) {
    return ValidSchedule(
      month: m["month"],
      day: m["day"],
      h: m["hour"],
      min: m["minute"],
      weekday: m["weekday"],
      repeat: m['repeats'],
    );
  }

  int? get month => _month;
  int? get day => _day;
  int? get hour => _hour;
  int? get minute => _minute;
  int? get weekday => _weekday;
  TimeOfDay? get time {
    if (_hour == null || _minute == null) {
      return null;
    }
    return TimeOfDay(hour: _hour!, minute: _minute!);
  }

  set month(int? m) {
    if (m != null && m < 12 && m >= 1) {
      _month = m;
    }
  }

  set day(int? v) {
    if (v != null && v < 31 && v >= 1) {
      _day = v;
    }
  }

  set hour(int? h) {
    if (h != null && h < 24 && h >= 0) {
      _hour = h;
    }
  }

  set minute(int? m) {
    if (m != null && m >= 0 && m < 60) {
      _minute = m;
    }
  }

  set weekday(int? v) {
    if (v != null && v >= 1 && v <= 7) {
      _weekday = v;
    }
  }

  bool isAnyFieldSet() {
    if (_month != null ||
        _day != null ||
        _hour != null ||
        _minute != null ||
        _weekday != null) {
      return true;
    }
    return false;
  }

  NotificationCalendar toNotificationCalendar() {
    return NotificationCalendar(
      month: _month,
      day: _day,
      hour: _hour,
      minute: _minute,
      second: 0,
      weekday: _weekday,
      preciseAlarm: true,
      repeats: repeat,
    );
  }

  ValidSchedule copyWith({
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? weekday,
    bool? repeat,
  }) {
    return ValidSchedule(
      month: month ?? _month,
      day: day ?? _day,
      h: hour ?? _hour,
      min: minute ?? _minute,
      weekday: weekday ?? _weekday,
      repeat: repeat ?? this.repeat,
    );
  }
}
