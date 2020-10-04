import 'dart:async';
import 'package:check_it_off/models/task.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

class DB {
  int version = 2;
  static final DB _instance = new DB.internal();

  factory DB() => _instance;

  static Database _db;

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
          alter table Task add column interval String default 'None';
        ''');
    await db.execute('''
          alter table Task add column dueDate String default '';
        ''');
  }

  Future<int> insert(Task task) async {
    var dbClient = await db;

    int res = await dbClient.insert("Task", task.toMap());
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
                      : (list[i]['interval'].toString().contains('Yearly'))
                          ? recurrenceInterval.Yearly
                          : recurrenceInterval.None,
          dueDate: list[i]['dueDate']);
      tasks.add(task);
    }
    print(tasks.length);
    return tasks;
  }

  Future<int> delete(Task task) async {
    var dbClient = await db;

    int res =
        await dbClient.rawDelete('DELETE FROM Task WHERE id = ?', [task.id]);
    return res;
  }

  Future<bool> update(Task task) async {
    var dbClient = await db;

    int res = await dbClient.update("Task", task.toMap(),
        where: "id = ?", whereArgs: <int>[task.id]);
    return res > 0 ? true : false;
  }

  Future<List<Task>> query([order = 'normal']) async {
    if (order == 'current') {
      order = sort;
    }
    sort = order;
    var dbClient = await db;
    String sql = 'SELECT * FROM Task';
    if (order == 'asc') {
      sql = '$sql ORDER BY priority';
    } else if (order == 'dsc') {
      sql = '$sql ORDER BY priority DESC';
    } else if (order == 'aasc') {
      sql = '$sql ORDER BY name';
    } else if (order == 'adsc') {
      sql = '$sql ORDER BY name DESC';
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
      var numberOfRecurrence = (int.parse(list[i]['numberOfRecurrences']));
      var interval = (list[i]['priority'].toString().contains('Daily'))
          ? recurrenceInterval.Daily
          : (list[i]['interval'].toString().contains('Weekly'))
              ? recurrenceInterval.Weekly
              : (list[i]['interval'].toString().contains('Monthly'))
                  ? recurrenceInterval.Monthly
                  : (list[i]['interval'].toString().contains('Yearly'))
                      ? recurrenceInterval.Yearly
                      : recurrenceInterval.None;
      var dueDate = list[i]['dueDate'];
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
    print(t.length);
    return t;
  }
}
