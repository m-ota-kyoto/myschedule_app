import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:excel/excel.dart';


class EventDataSource extends CalendarDataSource {

  EventDataSource(List<Event> event) {
    appointments = event;
  }

//イベントのカラー
  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

//イベントの終了時間
  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

//イベントの開始時間
  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

//イベントの名前
  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Event {
  Event(this.eventName, this.from, this.to, this.background, this.isAllDay);

  Color background;
  String eventName;
  DateTime from;
  bool isAllDay;
  DateTime to;
}

//予定データ設定
List<Event> getDataSource() {

  //エクセル読み込み
  final file = '\\\\192.168.3.27\\アクト従業員専用\\☆ACTフォルダ\\太田\\勤務日データ.xlsx';
  final bytes = File(file).readAsBytesSync();
  final excel = Excel.decodeBytes(bytes);
  final rowsdata = excel.tables['Sheet1']!.rows;
 
  // for (var table in excel.tables.keys) {
  //   for (var row in excel.tables[table]!.rows) {
  //     // print(row);
  //     // row.forEach((cell) {
  //       // print(cell.value);
  //     // });
  //   }
  // }

  //データをまとめるリスト
  final List<Event> event = <Event>[];

  //データの用意
  // final DateTime today = DateTime.now();
  // final DateTime startTime = DateTime(today.year, today.month, today.day, 9, 0, 0);
  var setyear = rowsdata[0][0], setmonth = rowsdata[0][1], setday;
  for(int i = 0; i <= rowsdata[0].length - 1; i++){
    if(rowsdata[1][i] == '出勤'){
      setday = rowsdata[0][i];
      //引数　年,月,日,開始時,分,秒？
      final DateTime startTime = DateTime(setyear, setmonth, setday, 9, 0, 0);
      final DateTime endTime = startTime.add(const Duration(hours: 9));

      //データをリストに追加
      event.add(Event('勤務', startTime, endTime, Colors.blue, false));
    }
  }

  return event;
}
