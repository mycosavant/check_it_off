import 'package:check_it_off/store/app_state.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:check_it_off/helpers/notification_helper.dart';
import 'package:check_it_off/screens/Splash.dart';
import 'package:check_it_off/screens/tasks_screen.dart';
import 'package:check_it_off/store/store.dart';
import 'package:flutter/material.dart';
import 'package:check_it_off/models/task_data.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';
import 'helpers/quick_action_helper.dart';
import 'models/theme_notifier.dart';
import 'models/themes.dart';

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

  @override
  void initState() {
    super.initState();
    QuickActionHelper qAHelper = QuickActionHelper();
    qAHelper.setupQuickActions();
    qaOrder = qAHelper.computeQuickActions();
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
          '/': (context) => Splash(qaOrder),
          '/tasks': (context) => TasksScreen(),
        },
        // TasksScreen(),
      ),
    );
  }
}
