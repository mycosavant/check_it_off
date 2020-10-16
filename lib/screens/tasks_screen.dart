import 'package:check_it_off/helpers/db.dart';
import 'package:check_it_off/helpers/onboarding.dart';
import 'package:check_it_off/models/task.dart';
import 'package:check_it_off/models/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'package:check_it_off/widgets/tasks_list.dart';
import 'package:check_it_off/screens/add_task_screen.dart';
import 'package:check_it_off/models/task_data.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class TasksScreen extends StatefulWidget {
  final qaOrder;
  TasksScreen([this.qaOrder]);

  @override
  _TasksScreenState createState() => _TasksScreenState(qaOrder);
}

class _TasksScreenState extends State<TasksScreen> {
  final qaOrder;
  _TasksScreenState([this.qaOrder]);

  String myOrder = 'loading';
  bool archived;

  static const kSelectedOrderStyle = TextStyle(
    fontSize: 18.0,
    color: Colors.lightBlueAccent,
    fontWeight: FontWeight.bold,
  );

  static const kOrderStyle = TextStyle(
    fontSize: 15.0,
    color: Colors.black,
  );

  String setOrderString(order) {
    String result = '';
    if (order == 'asc') {
      result = 'Priority';
    } else if (order == 'dsc') {
      result = 'Priority (Reverse)';
    } else if (order == 'aasc') {
      result = 'Alphabetical';
    } else if (order == 'adsc') {
      result = 'Alphabetical (Reverse)';
    } else if (order == 'dueasc') {
      result = 'Due Date';
    } else if (order == 'duedsc') {
      result = 'Due Date (Reverse)';
    } else if (order == 'today') {
      result = 'Due Today';
    } else {
      result = 'Unsorted';
    }
    return result;
  }

  void setOrder(String order) async {
    List<Task> _tasks = [];
    var db = new DB();
    List<Task> _results = await db.query(archived, order);
    _tasks = _results;
    Provider.of<TaskData>(context, listen: false).tasks = _tasks;
    setState(() {});
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('order', order);
    myOrder = setOrderString(order);
  }

  void onboarded() async {
    final prefs = await SharedPreferences.getInstance();
    bool ran = prefs.getBool('onboarded');
    String version = prefs.getString('onboardedVersion');
    prefs.setBool("onboarded", true);
    prefs.setString('onboardedVersion', '1.0.1');
    try {
      if (!ran || version != '1.0.1') {
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (context) => new Onboarding()));
      }
    } catch (e) {
      print('Onboarding has not run.');
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new Onboarding()));
    }
  }

  refresh(dynamic childValue) {
    setState(() {
      var _parentVariable = childValue;
    });
  }

  void getShowAllFlag() async {
    final prefs = await SharedPreferences.getInstance();
    bool show = prefs.getBool('showAll');
    if (show == null) {
      show = false;
    }
    archived = show;
    prefs.setBool('showAll', archived);
  }

  void setShowAllFlag() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('showAll', archived);
    String order = prefs.getString('order');
    setOrder(order);
    // Navigator.pushReplacement(
    //   context,
    //   PageRouteBuilder(
    //     pageBuilder: (_, __, ___) => TasksScreen(),
    //     transitionDuration: Duration(seconds: 0),
    //   ),
    // );
  }

  void getOrder() async {
    final prefs = await SharedPreferences.getInstance();
    String order = prefs.getString('order');
    if (qaOrder != null) {
      order = qaOrder;
      setOrder(order);
    }
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
    getShowAllFlag();
    getOrder();
    archived = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.lightBlueAccent,

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
                  '${Provider.of<TaskData>(context, listen: true).taskCount} Tasks - $myOrder',
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
              child: TasksList(
                notifyRefresh: refresh,
              ),
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
            Container(
              height: 113.0,
              child: DrawerHeader(
                child: Text(
                  'Settings',
                  style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
                ),
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent,
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Sort Order',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {},
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Column(
                children: [
                  ListTile(
                    title: Text('Unsorted',
                        style: myOrder == 'Unsorted'
                            ? kSelectedOrderStyle
                            : kOrderStyle),
                    onTap: () async {
                      setOrder('normal');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text('Due Today',
                        style: myOrder == 'Due Today'
                            ? kSelectedOrderStyle
                            : kOrderStyle),
                    onTap: () async {
                      setOrder('today');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text('Alphabetical',
                        style: myOrder == 'Alphabetical'
                            ? kSelectedOrderStyle
                            : kOrderStyle),
                    onTap: () async {
                      setOrder('aasc');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text('Alphabetical (Reverse)',
                        style: myOrder == 'Alphabetical (Reverse)'
                            ? kSelectedOrderStyle
                            : kOrderStyle),
                    onTap: () async {
                      setOrder('adsc');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text('Priority',
                        style: myOrder == 'Priority'
                            ? kSelectedOrderStyle
                            : kOrderStyle),
                    onTap: () async {
                      setOrder('asc');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text('Due Date',
                        style: myOrder == 'Due Date'
                            ? kSelectedOrderStyle
                            : kOrderStyle),
                    onTap: () async {
                      setOrder('dueasc');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text('Due Date (Reverse)',
                        style: myOrder == 'Due Date (Reverse)'
                            ? kSelectedOrderStyle
                            : kOrderStyle),
                    onTap: () async {
                      setOrder('duedsc');
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          color: Colors.lightBlueAccent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 5.0,
                    ),
                    child: Text(
                      'Show All',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 5.0,
                      left: 10.0,
                    ),
                    child: FlutterSwitch(
                      activeColor: Colors.white,
                      inactiveColor: Colors.white,
                      toggleColor: Colors.lightBlueAccent,
                      value: archived,
                      width: 75,
                      showOnOff: true,
                      activeText: 'On',
                      inactiveText: 'Off',
                      inactiveTextColor: Colors.lightBlueAccent,
                      activeTextColor: Colors.lightBlueAccent,
                      onToggle: (val) {
                        setState(() {
                          archived = val;
                          setShowAllFlag();
                        });
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: IconButton(
                  icon: Icon(Icons.post_add_outlined),
                  color: Colors.white,
                  iconSize: 35.0,
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => SingleChildScrollView(
                                child: Container(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: AddTaskScreen(),
                            )));
                  },
                ),
              )
            ],
          )),
    );
  }
}
