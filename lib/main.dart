import 'package:check_it_off/screens/Splash.dart';
import 'package:check_it_off/screens/tasks_screen.dart';
import 'package:flutter/material.dart';
import 'package:check_it_off/models/task_data.dart';
import 'package:provider/provider.dart';
import 'models/theme_notifier.dart';
import 'models/themes.dart';

void main() => runApp(
      ChangeNotifierProvider<ThemeNotifier>(
        create: (_) => ThemeNotifier(darkTheme, 'system'),
        child: MyApp(),
      ),
    );


class MyApp extends StatelessWidget {
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
          '/': (context) => Splash(),
          // When navigating to the "/second" route, build the SecondScreen widget.
          '/tasks': (context) => TasksScreen(),
        },
        // TasksScreen(),
      ),
    );
  }
}
