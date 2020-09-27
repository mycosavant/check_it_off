import 'package:check_it_off/models/task.dart';
import 'package:check_it_off/widgets/task_popup.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
  final bool isChecked;
  final String taskTitle;
  final Function checkboxCallback;
  final Function editCallback;
  final Function deleteCallback;
  final priorityLevel priority;

  TaskTile({
    this.isChecked,
    this.taskTitle,
    this.checkboxCallback,
    this.editCallback,
    this.deleteCallback,
    this.priority,
  });

  Icon getPriorityIcon() {
    if (priority == priorityLevel.High) {
      return new Icon(CupertinoIcons.up_arrow);
    } else if (priority == priorityLevel.Low) {
      return new Icon(CupertinoIcons.down_arrow);
    }
    return new Icon(Icons.label);
  }

  @override
  Widget build(BuildContext context) {
    TaskPopup taskPopup = new TaskPopup(delete: deleteCallback, edit: editCallback);
    return ListTile(
      title: Text(
        taskTitle,
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            decoration: isChecked ? TextDecoration.lineThrough : null),
      ),
      leading: Container(
        child: Wrap(
          spacing: 12,
          children: [
            Checkbox(
              activeColor: Colors.lightBlueAccent,
              value: isChecked,
              onChanged: checkboxCallback,
            ),
            IconButton(
              icon: getPriorityIcon(),
              onPressed: (){},
            ),
          ],
        ),
      ),
      trailing: Container(
        child: Wrap(
          spacing: 12,
          children: [
          taskPopup
          ],
        ),
      ),
    );
  }
}
