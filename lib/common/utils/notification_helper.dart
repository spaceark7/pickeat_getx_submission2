import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pickeat_app/common/navigation.dart';
import 'package:pickeat_app/data/model/restaurant.dart';
import 'package:rxdart/rxdart.dart';

final selectNotificationSubject = BehaviorSubject<String>();

class NotificationHelper {
  static NotificationHelper? _instance;
  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  Future<void> initNotifications(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingsAndroid = AndroidInitializationSettings('logo');
    var initializationSettingsIOS = IOSInitializationSettings(requestAlertPermission: false, requestBadgePermission: false, requestSoundPermission: false);

    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: (String? payload) async {
      if (payload != null) {
        print('Notification Payload: ' + payload);
      }
      selectNotificationSubject.add(payload ?? 'empty payload');
    });
  }

  Future<void> showNotification(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin, RestaurantResult restaurants) async {
    var _channelId = "1";
    var _channelName = "channel_01";
    var _channelDescription = "Pick\'eat Notification";

    var androidPlatformChannelSpesifics = AndroidNotificationDetails(_channelId, _channelName, _channelDescription,
        importance: Importance.max, priority: Priority.high, ticker: 'ticker', styleInformation: DefaultStyleInformation(true, true));

    var iosPlatformChannelSpesifics = IOSNotificationDetails();
    var platformChannelSpesifics = NotificationDetails(android: androidPlatformChannelSpesifics, iOS: iosPlatformChannelSpesifics);

    var titleNotification = "<b>Today Recommendations</b>";
    var titleNews = restaurants.restaurants[0].name;

    await flutterLocalNotificationsPlugin.show(0, titleNotification, titleNews, platformChannelSpesifics, payload: json.encode(restaurants.toJson()));
  }

  void configureSelectNotificationSubject(String route) {
    selectNotificationSubject.stream.listen((String payload) async {
      var data = RestaurantResult.fromJson(json.decode(payload));
      print('from configure helper');
      print(data.restaurants.map((e) => e.name));
      var restaurant = data.restaurants[0];
      Navigation.intentWithData(route, restaurant);
    });
  }

  void requestIOSPermissions(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) {
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }
}
