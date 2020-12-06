import 'dart:io';
import 'package:check_it_off/store/app_state.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:check_it_off/helpers/notification_helper.dart';
import 'package:check_it_off/screens/Splash.dart';
import 'package:check_it_off/screens/tasks_screen.dart';
import 'package:check_it_off/store/store.dart';
import 'package:flutter/material.dart';
import 'package:check_it_off/models/task_data.dart';
import 'package:provider/provider.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/theme_notifier.dart';
import 'models/themes.dart';
import 'dart:async';
import 'dart:convert';
import 'package:home_widget/home_widget.dart';

const EVENTS_KEY = "fetch_events";

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
NotificationAppLaunchDetails notificationAppLaunchDetails;
Store<AppState> store;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initStore();
  store = getStore();
  notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  await initNotifications(flutterLocalNotificationsPlugin);
  requestIOSPermissions(flutterLocalNotificationsPlugin);
  runApp(
    ChangeNotifierProvider<ThemeNotifier>(
      create: (_) => ThemeNotifier(darkTheme, 'system'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String qaOrder;
  bool _enabled = true;
  int _status = 0;
  List<DateTime> _events = [];


  @override
  void initState() {
    // HomeWidget.setAppGroupId('group..com.grimshawcoding.check_it_off');
    super.initState();
    final QuickActions quickActions = QuickActions();
    quickActions.initialize((String shortcutType) {
      switch (shortcutType) {
        case 'action_2':
          {
            qaOrder = 'today';
          }
          break;
        case 'action_3':
          {
            qaOrder = 'asc';
          }
          break;
        case 'action_4':
          {
            qaOrder = 'aasc';
          }
          break;
        case 'action_5':
          {
            qaOrder = 'dueasc';
          }
          break;
        case 'action_6':
          {
            qaOrder = 'adsc';
          }
          break;
        case 'action_7':
          {
            qaOrder = 'duedsc';
          }
          break;
        case 'action_8':
          {
            qaOrder = 'normal';
          }
          break;
        default:
          {
            //just open the app
          }
          break;
      }
    });

    quickActions.setShortcutItems(<ShortcutItem>[
      const ShortcutItem(type: 'action_1', localizedTitle: 'Open'),
      const ShortcutItem(type: 'action_2', localizedTitle: 'Due Today'),
      const ShortcutItem(type: 'action_3', localizedTitle: 'Priority'),
      // const ShortcutItem(type: 'action_4', localizedTitle: 'Alphabetical'),
      // const ShortcutItem(
      //     type: 'action_6', localizedTitle: 'Alphabetical (Reverse)'),
      const ShortcutItem(type: 'action_5', localizedTitle: 'Due Date'),
      // const ShortcutItem(
      //     type: 'action_7', localizedTitle: 'Due Date (Reverse)'),
      // const ShortcutItem(type: 'action_8', localizedTitle: 'Unsorted'),
    ]);
  }
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return ChangeNotifierProvider(
      create: (context) => TaskData(),
      child: MaterialApp(
        theme: themeNotifier.getTheme(),
        initialRoute: '/',
        routes: {
          // When navigating to the "/" route, build the FirstScreen widget.
          '/': (context) => Splash(qaOrder),
          // When navigating to the "/second" route, build the SecondScreen widget.
          '/tasks': (context) => TasksScreen(),
        },
        // TasksScreen(),
      ),
    );
  }
}
