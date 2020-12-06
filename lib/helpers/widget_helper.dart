import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widgetkit/flutter_widgetkit.dart';
import 'package:home_widget/home_widget.dart';

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
    if (Platform.isIOS) {
      // print(jsonEncode(this.text));
      WidgetKit.setItem('widgetData', jsonEncode(FlutterWidgetData(this.text)),
          'group.com.grimshawcoding.checkitoff');
      WidgetKit.reloadAllTimelines();
    }
    else if (Platform.isAndroid) {
      saveWidgetData(this.text);
    }
    else {
      print('Widget not supported currently, skipping.');
    }
  }

  void saveWidgetData(String data){
    HomeWidget.saveWidgetData<String>('id', data);
    HomeWidget.updateWidget(
        name: 'HomeWidget',
        androidName: 'HomeWidget',
        iOSName: '');
    _sendAndUpdate(data);
  }

  Future<void> _sendData(String data) async {
    try {
      return Future.wait([
        HomeWidget.saveWidgetData<String>('title', 'Tasks - Due Date\n____________'),
        HomeWidget.saveWidgetData<String>('message', data),
      ]);
    } on PlatformException catch (exception) {
      debugPrint('Error Sending Data. $exception');
    }
  }

  Future<void> _updateWidget() async {
    try {
      return HomeWidget.updateWidget(
          name: 'HomeWidget', iOSName: 'HomeWidget');
    } on PlatformException catch (exception) {
      debugPrint('Error Updating Widget. $exception');
    }
  }


  Future<void> _sendAndUpdate(String data) async {
    await _sendData(data);
    await _updateWidget();
  }
}
