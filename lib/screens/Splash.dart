import 'package:check_it_off/screens/tasks_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SplashScreen(
        seconds: 3,
        navigateAfterSeconds: TasksScreen(),
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
        photoSize:    MediaQuery.of(context).orientation == Orientation.portrait ? 150 : 100,
        onClick: (){},
        loaderColor: Colors.white,
      ),
    );
  }
}

