import 'package:check_it_off/models/task.dart';
import 'package:flutter/foundation.dart';
import 'dart:collection';

import 'package:flutter/material.dart';

class TaskData extends ChangeNotifier {
  List<Task> _tasks = [
    Task(name: 'Buy milk', priority: priorityLevel.Normal),
    Task(name: 'Buy eggs', priority: priorityLevel.Normal),
    Task(name: 'Buy bread', priority: priorityLevel.Normal),
  ];

  UnmodifiableListView<Task> get tasks {
    return UnmodifiableListView(_tasks);
  }

  int get taskCount {
    return _tasks.length;
  }

  void addTask(String newTaskTitle, String priority) {
    priorityLevel newPriority;
    if(priorityLevel.High.toString().contains(priority)){
      newPriority = priorityLevel.High;
    }
    else if(priorityLevel.Low.toString().contains(priority)){
      newPriority = priorityLevel.Low;
    }
    else {
      newPriority = priorityLevel.Normal;
    }
    final task = Task(name: newTaskTitle, priority: newPriority);
    _tasks.add(task);
    notifyListeners();
  }

  void editTask(String theTaskTitle, int index, String selectedPriority) {
    priorityLevel editPriority;
    if(priorityLevel.High.toString().contains(selectedPriority)){
      editPriority = priorityLevel.High;
    }
    else if(priorityLevel.Low.toString().contains(selectedPriority)){
      editPriority = priorityLevel.Low;
    }
    else {
        editPriority = priorityLevel.Normal;
    }
    final task = Task(name: theTaskTitle, priority: editPriority);
    _tasks[index].name = task.name;
    _tasks[index].priority = task.priority;
    _tasks[index].isDone = task.isDone;
    notifyListeners();
  }


  void updateTask(Task task) {
    task.toggleDone();
    notifyListeners();
  }

  void deleteTask(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }
}
