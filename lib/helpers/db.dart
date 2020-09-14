import 'dart:async';
import 'package:check_it_off/models/task.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

import 'package:uuid/uuid.dart';

class DB {
  static final DB _instance = new DB.internal();

  factory DB() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DB.internal();

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "main.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        'CREATE TABLE Task (id varchar(500) PRIMARY KEY NOT NULL, name STRING, isDone INT, priority STRING)');
  }

  Future<int> insert(Task task) async {
    var dbClient = await db;

    int res = await dbClient.insert("Task", task.toMap());
    return res;
  }

  Future<List<Task>> getTask() async {
    var dbClient = await db;

    List<Map> list = await dbClient.rawQuery('SELECT * FROM Task');
    List<Task> employees = new List();
    for (int i = 0; i < list.length; i++) {
      var task =
      new Task(name: list[i]["name"], isDone: list[i]["isDone"], priority: list[i]["priority"]);
      employees.add(task);
    }
    print(employees.length);
    return employees;
  }

  Future<int> delete(Task task) async {
    var dbClient = await db;

    int res =
    await dbClient.rawDelete('DELETE FROM Task WHERE id = ?', [task.id]);
    return res;
  }

  Future<bool> update(Task task) async {
    var dbClient = await db;

    int res =   await dbClient.update("Task", task.toMap(),
        where: "id = ?", whereArgs: <String>[task.id]);
    return res > 0 ? true : false;
  }

  Future <List <Task>> query() async{
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Task');
    List<Task> t = new List();
    for (int i = 0; i < list.length; i++) {
      var name = list[i]["name"];
      var isDone = list[i]["isDone"] == 1 ? true : false;
      var priority=((list[i]['priority'].toString().contains('High'))
          ? priorityLevel.High
          : (list[i]['priority'].toString().contains('Low'))
          ? priorityLevel.Low
          : priorityLevel.Normal);
      Task task = Task(name: name, isDone: isDone, priority: priority);
      t.add(task);
    }
    print(t.length);
    return t;
  }
}




// abstract class DB {
//
//   static Database _db;
//
//   static int get _version => 1;
//
//   static Future<void> init() async {
//     try {
//       Directory documentDirectory = await getApplicationDocumentsDirectory();
//       // db path
//       String path = join(documentDirectory.path, 'tasks.db');
//       // storing the database in ourDB variable
//       var ourDB = await openDatabase(path, version: 1, onCreate: onCreate);
//       return ourDB;
//     }
//     catch(ex) {
//       print(ex);
//     }
//   }
//
//   static void onCreate(Database db, int version) async =>
//       await db.execute('CREATE TABLE todo_items (id varchar(500) PRIMARY KEY NOT NULL, name STRING, isDone INT, priority STRING)');
//
//   static Future<List<Map<String, dynamic>>> query(String table) async => _db.query(table);
//
//   static Future<int> insert(String table,Task task) async =>
//       await _db.insert(table, task.toMap());
//
//   static Future<int> update(String table,Task task) async =>
//       await _db.update(table, task.toMap(), where: 'id = ?', whereArgs: [task.id]);
//
//   static Future<int> delete(String table,Task task) async =>
//       await _db.delete(table, where: 'id = ?', whereArgs: [task.id]);
// }