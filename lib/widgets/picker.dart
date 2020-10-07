import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Picker extends StatefulWidget {
  String selection;
  List<String> myList;
  final onSelectionChanged;
  Picker({this.selection, this.myList, this.onSelectionChanged});
  @override
  _PickerState createState() => _PickerState();
}

class _PickerState extends State<Picker> {
  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String priority in widget.myList) {
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
      value: widget.selection,
      items: dropdownItems,
      onChanged: widget.onSelectionChanged,
      //       (value) {
      //     setState(() {
      //       widget.selection = value;
      //     });
      //   },
    );
  }

  int getIndex() {
    return widget.selection.toString().contains('.')
        ? widget.myList.indexOf(widget.selection.toString().split(".")[1])
        : widget.myList.indexOf(widget.selection.toString());
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String priority in widget.myList) {
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
      onSelectedItemChanged: widget.onSelectionChanged,
      //     (selectedIndex) {
      //   setState(() {
      //     widget.selection = widget.myList[selectedIndex];
      //   });
      // },
      children: pickerItems,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Platform.isIOS ? iOSPicker() : androidDropdown(),
    );
  }
}
