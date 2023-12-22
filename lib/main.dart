import 'package:flutter/material.dart';
import 'calendar_setting.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

//ウィンドウサイズ変更にパッケージインストール済み
//https://pub.dev/packages/bitsdojo_window
import 'package:bitsdojo_window/bitsdojo_window.dart';

//ウィンドウスクリーンショット＋保存に使う
//////////////////
import 'package:flutter/rendering.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:path/path.dart' as p;

//////////////////


void main() {
  runApp(const MyApp());

  doWhenWindowReady(() {
    final initialSize = Size(620, 720);
    final minSize = Size(620, 720);
    final maxSize = Size(1200, 850);
    appWindow.maxSize = maxSize;
    appWindow.minSize = minSize;
    appWindow.size = initialSize; //default size
    appWindow.show();
  });
  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            SfGlobalLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
            const Locale('ja'),
      ],
      locale: const Locale('ja'),
      title: 'スケジュール',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'スケジュール'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final CalendarController _controller = CalendarController();
  double _height = 0.0;
  final String assetspath = getAssetFileUrl('assets\\workimage.png');

  final GlobalKey<State<StatefulWidget>> previewContainer = GlobalKey();
  final GlobalKey<State<StatefulWidget>> shareWidget = GlobalKey();

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height/5;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => setState(() {
                capture(path: assetspath);
                print("!!!!!!!!");
                }),
          ),
        ],
      ),
      body: Center(
        child: Container(
            child: SfCalendar(
              headerStyle: const CalendarHeaderStyle(
                textAlign: TextAlign.center,
                textStyle: TextStyle(
                  fontSize: 24,
                ),
              ),
              controller: _controller,
              timeZone: 'Tokyo Standard Time',
              view: CalendarView.month,
              showNavigationArrow: true,
              cellBorderColor: Colors.black,
              todayHighlightColor: Colors.blue,
              todayTextStyle: TextStyle(
                fontSize: 16,
                fontFamily: 'Arial',
              ),
              dataSource: EventDataSource(getDataSource()),//スケジュールデータここで入れる
              monthViewSettings:  MonthViewSettings(
                appointmentDisplayCount:2,
                monthCellStyle: const MonthCellStyle(
                  trailingDatesBackgroundColor: Colors.black12,
                  leadingDatesBackgroundColor: Colors.black12,
                  textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Arial'),
                ),
                appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
                showAgenda: true,
                agendaViewHeight: _height,
                agendaStyle: const AgendaStyle(
                    backgroundColor: Colors.white,
                    dateTextStyle: TextStyle(color: Colors.black),
                    dayTextStyle: TextStyle(color: Colors.black),
                    appointmentTextStyle: TextStyle(color: Colors.white)
                )
              ),
            )
          )
      ),
    );
  }
}



Future<void> writeToFile(ByteData data, String path) {
  final buffer = data.buffer;
  return File(path)
      .writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
}

void capture({required String path}) async {
  var builder = ui.SceneBuilder();
  var scene = RendererBinding.instance.renderView.layer?.buildScene(builder);
  var image = await scene?.toImage(ui.window.physicalSize.width.toInt(),
      ui.window.physicalSize.height.toInt());
  scene?.dispose();

  var data = await image?.toByteData(format: ui.ImageByteFormat.png);
  await writeToFile(data!, path);
  await openimg(path);
}

  Future<void> openimg(String path) async {
    String winpaint = 'C:\\WINDOWS\\system32\\mspaint.exe';
    try {

      ///path of the pdf file to be opened.
      Process.run(winpaint, [path]).then((ProcessResult results) {
        print(results.stdout);
      });
    } catch (e) {
      print(e);
    }
  }

//assetのパス取得
String getAssetFileUrl(String asset) {
  final assetsDirectory = p.join(p.dirname(Platform.resolvedExecutable),
      'data', 'flutter_assets', asset);
  // print(Platform.resolvedExecutable);
  return assetsDirectory.toString();
}