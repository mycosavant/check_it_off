import 'package:flutter/material.dart';
import 'package:check_it_off/widgets/task_tile.dart';
import 'package:provider/provider.dart';
import 'package:check_it_off/models/task_data.dart';
import 'package:check_it_off/screens/edit_task_screen.dart';

class TasksList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskData>(
      builder: (context, taskData, child) {
        return ListView.builder(
          itemBuilder: (context, index) {
            final task = taskData.tasks[index];
            return TaskTile(
              taskTitle: task.name,
              isChecked: task.isDone,
              checkboxCallback: (checkboxState) {
                taskData.updateTask(task);
              },
              editCallback: () { showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => SingleChildScrollView(
                      child:Container(
                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: EditTaskScreen(task, index),
                      )
                  )
              );},
              deleteCallback: () {
                taskData.deleteTask(task);
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
