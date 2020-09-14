import 'package:uuid/uuid.dart';

enum priorityLevel { High, Normal, Low }

var uuid = Uuid();

class Task {
  var id;
  String name;
  bool isDone;
  priorityLevel priority;

  static String table = 'Tasks';

  Task({this.id=-1, this.name, this.isDone = false, this.priority}){
    if(this.id==-1) {
      this.id = Uuid().v4();
    }
  }

  void toggleDone() {
    isDone = !isDone;
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'isDone': isDone.toString(),
        'priority': priority.toString(),
      };

  Task.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        isDone = (json['isDone'] == 'true') ? true : false,
        priority = (json['priority'].toString().contains('High'))
            ? priorityLevel.High
            : (json['priority'].toString().contains('Low'))
                ? priorityLevel.Low
                : priorityLevel.Normal;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id': id,
      'name': name,
      'isDone': isDone ? 1 : 0,
      'priority': priority.toString(),
    };

    if (id != null) {
      map['id'] = id;
    }
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
