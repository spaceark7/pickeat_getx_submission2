import 'dart:io';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:pickeat_app/common/navigation.dart';

import 'package:pickeat_app/common/style.dart';
import 'package:pickeat_app/common/utils/background_process.dart';
import 'package:pickeat_app/common/utils/notification_helper.dart';
import 'package:pickeat_app/controller/database_controller.dart';
import 'package:pickeat_app/controller/scheduling_controller.dart';
import 'package:pickeat_app/data/database/database_helper.dart';
import 'package:pickeat_app/ui/detail_restaurant_screen.dart';
import 'package:pickeat_app/ui/favorite_screen.dart';
import 'package:pickeat_app/ui/home_screen.dart';
import 'package:pickeat_app/ui/profile_screen.dart';
import 'package:pickeat_app/ui/settings_screen.dart';
import 'controller/restaurant_controller.dart';
import 'data/model/restaurant.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final NotificationHelper _notificationHelper = NotificationHelper();
  final BackgroundService _service = BackgroundService();
  _service.initializeIsolate();
  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await _notificationHelper.initNotifications(flutterLocalNotificationsPlugin);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final RestaurantController restaurantController = Get.put(RestaurantController());
  final DatabaseController databaseController = Get.put(DatabaseController(databaseHelper: DatabaseHelper()));
  final SchedulingController schedulingController = Get.put(SchedulingController());
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: navigatorKey,
      title: 'PickEat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryBrandColor,
        accentColor: secondaryBrandColor,
        dividerColor: accentBrandColor,
        scaffoldBackgroundColor: backgoundColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: brandTextTheme,
        appBarTheme: AppBarTheme(textTheme: brandTextTheme.apply(bodyColor: Colors.black), elevation: 0),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: secondaryBrandColor,
          unselectedItemColor: Colors.grey,
        ),
      ),
      initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName: (context) => HomeScreen(),
        DetailScreen.routeName: (context) => DetailScreen(restaurant: ModalRoute.of(context)?.settings.arguments as Restaurant),
        FavoriteScreen.routeName: (context) => FavoriteScreen(),
        ProfileScreen.routeName: (context) => ProfileScreen(),
        SettingsScreen.routeName: (context) => SettingsScreen(),
      },
    );
  }
}
