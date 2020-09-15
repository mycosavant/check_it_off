import 'package:check_it_off/helpers/db.dart';
import 'package:uuid/uuid.dart';

enum priorityLevel { High, Normal, Low }

class Task {
  var id;
  String name;
  bool isDone;
  priorityLevel priority;

  static String table = 'Tasks';

  Task({this.id, this.name, this.isDone = false, this.priority});

  void toggleDone() {
    isDone = !isDone;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id': id,
      'name': name,
      'isDone': isDone ? 1 : 0,
      'priority': priority.toString(),
    };

    // if (id != null) {
    //   map['id'] = id;
    // }
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
                : priorityLevel.Normal);
  }
}
