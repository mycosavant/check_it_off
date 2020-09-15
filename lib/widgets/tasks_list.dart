import 'package:check_it_off/helpers/db.dart';
import 'package:check_it_off/models/task.dart';
import 'package:flutter/material.dart';
import 'package:check_it_off/widgets/task_tile.dart';
import 'package:provider/Provider.dart' as Prov;
import 'package:check_it_off/models/task_data.dart';
import 'package:check_it_off/screens/edit_task_screen.dart';

class TasksList extends StatefulWidget {
  @override
  _TasksListState createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {

  void initState() {
    super.initState();
    // loadDB();
    refresh();
  }

  // void loadDB() async {
  //   await DB.init();
  //   WidgetsFlutterBinding.ensureInitialized();
  // }

  List<Task> _tasks = [];
  void refresh() async {
    var db = new DB();
    List<Task> _results = await db.query();
    _tasks = _results;
    Prov.Provider.of<TaskData>(context).tasks=_tasks;
    Prov.Provider.of<TaskData>(context).notify();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Prov.Consumer<TaskData>(
      builder: (context, taskData, child) {
        return ListView.builder(
          itemBuilder: (context, index) {
            final task = taskData.tasks[index];
            return TaskTile(
              taskTitle: task.name,
              isChecked: task.isDone,
              checkboxCallback: (checkboxState) async {
                taskData.updateTask(task);
                var db = new DB();
                dynamic result = await db.update(task);
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
                taskData.deleteTask(task);
                var db = new DB();
                dynamic result = db.delete(task);

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
