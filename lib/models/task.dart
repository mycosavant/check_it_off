
enum priorityLevel {
  High, Normal, Low
}

class Task {
  String name;
  bool isDone;
  priorityLevel priority;

  Task({this.name, this.isDone = false, this.priority});

  void toggleDone() {
    isDone = !isDone;
  }

}
