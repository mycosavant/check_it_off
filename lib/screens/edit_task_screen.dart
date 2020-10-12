import 'package:check_it_off/widgets/task_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:check_it_off/models/task.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;
  final int index;
  EditTaskScreen(this.task, this.index);

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState(task, index);
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final Task task;
  final int index;
  String _selectedPriority;
  _EditTaskScreenState(this.task, this.index);

  void initState() {
    super.initState();
    // loadDB();
  }

  @override
  Widget build(BuildContext context) {
    return TaskForm(
      task: task,
      priority: task.priority,
      interval: task.interval,
      numberOfRecurrences: task.numberOfRecurrences,
      dueDate: task.dueDate,
      addToCalendar: 'No',
      recurring: task.recurring ? 'Yes' : 'No',
      mode: 'edit',
      index: index,
    );
  }
}
