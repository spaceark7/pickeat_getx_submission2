import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:get/get.dart';
import 'package:pickeat_app/common/utils/background_process.dart';
import 'package:pickeat_app/common/utils/date_time_helper.dart';

class SchedulingController extends GetxController {
  bool _isScheduled = false;

  bool get isScheduled => this._isScheduled;

  Future<bool> scheduleReminder(bool value) async {
    _isScheduled = value;
    if (_isScheduled) {
      print('Scheduling Reminder Activated');
      update();
      return await AndroidAlarmManager.periodic(
         Duration(hours: 24),
         1, 
         BackgroundService.callback,
         startAt:   DateTimeHelper.format(),
         exact: true,
         wakeup: true
         
         );
    } else {
        print('Scheduling Reminders Canceled');
        update();
        return await AndroidAlarmManager.cancel(1);
    }
  }
}
