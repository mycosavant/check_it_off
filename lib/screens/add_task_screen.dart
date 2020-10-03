import 'dart:io' show Platform;
import 'package:check_it_off/helpers/db.dart';
import 'package:check_it_off/models/theme_notifier.dart';
import 'package:check_it_off/widgets/toggle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:check_it_off/models/task.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/Provider.dart';
import 'package:check_it_off/models/task_data.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:intl/intl.dart';

String newTaskTitle;

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  void initState() {
    super.initState();
  }

  bool isDarkMode() {
    var brightness = SchedulerBinding.instance.window.platformBrightness;
    bool darkModeOn = brightness == Brightness.dark;
    return darkModeOn;
  }

  List<Task> _tasks = [];
  void refresh() async {
    var db = new DB();
    List<Task> _results = await db.query('system');
    _tasks = _results;
    Provider.of<TaskData>(context, listen: false).tasks = _tasks;
    setState(() {});
  }

  List<String> priorityList = ['High', 'Normal', 'Low'];
  List<String> yesNoList = ['Yes', 'No'];
  List<String> recurringIntervalList = [
    'None',
    'Daily',
    'Weekly',
    'Monthly',
    'Yearly'
  ];

  String _selectedPriority = 'Normal';
  String _selectedRecurring = 'No';
  String _selectedInterval = 'None';
  String _selectedAddToCalendar = 'No';

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
    return _selectedPriority.toString().contains('.')
        ? priorityList.indexOf(_selectedPriority.toString().split(".")[1])
        : priorityList.indexOf(_selectedPriority.toString());
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

  var finaldate;

  void callDatePicker() async {
    var order = await getDate();
    setState(() {
      DateFormat formatter = DateFormat('dd/MM/yyyy');
      finaldate = formatter.format(order);
    });
  }

  Future<DateTime> getDate() {
    // Imagine that this function is
    // more complex and slow.
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: Provider.of<ThemeNotifier>(context)
                  .getCurrentTheme()
                  .contains('dark')
              ? ThemeData.dark()
              : ThemeData.light(),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isDarkMode() ? Color(0xFF212121) : Color(0xff757575),
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: isDarkMode() ? Colors.black : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Add Task',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0,
                // color: Colors.lightBlueAccent,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
            ),
            Column(
              children: [
                Text(
                  'Name',
                  style: TextStyle(fontSize: 25.0),
                ),
                TextFormField(
                  style:
                      TextStyle(fontSize: 20.0, color: Colors.lightBlueAccent),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.all(12.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  autofocus: true,
                  textAlign: TextAlign.center,
                  onChanged: (newText) {
                    newTaskTitle = newText;
                  },
                ),
              ],
            ),
            Toggle("Priority", priorityList, (index) {
              _selectedPriority = priorityList[index];
            }, priorityList.indexOf('Normal')),
            Toggle("Recurring", recurringIntervalList, (index) {
              _selectedInterval = recurringIntervalList[index];
            }, recurringIntervalList.indexOf('None')),
            new FlatButton(
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0)),
              onPressed: callDatePicker,
              color: Colors.lightBlueAccent,
              child:
                  new Text('Due Date', style: TextStyle(color: Colors.white)),
            ),
            Center(
              child: Container(
                // decoration: BoxDecoration(color: Colors.grey[200]),
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: finaldate == null
                    ? Text(
                  "",
                  textScaleFactor: 2.0,
                )
                    : Text(
                  "$finaldate",
                  textScaleFactor: 2.0,
                ),
              ),
            ),
            Toggle("Add To Calendar", yesNoList, (index) {
              _selectedAddToCalendar = yesNoList[index];
            }, yesNoList.indexOf('No')),
            FlatButton(
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0)),
              child: Text(
                'Add',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              color: Colors.lightBlueAccent,
              onPressed: () async {
                Task t;
                t = Provider.of<TaskData>(context, listen: false)
                    .addTask(newTaskTitle, _selectedPriority);
                var db = new DB();
                dynamic result = await db.insert(t);

                // await DB.insert(t);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
