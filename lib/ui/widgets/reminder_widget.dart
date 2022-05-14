import 'package:flutter/material.dart';
import 'package:rh_collector/domain/entities/reminder.dart';
import 'package:rh_collector/ui/widgets/reminder/actions_panel_widget.dart';
import 'package:rh_collector/ui/widgets/reminder/date_select_widget.dart';
import 'package:rh_collector/ui/widgets/reminder/time_select_widget.dart';
import 'package:rh_collector/ui/widgets/reminder/weekday_selector_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReminderWidget extends StatelessWidget {
  const ReminderWidget({
    Key? key,
    required this.reminder,
    required this.updateCallback,
    required this.saveCallback,
    required this.deleteCallback,
    required this.clearContent,
  }) : super(key: key);
  final Reminder reminder;
  final void Function(Reminder r) updateCallback;
  final void Function() saveCallback;
  final void Function() deleteCallback;
  final void Function() clearContent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Card(
        elevation: 5,
        child: ListTile(
          title: TextField(
            decoration: InputDecoration(
                label: Text(AppLocalizations.of(context)!.name)),
            controller: TextEditingController(text: reminder.text),
            onSubmitted: _updateText,
          ),
          subtitle: Column(
            children: [
              SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.calendar_month),
                    DateSelectWidget(
                      callback: _updateMonth,
                      maxValue: 12,
                      minValue: 1,
                      placeholder: AppLocalizations.of(context)!.monthLetter,
                      value: reminder.schedule.month,
                    ),
                    DateSelectWidget(
                        value: reminder.schedule.day,
                        maxValue: 31,
                        minValue: 1,
                        placeholder: AppLocalizations.of(context)!.dayLetter,
                        callback: _updateDay),
                    const Icon(Icons.alarm),
                    TimeSelectWidget(
                        updateTime: updateTime, schedule: reminder.schedule),
                    Text(AppLocalizations.of(context)!.repeat),
                    Checkbox(
                        value: reminder.schedule.repeat,
                        onChanged: _updateRepeat),
                  ],
                ),
              ),
              WeekdaySelectorWidget(
                  resultSetter: _updateWeekday,
                  selected: reminder.schedule.weekday),
              ActionsPanelWidget(
                  saveCallback: saveCallback,
                  deleteCallback: deleteCallback,
                  clearContent: clearContent,
                  showSaveButton: reminder.isChanged)
            ],
          ),
        ),
      ),
    );
  }

  _updateRepeat(bool? val) {
    updateCallback(reminder.updateValue(
      schedule: reminder.schedule.copyWith(repeat: val),
    ));
  }

  _updateWeekday(int newVal) {
    updateCallback(reminder.updateValue(
      schedule: reminder.schedule.copyWith(weekday: newVal),
    ));
  }

  void _updateText(String value) {
    updateCallback(reminder.updateValue(text: value));
  }

  void updateTime(TimeOfDay time) {
    updateCallback(reminder.updateValue(
      schedule: reminder.schedule.copyWith(
        hour: time.hour,
        minute: time.minute,
      ),
    ));
  }

  void _updateMonth(int value) {
    updateCallback(reminder.updateValue(
      schedule: reminder.schedule.copyWith(month: value),
    ));
  }

  void _updateDay(int value) {
    updateCallback(reminder.updateValue(
      schedule: reminder.schedule.copyWith(day: value),
    ));
  }
}
