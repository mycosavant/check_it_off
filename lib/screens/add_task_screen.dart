import 'dart:io' show Platform;
import 'package:check_it_off/helpers/db.dart';
import 'package:check_it_off/models/theme_notifier.dart';
import 'package:check_it_off/widgets/task_form.dart';
import 'package:check_it_off/widgets/toggle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:check_it_off/models/task.dart';
import 'package:flutter/scheduler.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/Provider.dart';
import 'package:check_it_off/models/task_data.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:intl/intl.dart';

String newTaskTitle;

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TaskForm(
      priority: 'Normal',
      recurring: 'No',
      interval: 'None',
      addToCalendar: 'No',
      numberOfRecurrences: 0,
      mode: 'add',
      task: null,
    );
  }
}
