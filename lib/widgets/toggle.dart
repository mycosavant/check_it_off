import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class Toggle extends StatefulWidget {
  final String title;
  final List <String> toggleList;
  final Function onToggle;
  final int selected;
  Toggle(this.title, this.toggleList, this.onToggle, this.selected);

  @override
  _ToggleState createState() => _ToggleState();
}

class _ToggleState extends State<Toggle> {
  Widget build(BuildContext context) {
    return Container(
      // height: 150.0,
      alignment: Alignment.center,
      // color: Colors.lightBlueAccent,
      // child: Platform.isIOS ? iOSPicker() : androidDropdown(),
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
        child: Column(
          children: [
            Text(widget.title, style: TextStyle(fontSize: 25.0),),
            ToggleSwitch(
              activeBgColor: Colors.lightBlueAccent,
              activeFgColor: Colors.white,
              inactiveBgColor: Colors.blue[100],
              inactiveFgColor: Colors.black,
              initialLabelIndex: widget.selected,
              labels: widget.toggleList,
              onToggle: widget.onToggle,
            ),
          ],
        ),
      ),
    );
  }
}
