import 'package:check_it_off/helpers/calendar.dart';
import 'package:check_it_off/models/task.dart';
import 'package:flutter/foundation.dart';
import 'dart:collection';

import 'package:flutter/material.dart';

class TaskData extends ChangeNotifier {
  List<Task> tasks = [];

  int get taskCount {
    return tasks.length;
  }

  Task addTask(
      {String newTaskTitle,
      String priority,
      String interval,
      String dueDate,
      int numberOfRecurrences,
      bool addToCalendar}) {
    priorityLevel newPriority;
    if (priorityLevel.High.toString().contains(priority)) {
      newPriority = priorityLevel.High;
    } else if (priorityLevel.Low.toString().contains(priority)) {
      newPriority = priorityLevel.Low;
    } else {
      newPriority = priorityLevel.Normal;
    }
    recurrenceInterval newInterval;
    newInterval = (interval.toString().contains('Daily'))
        ? recurrenceInterval.Daily
        : (interval.toString().contains('Weekly'))
            ? recurrenceInterval.Weekly
            : (interval.toString().contains('Monthly'))
                ? recurrenceInterval.Monthly
                : (interval.toString().contains('Yearly'))
                    ? recurrenceInterval.Yearly
                    : recurrenceInterval.None;
    final task = Task(
        name: newTaskTitle,
        priority: newPriority,
        interval: newInterval,
        recurring: newInterval.toString().contains('None') ? false : true,
        dueDate: (dueDate == '' && addToCalendar
            ? DateTime.now().toString()
            : dueDate),
        numberOfRecurrences: numberOfRecurrences);
    // if (addToCalendar) {
    //   CalendarHelper ch = new CalendarHelper();
    //   ch.addEventForCalendar(newTaskTitle, newTaskTitle,
    //       dueDate == null ? DateTime.now() : dueDate == '' ? DateTime.now() : DateTime.parse(dueDate));
    // }
    tasks.add(task);
    notifyListeners();
    return task;
  }

  void editTask({
      String theTaskTitle,
      int index,
      String selectedPriority,
      String interval,
      String dueDate,
      int numberOfRecurrences,
      bool addToCalendar}) {
    priorityLevel editPriority;
    if (priorityLevel.High.toString().contains(selectedPriority)) {
      editPriority = priorityLevel.High;
    } else if (priorityLevel.Low.toString().contains(selectedPriority)) {
      editPriority = priorityLevel.Low;
    } else {
      editPriority = priorityLevel.Normal;
    }
    recurrenceInterval newInterval;
    newInterval = (interval.toString().contains('Daily'))
        ? recurrenceInterval.Daily
        : (interval.toString().contains('Weekly'))
            ? recurrenceInterval.Weekly
            : (interval.toString().contains('Monthly'))
                ? recurrenceInterval.Monthly
                : (interval.toString().contains('Yearly'))
                    ? recurrenceInterval.Yearly
                    : recurrenceInterval.None;
    final task = Task(
        name: theTaskTitle,
        priority: editPriority,
        interval: newInterval,
        recurring: newInterval.toString().contains('None') ? false : true,
        dueDate: (dueDate == '' && addToCalendar
            ? DateTime.now().toString()
            : dueDate),
        numberOfRecurrences: numberOfRecurrences);
    tasks[index].name = task.name;
    tasks[index].priority = task.priority;
    tasks[index].isDone = task.isDone;
    tasks[index].interval = task.interval;
    tasks[index].dueDate = task.dueDate;
    tasks[index].recurring = task.recurring;
    tasks[index].numberOfRecurrences = task.numberOfRecurrences;
    tasks[index].id = task.id;


    notifyListeners();
  }

  void updateTask(Task task) {
    task.toggleDone();
    notifyListeners();
  }

  void deleteTask(Task task) {
    tasks.remove(task);
    notifyListeners();
  }

  void refreshList(List<Task> tasksList) {
    tasks.clear();
    tasks.addAll(tasksList);
    notifyListeners();
  }

  void notify() {
    notifyListeners();
  }
}
