import 'package:check_it_off/models/task.dart';
import 'package:check_it_off/widgets/task_popup.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
  final bool isChecked;
  final Task task;
  final Function checkboxCallback;
  final Function editCallback;
  final Function deleteCallback;
  final priorityLevel priority;
  final Function addCallback;

  TaskTile({
    this.isChecked,
    this.task,
    this.checkboxCallback,
    this.editCallback,
    this.deleteCallback,
    this.priority,
    this.addCallback,
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
    DateFormat formatter = DateFormat('MM/dd/yyyy');
    var finaldate = formatter.format(DateTime.parse(task.dueDate));
    TaskPopup taskPopup = new TaskPopup(
        delete: deleteCallback, edit: editCallback, add: addCallback);
    return ListTile(
      title: Text(
        '${task.name} \n${finaldate}',
        style: TextStyle(
            fontSize: 20,
            color: (task.dueDate != null
                ? (task.dueDate != ''
                    ? (DateTime.parse(task.dueDate)
                                .difference(DateTime.now()) <=
                            Duration(days: 0)
                        ? Colors.red
                        : Colors.lightBlueAccent)
                    : Colors.lightBlueAccent)
                : Colors.lightBlueAccent),
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
              onPressed: () {},
            ),
          ],
        ),
      ),
      trailing: Container(
        child: Wrap(
          spacing: 12,
          children: [taskPopup],
        ),
      ),
    );
  }
}
