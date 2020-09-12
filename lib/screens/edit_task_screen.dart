import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:check_it_off/models/task.dart';
import 'package:provider/provider.dart';
import 'package:check_it_off/models/task_data.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;
  final int index;
  EditTaskScreen(this.task, this.index);

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState(task, index);
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final Task task;
  final int index;
  String _selectedPriority;
  _EditTaskScreenState(this.task, this.index) {
    _selectedPriority = task.priority.toString();
  }

  List<String> priorityList = ['High', 'Normal', 'Low'];

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String priority in priorityList) {
      var newItem = DropdownMenuItem(
        child: Text(
          priority,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        value: priority,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      dropdownColor: Colors.lightBlueAccent,
      value: _selectedPriority,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          _selectedPriority = value;
        });
      },
    );
  }

  int getIndex() {
    return _selectedPriority.toString().contains('.')? priorityList.indexOf(_selectedPriority.toString().split(".")[1]): priorityList.indexOf(_selectedPriority.toString());
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String priority in priorityList) {
      pickerItems.add(
        Text(
          priority,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      );
    }

    return CupertinoPicker(
      scrollController: FixedExtentScrollController(initialItem: getIndex()),
      backgroundColor: Colors.lightBlueAccent,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          _selectedPriority = priorityList[selectedIndex];
        });
      },
      children: pickerItems,
    );
  }


  @override
  Widget build(BuildContext context) {
    String myTaskTitle;

    return Container(
      color: Color(0xff757575),
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Edit Task',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.lightBlueAccent,
              ),
            ),
            TextFormField(
              initialValue: widget.task.name,
              autofocus: true,
              textAlign: TextAlign.center,
              onChanged: (editedText) {
                myTaskTitle = editedText;
              },
            ),
            Container(
              height: 150.0,
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 30.0),
              color: Colors.lightBlueAccent,
              child: Platform.isIOS ? iOSPicker() : androidDropdown(),
            ),
            FlatButton(
              child: Text(
                'Update',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              color: Colors.lightBlueAccent,
              onPressed: () {
                Provider.of<TaskData>(context)
                    .editTask(myTaskTitle==null ?  widget.task.name :myTaskTitle, widget.index, _selectedPriority);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
