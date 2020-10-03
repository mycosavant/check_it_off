import 'package:check_it_off/helpers/db.dart';

enum priorityLevel { High, Normal, Low }
enum recurrenceInterval { None, Daily, Weekly, Monthly, Yearly }

class Task {
  var id;
  String name;
  bool isDone;
  priorityLevel priority;
  bool recurring;
  int numberOfRecurrences;
  recurrenceInterval interval;
  String dueDate;

  static String table = 'Tasks';

  Task(
      {this.id,
      this.name,
      this.isDone = false,
      this.priority,
      this.recurring=false,
      this.numberOfRecurrences=0,
      this.interval=recurrenceInterval.None,
      this.dueDate=''});

  void toggleDone() {
    isDone = !isDone;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id': id,
      'name': name,
      'isDone': isDone ? 1 : 0,
      'priority': priority.toString(),
      'recurring': recurring ? 1 : 0,
      'numberOfRecurrences': numberOfRecurrences,
      'interval': interval.toString(),
      'dueDate': dueDate
    };
    return map;
  }

  static Task fromMap(Map<String, dynamic> map) {
    return Task(
        id: map['id'],
        name: map['name'],
        isDone: ((map['isDone'] == 1) ? true : false),
        priority: (map['priority'].toString().contains('High'))
            ? priorityLevel.High
            : (map['priority'].toString().contains('Low'))
                ? priorityLevel.Low
                : priorityLevel.Normal,
        recurring: ((map['recurring'] == 1) ? true : false),
        numberOfRecurrences: (int.parse(map['numberOfRecurrences'])),
        interval: (map['priority'].toString().contains('Daily'))
            ? recurrenceInterval.Daily
            : (map['interval'].toString().contains('Weekly'))
                ? recurrenceInterval.Weekly
                : (map['interval'].toString().contains('Monthly'))
                    ? recurrenceInterval.Monthly
                    : (map['interval'].toString().contains('Yearly'))
                        ? recurrenceInterval.Yearly
                        : recurrenceInterval.None,
        dueDate: map['dueDate']);
  }
}
