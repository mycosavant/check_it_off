import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskPopup extends StatelessWidget {
  final Function edit;
  final Function delete;
  final Function add;
  TaskPopup({this.delete, this.edit, this.add});
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      itemBuilder: (context) => [
      PopupMenuItem(
        value: 0,
        child: FlatButton(
          child: Center(
            child: Text('Add To Calendar',
                style: TextStyle(
                  fontSize: 18,
                )),
          ),
          onPressed: add,
        ),
      ),
        PopupMenuItem(
          value: 1,
          child: FlatButton(
            child: Center(
              child: Text('Edit',
                  style: TextStyle(
                    fontSize: 18,
                  )),
            ),
            onPressed: edit,
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: FlatButton(
            child: Center(
              child: Text('Delete',
                  style: TextStyle(
                    fontSize: 18,
                  )),
            ),
            onPressed: delete,
          ),
        ),
      ],
      initialValue: 2,
      onCanceled: () {
        print("You have canceled the menu.");
      },
      onSelected: (value) {
        print("value:$value");
      },
      icon: Icon(Icons.list),
    );
  }
}
