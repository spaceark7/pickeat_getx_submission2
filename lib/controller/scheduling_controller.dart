import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:get/get.dart';
import 'package:pickeat_app/common/utils/background_process.dart';
import 'package:pickeat_app/common/utils/date_time_helper.dart';

class SchedulingController extends GetxController {
  var isScheduled = false.obs;

  Future<bool> scheduleReminder(bool value) async {
    isScheduled.value = value;
    update();
    if (isScheduled.value) {
      print('Scheduling Reminder Activated');
      update();
      return await AndroidAlarmManager.periodic(
        Duration(hours: 24),
        1,
        BackgroundService.callback,
        startAt: DateTimeHelper.format(),
        exact: true,
        wakeup: true,
      );
    } else {
      print('Scheduling Reminders Canceled');
      update();
      return await AndroidAlarmManager.cancel(1);
    }
  }
}
