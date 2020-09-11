import 'package:flutter/material.dart';
import 'package:check_it_off/screens/tasks_screen.dart';
import 'package:provider/provider.dart';
import 'package:check_it_off/models/task_data.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => TaskData(),
      child: MaterialApp(
        home: TasksScreen(),
      ),
    );
  }
}
