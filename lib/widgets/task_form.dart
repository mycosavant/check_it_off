import 'dart:io' show Platform;
import 'package:check_it_off/helpers/db.dart';
import 'package:check_it_off/models/theme_notifier.dart';
import 'package:check_it_off/widgets/toggle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:check_it_off/models/task.dart';
import 'package:flutter/scheduler.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/Provider.dart';
import 'package:check_it_off/models/task_data.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:intl/intl.dart';

String taskTitle;

class TaskForm extends StatefulWidget {
  final priority;
  final recurring;
  final interval;
  final addToCalendar;
  final numberOfRecurrences;
  final dueDate;
  final mode;
  final task;
  final index;

  TaskForm({
    this.priority,
    this.dueDate,
    this.addToCalendar,
    this.numberOfRecurrences,
    this.interval,
    this.recurring,
    this.mode,
    this.task,
    this.index,
  });
  @override
  _TaskFormState createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  String _selectedPriority;
  String _selectedRecurring;
  String _selectedInterval;
  String _selectedAddToCalendar;
  int _selectedNumberOfRecurrences;
  var initialDate;

  void initState() {
    super.initState();
    taskTitle = widget.task != null ? widget.task.name : '';
    _selectedPriority =
        widget.priority.toString().replaceAll('priorityLevel.', '');
    _selectedRecurring = widget.recurring;
    _selectedInterval =
        widget.interval.toString().replaceAll('recurrenceInterval.', '');
    _selectedAddToCalendar = widget.addToCalendar;
    _selectedNumberOfRecurrences = widget.numberOfRecurrences;
    initialDate = (widget.dueDate != null
        ? (widget.dueDate != ''
            ? DateTime.parse(widget.dueDate)
            : DateTime.now())
        : DateTime.now());
    DateFormat formatter = DateFormat('MM/dd/yyyy');
    finaldate = widget.mode == 'add'
        ? ''
        : widget.dueDate == ''
            ? ''
            : formatter.format(initialDate);
  }

  bool _showRecurranceOptions = false;
  var finaldate;
  String _setDate;

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
    'Daily',
    'Weekly',
    'Monthly',
    'None'
  ];

  NumberPicker integerNumberPicker;

  void callDatePicker() async {
    var order = await getDate();
    setState(() {
      if (order != null) {
        DateFormat formatter = DateFormat('MM/dd/yyyy');
        finaldate = formatter.format(order);
        initialDate = order;
        _setDate = order.toString();
      }
    });
  }

  Future<DateTime> getDate() {
    // Imagine that this function is
    // more complex and slow.
    return showDatePicker(
      context: context,
      initialDate: initialDate,
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

  Future _showIntDialog() async {
    await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return new NumberPickerDialog.integer(
          minValue: 0,
          maxValue: 25,
          step: 1,
          initialIntegerValue: _selectedNumberOfRecurrences,
        );
      },
    ).then((num value) {
      if (value != null) {
        setState(() => _selectedNumberOfRecurrences = value);
        integerNumberPicker.animateInt(value);
      }
    });
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
              widget.mode.toString().contains('add') ? 'Add Task' : 'Edit Task',
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
                  initialValue: widget.mode == 'add' ? '' : widget.task.name,
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
                    taskTitle = newText;
                  },
                ),
              ],
            ),
            Toggle("Priority", priorityList, (index) {
              _selectedPriority = priorityList[index];
            }, priorityList.indexOf(_selectedPriority)),

            Toggle("Recurring", recurringIntervalList, (index) {
              setState(() {
                _selectedInterval = recurringIntervalList[index];
                _showRecurranceOptions =
                    _selectedInterval.contains('None') ? false : true;
              });
            }, recurringIntervalList.indexOf(_selectedInterval)),
            _showRecurranceOptions
                ? Container(
                    // height: 150.0,
                    alignment: Alignment.center,
                    // color: Colors.lightBlueAccent,
                    // child: Platform.isIOS ? iOSPicker() : androidDropdown(),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Column(
                        children: [
                          Text('Frequency Interval (Every x Days/Weeks/Months)',
                              style: TextStyle(fontSize: 25.0)),
                          new FlatButton(
                            color: Colors.lightBlueAccent,
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(15.0)),
                            onPressed: () => _showIntDialog(),
                            child: new Text(
                              _selectedNumberOfRecurrences.toString(),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(),
            new FlatButton(
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(15.0)),
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
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(15.0)),
              child: Text(
                widget.mode.toString().contains('add')
                    ? 'Add Task'
                    : 'Edit Task',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              color: Colors.lightBlueAccent,
              onPressed: widget.mode.toString().contains('add')
                  ? () async {
                      Task t;
                      t = Provider.of<TaskData>(context, listen: false).addTask(
                          newTaskTitle: taskTitle,
                          priority: _selectedPriority,
                          interval: _selectedInterval,
                          dueDate: _setDate,
                          numberOfRecurrences: _selectedNumberOfRecurrences,
                          addToCalendar: (_selectedAddToCalendar.contains('Yes')
                              ? true
                              : false));
                      var db = new DB();
                      dynamic result = await db.insert(t);

                      // await DB.insert(t);
                      Navigator.pop(context);
                    }
                  : () async {
                      Provider.of<TaskData>(context, listen: false).editTask(
                        theTaskTitle:
                            taskTitle == null ? widget.task.name : taskTitle,
                        index: widget.index,
                        selectedPriority: _selectedPriority,
                        interval: _selectedInterval,
                        numberOfRecurrences: _selectedNumberOfRecurrences,
                        dueDate: _setDate,
                        addToCalendar:
                            _selectedAddToCalendar == 'Yes' ? true : false,
                      );
                      var db = new DB();
                      widget.task.id = widget.index;
                      dynamic result = await db.update(widget.task);

                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
            ),
          ],
        ),
      ),
    );
  }
}
