import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/entities/reminder.dart';

class RemindersState extends GetxController {
  final reminders = <Reminder>[].obs;

  @override
  onInit() async {
    super.onInit();
    await getActiveNotifications();
  }

  getActiveNotifications() async {
    final notifications =
        await AwesomeNotifications().listScheduledNotifications();
    reminders.value =
        notifications.map((e) => Reminder.fromNotification(e)).toList();
  }

  createEmptyReminder() async {
    reminders.add(Reminder());
  }

  deleteNotification(int index) async {
    int id = reminders[index].id;
    reminders.removeAt(index);
    await AwesomeNotifications().cancel(id);
  }

  saveUpdatedNotification(int index) async {
    final reminder = reminders[index].copyWith(isChanged: false);
    await AwesomeNotifications().cancel(reminder.id);
    final isDone = await AwesomeNotifications().createNotification(
      content: reminder.toNotificationContent(),
      actionButtons: [
        NotificationActionButton(key: "DONE", label: "Done"),
      ],
      schedule: reminder.toNotificationCalendar(),
    );
    if (isDone) {
      reminders[index] = reminder;
    }
  }

  updateReminder({required Reminder reminder, required int index}) {
    reminders[index] = reminder;
  }

  clearScheduleContent(int index) {
    reminders[index] =
        reminders[index].copyWith(schedule: ValidSchedule(), isChanged: true);
  }
}
