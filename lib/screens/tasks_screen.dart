import 'package:check_it_off/helpers/db.dart';
import 'package:check_it_off/models/task.dart';
import 'package:check_it_off/models/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'package:check_it_off/widgets/tasks_list.dart';
import 'package:check_it_off/screens/add_task_screen.dart';
import 'package:provider/Provider.dart' as Prov;
import 'package:check_it_off/models/task_data.dart';
import 'package:provider/provider.dart';

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.lightBlueAccent,
      floatingActionButton: FloatingActionButton(
          // backgroundColor: Colors.lightBlueAccent,
          child: Icon(Icons.add),
          onPressed: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => SingleChildScrollView(
                        child: Container(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: AddTaskScreen(),
                    )));
          }),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                top: 25.0, left: 30.0, right: 30.0, bottom: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                SizedBox(
                  width: double.infinity,
                ),
                Text(
                  '${Prov.Provider.of<TaskData>(context).taskCount} Tasks',
                  style: TextStyle(
                    // color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                // color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: TasksList(),
            ),
          ),
        ],
      ),
      appBar: AppBar(
        title:  Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CircleAvatar(
                child: Icon(
                  Icons.check_circle,
                  size: 35.0,
                  color: Colors.white,
                ),
                backgroundColor: Provider.of<ThemeNotifier>(context)
                    .getCurrentTheme()
                    .contains('dark')
                    ? Colors.white24
                    : Colors.blueGrey,
                radius: 20.0,
              ),
              Text(
                ' it Off!',
                style: TextStyle(
                  // color: Colors.white,
                  fontSize: 35.0,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ],
      ),),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Task Order',
              style: TextStyle(
                fontSize: 40.0
              ),
              ),
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
              ),
            ),
            ListTile(
              title: Text('Order Entered'),
              onTap: () async {
                List<Task> _tasks = [];
                var db = new DB();
                List<Task> _results = await db.query('normal');
                _tasks = _results;
                Prov.Provider.of<TaskData>(context).tasks = _tasks;
                setState(() {});
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Alphabetic'),
              onTap: () async {
                List<Task> _tasks = [];
                var db = new DB();
                List<Task> _results = await db.query('aasc');
                _tasks = _results;
                Prov.Provider.of<TaskData>(context).tasks = _tasks;
                setState(() {});
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Reverse Alphabetic'),
              onTap: () async {
                List<Task> _tasks = [];
                var db = new DB();
                List<Task> _results = await db.query('adsc');
                _tasks = _results;
                Prov.Provider.of<TaskData>(context).tasks = _tasks;
                setState(() {});
                Navigator.pop(context);
              },
            ),

            ListTile(
              title: Text('Group By Priority'),
              onTap: () async {
                List<Task> _tasks = [];
                var db = new DB();
                List<Task> _results = await db.query('asc');
                _tasks = _results;
                Prov.Provider.of<TaskData>(context).tasks = _tasks;
                setState(() {});
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
