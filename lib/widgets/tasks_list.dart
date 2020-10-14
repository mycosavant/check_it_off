import 'package:add_to_calendar/add_to_calendar.dart';
import 'package:check_it_off/helpers/db.dart';
import 'package:check_it_off/models/task.dart';
import 'package:flutter/material.dart';
import 'package:check_it_off/widgets/task_tile.dart';
import 'package:provider/Provider.dart';
import 'package:check_it_off/models/task_data.dart';
import 'package:check_it_off/screens/edit_task_screen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class TasksList extends StatefulWidget {
  final notifyRefresh;
  final tasks;
  TasksList({this.notifyRefresh, this.tasks});
  @override
  _TasksListState createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  List<Task> _tasks;
  void initState() {
    super.initState();
    // loadDB();
    // refresh(widget.order);
    _tasks = widget.tasks;
  }

  // void loadDB() async {
  //   await DB.init();
  //   WidgetsFlutterBinding.ensureInitialized();
  // }


  // void refresh([order = 'normal']) async {
  //   var db = new DB();
  //   List<Task> _results = await db.query('system');
  //   _tasks = _results;
  //   Provider.of<TaskData>(context, listen: false).tasks = _tasks;
  //   Provider.of<TaskData>(context, listen: false).notify();
  //   setState(() {});
  // }

  String addMonth(String date) {
    return new DateTime(DateTime.parse(date).year,
            DateTime.parse(date).month + 1, DateTime.parse(date).day)
        .toString();
  }

  String addWeek(String date) {
    return new DateTime(DateTime.parse(date).year, DateTime.parse(date).month,
            DateTime.parse(date).day + 7)
        .toString();
  }

  String addDay(String date) {
    return new DateTime(DateTime.parse(date).year, DateTime.parse(date).month,
            DateTime.parse(date).day + 1)
        .toString();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskData>(
      builder: (context, taskData, child) {
        return ListView.builder(
          itemBuilder: (context, index) {
            final task = taskData.tasks[index];
            return TaskTile(
              task: task,
              isChecked: task.isDone,
              checkboxCallback: (checkboxState) async {
                taskData.updateTask(task);
                task.isDone = task.isDone ? true : false;
                var db = new DB();
                dynamic result = await db.update(task);
                if (task.recurring && task.isDone) {
                  String recurDate;
                  recurDate =
                      task.interval.toString().toLowerCase().contains('daily')
                          ? addDay(task.dueDate)
                          : task.interval
                                  .toString()
                                  .toLowerCase()
                                  .contains('weekly')
                              ? addWeek(task.dueDate)
                              : task.interval
                                      .toString()
                                      .toLowerCase()
                                      .contains('monthly')
                                  ? addMonth(task.dueDate)
                                  : null;
                  Task recurringTask = Task(
                    name: task.name,
                    priority: task.priority,
                    isDone: false,
                    interval: task.interval,
                    numberOfRecurrences: task.numberOfRecurrences,
                    recurring: task.recurring,
                    dueDate: recurDate.toString(),
                  );
                  Task t;
                  t = Provider.of<TaskData>(context, listen: false).addTask(
                      newTaskTitle: recurringTask.name,
                      priority: recurringTask.priority.toString(),
                      interval: recurringTask.interval.toString(),
                      dueDate: recurringTask.dueDate,
                      numberOfRecurrences: recurringTask.numberOfRecurrences,
                      addToCalendar: false);
                  var db = new DB();
                  dynamic result = await db.insert(t);
                }
                widget.notifyRefresh(true);
              },
              editCallback: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => SingleChildScrollView(
                            child: Container(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: EditTaskScreen(task, index),
                        )));
              },
              deleteCallback: () {
                Alert(
                  context: context,
                  type: AlertType.warning,
                  title: "Confirm Delete",
                  desc: "Are you sure you want to delete ${task.name}?  This cannot be undone.",
                  buttons: [
                    DialogButton(
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () => Navigator.pop(context),
                      color: Color.fromRGBO(0, 179, 134, 1.0),
                    ),
                    DialogButton(
                      child: Text(
                        "Continue",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () async {
                        taskData.deleteTask(task);
                        var db = new DB();
                        dynamic result = db.delete(task);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      gradient: LinearGradient(colors: [
                        Color.fromRGBO(116, 116, 191, 1.0),
                        Color.fromRGBO(52, 138, 199, 1.0)
                      ]),
                    )
                  ],
                ).show();
              },
              addCallback: () {
                AddToCalendar.addToCalendar(
                  title: task.name,
                  startTime: (task.dueDate == null
                      ? DateTime.now()
                      : DateTime.parse(task.dueDate)),
                  endTime: null,
                  location: '',
                  description: task.name,
                  isAllDay: true,
                  frequency: task.numberOfRecurrences == 0
                      ? null
                      : task.numberOfRecurrences,
                  frequencyType: task.interval.toString().contains('Weekly')
                      ? FrequencyType.WEEKLY
                      : task.interval.toString().contains('Daily')
                          ? FrequencyType.DAILY
                          : task.interval.toString().contains('Monthly')
                              ? FrequencyType.MONTHLY
                              : null,
                );
              },
              priority: task.priority,
            );
          },
          itemCount: taskData.taskCount,
        );
      },
    );
  }
}
