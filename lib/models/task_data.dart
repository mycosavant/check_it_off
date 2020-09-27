import 'package:check_it_off/models/task.dart';
import 'package:flutter/foundation.dart';
import 'dart:collection';

import 'package:flutter/material.dart';

class TaskData extends ChangeNotifier {
  List<Task> tasks = [
  ];

  int get taskCount {
    return tasks.length;
  }

  Task addTask(String newTaskTitle, String priority) {
    priorityLevel newPriority;
    if (priorityLevel.High.toString().contains(priority)) {
      newPriority = priorityLevel.High;
    } else if (priorityLevel.Low.toString().contains(priority)) {
      newPriority = priorityLevel.Low;
    } else {
      newPriority = priorityLevel.Normal;
    }
    final task = Task(name: newTaskTitle, priority: newPriority);
    tasks.add(task);
    notifyListeners();
    return task;
  }

  void editTask(String theTaskTitle, int index, String selectedPriority) {
    priorityLevel editPriority;
    if (priorityLevel.High.toString().contains(selectedPriority)) {
      editPriority = priorityLevel.High;
    } else if (priorityLevel.Low.toString().contains(selectedPriority)) {
      editPriority = priorityLevel.Low;
    } else {
      editPriority = priorityLevel.Normal;
    }
    final task = Task(name: theTaskTitle, priority: editPriority);
    tasks[index].name = task.name;
    tasks[index].priority = task.priority;
    tasks[index].isDone = task.isDone;
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
