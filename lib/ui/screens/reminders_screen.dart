import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/states/reminders_state.dart';
import 'package:rh_collector/ui/widgets/reminder_widget.dart';
import 'package:rh_collector/l10n/app_localizations.dart';

class RemindersScreen extends StatelessWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => RemindersState());
    final state = Get.find<RemindersState>();
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.reminders),
        actions: [
          IconButton(
              onPressed: () => state.createEmptyReminder(),
              icon: const Icon(Icons.add)),
        ],
      ),
      body: GetX<RemindersState>(builder: (state) {
        return ListView.builder(
          itemCount: state.reminders.length,
          itemBuilder: ((context, index) => ReminderWidget(
                reminder: state.reminders[index],
                updateCallback: (reminder) {
                  state.updateReminder(reminder: reminder, index: index);
                },
                saveCallback: () {
                  state.saveUpdatedNotification(index);
                },
                deleteCallback: () {
                  state.deleteNotification(index);
                },
                clearContent: () {
                  state.clearScheduleContent(index);
                },
              )),
        );
      }),
    );
  }
}
