import 'dart:async';
import 'package:check_it_off/helpers/widget_helper.dart';
import 'package:check_it_off/models/task.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io' as io;
import 'package:check_it_off/helpers/notification_helper.dart';
import 'package:intl/intl.dart';

import '../main.dart';

class DB {
  int version = 2;
  static final DB _instance = new DB.internal();

  factory DB() => _instance;

  static Database _db;

  bool notificationsOn;

  String sort = 'normal';

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DB.internal();

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "main.db");
    var theDb = await openDatabase(path,
        version: version, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute('''CREATE TABLE Task 
            (id INTEGER UNIQUE PRIMARY KEY NOT NULL, 
            name STRING, 
            isDone INT, 
            priority STRING,
            recurring INT,
            numberOfRecurrences INT,
            interval STRING,
            dueDate STRING
            )
            ''');
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // When creating the db, create the table
    await db.execute('''
          alter table Task add column recurring integer default 0;
        ''');
    await db.execute('''
          alter table Task add column numberOfRecurrences integer default 0;
        ''');
    await db.execute('''
          alter table Task add column interval String default '';
        ''');
    await db.execute('''
          alter table Task add column dueDate String default '';
        ''');
  }

  Future<int> insert(Task task) async {
    var dbClient = await db;
    notificationCheck();

    int res = await dbClient.insert("Task", task.toMap());
    if(notificationsOn) {
      turnOffNotification(flutterLocalNotificationsPlugin);
      turnOnNotfications(true);
    }
    else{
      turnOffNotification(flutterLocalNotificationsPlugin);
    }
    widgetList();
    return res;
  }

  Future<List<Task>> getTask() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Task');
    List<Task> tasks = new List();
    for (int i = 0; i < list.length; i++) {
      var task = new Task(
          id: list[i]["id"],
          name: list[i]["name"],
          isDone: list[i]["isDone"],
          priority: list[i]["priority"],
          recurring: ((list[i]['recurring'] == 1) ? true : false),
          numberOfRecurrences: (int.parse(list[i]['numberOfRecurrences'])),
          interval: (list[i]['priority'].toString().contains('Daily'))
              ? recurrenceInterval.Daily
              : (list[i]['interval'].toString().contains('Weekly'))
                  ? recurrenceInterval.Weekly
                  : (list[i]['interval'].toString().contains('Monthly'))
                      ? recurrenceInterval.Monthly
                      : recurrenceInterval.None,
          dueDate: (list[i]['dueDate']) == ""
              ? DateTime.now().toString()
              : list[i]['dueDate']);
      tasks.add(task);
      if (list[i]['dueDate'] == "") {
        update(task);
      }
    }
    // print(tasks.length);
    return tasks;
  }

  Future<int> delete(Task task) async {
    var dbClient = await db;

    notificationCheck();

    int res =
        await dbClient.rawDelete('DELETE FROM Task WHERE id = ?', [task.id]);
    if(notificationsOn) {
      turnOffNotification(flutterLocalNotificationsPlugin);
      turnOnNotfications(true);
    }
    else{
      turnOffNotification(flutterLocalNotificationsPlugin);
    }
    widgetList();
    return res;
  }

  Future<bool> update(Task task) async {
    var dbClient = await db;

    notificationCheck();

    var r = await dbClient.rawQuery('SELECT * from Task');
    var res = await dbClient
        .update("Task", task.toMap(), where: "id = ?", whereArgs: [task.id]);

    if(notificationsOn) {
      turnOffNotification(flutterLocalNotificationsPlugin);
      turnOnNotfications(true);
    }
    else{
      turnOffNotification(flutterLocalNotificationsPlugin);
    }
    widgetList();
    // var sql =
    //     'UPDATE Task SET name=\'${task.name}\', isDone=${task.isDone ? 1 : 0}, priority=\'${task.priority.toString()}\',recurring=${task.recurring ? 1 : 0}, interval=\'${task.interval.toString()}\', dueDate=\'${task.dueDate}\' WHERE id = ${task.id}';
    // var res = await dbClient.rawQuery(sql);
    return res > 0 ? true : false;
    // delete(task);
    // io.sleep(Duration(seconds: 5));
    // insert(task);
  }

  Future<List<Task>> query(bool archived, [order = 'normal']) async {
    if (order == 'current') {
      order = sort;
    }
    sort = order;
    var dbClient = await db;
    String sql = 'SELECT * FROM Task';
    if (!archived) {
      sql = '$sql WHERE isDone=0 ';
    }
    if (order == 'asc') {
      sql = '$sql ORDER BY priority';
    } else if (order == 'dsc') {
      sql = '$sql ORDER BY priority DESC';
    } else if (order == 'aasc') {
      sql = '$sql ORDER BY name';
    } else if (order == 'adsc') {
      sql = '$sql ORDER BY name DESC';
    } else if (order == 'dueasc') {
      sql = '$sql ORDER BY dueDate';
    } else if (order == 'duedsc') {
      sql = '$sql ORDER BY dueDate DESC';
    } else if (order == 'today') {
      sql = '$sql ORDER BY dueDate';
    }
    List<Map> list = await dbClient.rawQuery(sql);
    List<Task> t = new List();
    for (int i = 0; i < list.length; i++) {
      var id = list[i]["id"];
      var name = list[i]["name"].toString();
      var isDone = list[i]["isDone"] == 1 ? true : false;
      var priority = ((list[i]['priority'].toString().contains('High'))
          ? priorityLevel.High
          : (list[i]['priority'].toString().contains('Low'))
              ? priorityLevel.Low
              : priorityLevel.Normal);

      var recurring = ((list[i]['recurring'] == 1) ? true : false);
      var numberOfRecurrence = (list[i]['numberOfRecurrences']);
      var interval = (list[i]['priority'].toString().contains('Daily'))
          ? recurrenceInterval.Daily
          : (list[i]['interval'].toString().contains('Weekly'))
              ? recurrenceInterval.Weekly
              : (list[i]['interval'].toString().contains('Monthly'))
                  ? recurrenceInterval.Monthly
                  : recurrenceInterval.None;
      var dueDate = list[i]['dueDate'] == ""
          ? DateTime.now().toString()
          : list[i]['dueDate'];

      Task task = Task(
          id: id,
          name: name,
          isDone: isDone,
          priority: priority,
          recurring: recurring,
          numberOfRecurrences: numberOfRecurrence,
          dueDate: dueDate,
          interval: interval);
      if (order != 'today') {
        t.add(task);
      } else {
        var taskDate = DateTime.parse(task.dueDate);
        var today = DateTime.now();
        var tomorrow = DateTime.now().add(Duration(days: 1));
        // print(today);
        if (today.difference(taskDate).inDays >= 0 &&
            task.dueDate.split(' ')[0] != tomorrow.toString().split(' ')[0] &&
            !task.isDone) {
          // print(
          //     '${task.name} ${task.dueDate} ${today.difference(taskDate).inDays}');
          t.add(task);
        }
      }

      if (list[i]['dueDate'] == "") {
        update(task);
      }
    }
    widgetList();
    // print(t.length);
    return t;
  }

  Future<int> dueTodayCount() async {
    var dbClient = await db;
    String sql = 'SELECT * FROM Task';

    sql = '$sql ORDER BY dueDate';

    List<Map> list = await dbClient.rawQuery(sql);
    // print(t.length);
    return list.length;
  }

  Future<List<Task>> notificationList() async {
    var dbClient = await db;
    String sql = 'SELECT * FROM Task';
    sql = '$sql WHERE isDone=0 ';
    List<Map> list = await dbClient.rawQuery(sql);
    List<Task> t = new List();
    for (int i = 0; i < list.length; i++) {
      var id = list[i]["id"];
      var name = list[i]["name"].toString();
      var isDone = list[i]["isDone"] == 1 ? true : false;
      var priority = ((list[i]['priority'].toString().contains('High'))
          ? priorityLevel.High
          : (list[i]['priority'].toString().contains('Low'))
              ? priorityLevel.Low
              : priorityLevel.Normal);

      var recurring = ((list[i]['recurring'] == 1) ? true : false);
      var numberOfRecurrence = (list[i]['numberOfRecurrences']);
      var interval = (list[i]['priority'].toString().contains('Daily'))
          ? recurrenceInterval.Daily
          : (list[i]['interval'].toString().contains('Weekly'))
              ? recurrenceInterval.Weekly
              : (list[i]['interval'].toString().contains('Monthly'))
                  ? recurrenceInterval.Monthly
                  : recurrenceInterval.None;
      var dueDate = list[i]['dueDate'] == ""
          ? DateTime.now().toString()
          : list[i]['dueDate'];

      Task task = Task(
          id: id,
          name: name,
          isDone: isDone,
          priority: priority,
          recurring: recurring,
          numberOfRecurrences: numberOfRecurrence,
          dueDate: dueDate,
          interval: interval);

      t.add(task);
    }
    // print(t.length);
    return t;
  }

  void widgetList() async {
    var dbClient = await db;
    String sql = 'SELECT * FROM Task';
    sql = '$sql WHERE isDone=0 order by dueDate';
    List<Map> list = await dbClient.rawQuery(sql);
    List<Task> t = new List();
    String widgetString = "";
    for (int i = 0; i < list.length; i++) {
      var name = list[i]["name"].toString();
      var dueDate = list[i]['dueDate'] == ""
          ? DateTime.now().toString()
          : list[i]['dueDate'];
      DateFormat formatter = DateFormat('MM/dd/yyyy');
      dueDate = formatter.format(DateTime.parse(dueDate));
      if(widgetString == "") {
        widgetString = "$name\t\t$dueDate";
      }
      else{
        widgetString = "$widgetString\n$name\t\t$dueDate";
      }
    }
    FlutterWidgetData fwd = FlutterWidgetData(widgetString);
    fwd.setWidgetData();
  }

  void notificationCheck() async {
    final prefs = await SharedPreferences.getInstance();
    notificationsOn = prefs.getBool('notify');
    if (notificationsOn == null) {
      prefs.setBool("notify", false);
      notificationsOn = false;
    }
  }
}
