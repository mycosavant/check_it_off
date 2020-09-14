import 'package:flutter/material.dart';
import 'package:check_it_off/screens/tasks_screen.dart';
import 'package:provider/Provider.dart' as Prov;
import 'package:check_it_off/models/task_data.dart';

import 'helpers/db.dart';
import 'models/task.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Prov.ChangeNotifierProvider(
      builder: (context) => TaskData(),
      child: MaterialApp(
        home: TasksScreen(),
      ),
    );
  }
}

