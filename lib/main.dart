import 'package:check_it_off/helpers/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:check_it_off/screens/tasks_screen.dart';
import 'package:provider/Provider.dart' as Prov;
import 'package:check_it_off/models/task_data.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';

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
    return Prov.ChangeNotifierProvider(
      builder: (context) => TaskData(),
      child: MaterialApp(
        theme: themeNotifier.getTheme(),
        home: SplashScreen(
          seconds: 3,
          navigateAfterSeconds: new Onboarding(),
          title: Text(''),
          // title: new Text('Welcome In SplashScreen',
          //   style: new TextStyle(
          //       fontWeight: FontWeight.bold,
          //       fontSize: 20.0
          //   ),
          // ),
          image: new Image.asset(
            'assets/splash.png',
          ),
          // backgroundGradient: new LinearGradient(colors: [Colors.cyan, Colors.blue], begin: Alignment.topLeft, end: Alignment.bottomRight),
          backgroundColor: Colors.lightBlueAccent,
          styleTextUnderTheLoader: new TextStyle(),
          photoSize: 150,
          onClick: () => print("Flutter Egypt"),
          loaderColor: Colors.white,
        ),
        // TasksScreen(),
      ),
    );
  }
}
