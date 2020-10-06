import 'package:check_it_off/helpers/db.dart';
import 'package:check_it_off/helpers/onboarding.dart';
import 'package:check_it_off/models/task.dart';
import 'package:check_it_off/models/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'package:check_it_off/widgets/tasks_list.dart';
import 'package:check_it_off/screens/add_task_screen.dart';
import 'package:check_it_off/models/task_data.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  void setOrder(String order) async {
    List<Task> _tasks = [];
    var db = new DB();
    List<Task> _results = await db.query(order);
    _tasks = _results;
    Provider.of<TaskData>(context, listen: false).tasks = _tasks;
    setState(() {});
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('order', order);
  }

  void onboarded() async {
    final prefs = await SharedPreferences.getInstance();
    bool ran = prefs.getBool('onboarded');
    prefs.setBool("onboarded", true);
    try {
      if (!ran) {
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (context) => new Onboarding()));
      }
    } catch (e) {
      print('Onboarding has not run.');
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new Onboarding()));
    }
  }

  void getOrder() async {
    final prefs = await SharedPreferences.getInstance();
    String order = prefs.getString('order');
    try {
      if (order != null) {
        setOrder(order);
      }
    } catch (e) {
      print('Order not set, setting default');
      prefs.setString('order', 'normal');
      setOrder('normal');
    }
  }

  initState() {
    onboarded();
    getOrder();
  }

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
                  '${Provider.of<TaskData>(context, listen: true).taskCount} Tasks',
                  style: TextStyle(
                    // color: Colors.white,
                    fontSize: 20,
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
        title: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FittedBox(
                  fit: BoxFit.contain,
                  child: Row(
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
                        ' Check It Off Pro',
                        style: TextStyle(
                          // color: Colors.white,
                          // fontSize: 30.0,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'Task Order',
                style: TextStyle(fontSize: 40.0),
              ),
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
              ),
            ),
            ListTile(
              title: Text('Order Entered'),
              onTap: () async {
                setOrder('normal');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Alphabetic'),
              onTap: () async {
                setOrder('aasc');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Reverse Alphabetic'),
              onTap: () async {
                setOrder('adsc');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Group By Priority'),
              onTap: () async {
                setOrder('asc');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Due Date'),
              onTap: () async {
                setOrder('dueasc');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Reverse Due Date'),
              onTap: () async {
                setOrder('duedsc');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          color: Colors.lightBlueAccent,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: IconButton(
                  icon: Icon(Icons.help_center_sharp),
                  color: Colors.white,
                  iconSize: 35.0,
                  onPressed: () {
                    launch('https://www.grimshawcoding.com/');
                  },
                ),
              )
            ],
          )),
    );
  }
}
