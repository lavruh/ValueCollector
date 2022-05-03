import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/states/reminders_state.dart';
import 'package:rh_collector/ui/widgets/reminder_widget.dart';

class RemindersScreen extends StatelessWidget {
  const RemindersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => RemindersState());
    final state = Get.find<RemindersState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        actions: [
          IconButton(
              onPressed: () => state.createEmptyReminder(),
              icon: const Icon(Icons.add)),
        ],
      ),
      body: GetX<RemindersState>(builder: (_) {
        return ListView.builder(
          itemCount: _.reminders.length,
          itemBuilder: ((context, index) => ReminderWidget(
                reminder: _.reminders[index],
                updateCallback: (reminder) {
                  _.updateReminder(reminder: reminder, index: index);
                },
                saveCallback: () {
                  _.saveUpdatedNotification(index);
                },
                deleteCallback: () {
                  _.deleteNotification(index);
                },
                clearContent: () {
                  _.clearScheduleContent(index);
                },
              )),
        );
      }),
    );
  }
}
