import 'dart:convert';

import 'package:flutter_widgetkit/flutter_widgetkit.dart';

class FlutterWidgetData {
  final String text;

  FlutterWidgetData(this.text);

  FlutterWidgetData.fromJson(Map<String, dynamic> json)
      : text = json['text'];

  Map<String, dynamic> toJson() =>
      {
        'text': text,
      };

  void setWidgetData(){
    // print(jsonEncode(this.text));
    WidgetKit.setItem('widgetData', jsonEncode(FlutterWidgetData(this.text)), 'group.com.grimshawcoding.checkitoff');
    WidgetKit.reloadAllTimelines();
  }
}
