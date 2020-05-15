import 'dart:convert';
import 'dart:io';

import 'package:deti_motica_app/api.dart';
import 'package:flutter/material.dart';
import 'package:deti_motica_app/src/import.dart';
import 'package:path_provider/path_provider.dart';
import 'package:typicons_flutter/typicons_flutter.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'dart:async';

class RoomPage extends StatefulWidget {
  final Room room;

  RoomPage(this.room);

  @override
  State<StatefulWidget> createState() => _RoomPageState(room);
}

class _RoomPageState extends State<RoomPage> with WidgetsBindingObserver {
  Room room;
  Future<Room> info;
  Timer timer;
  bool active;

  _trackedFromJson() async {
    String data;
    Map dict;
    try {
      final Directory directory=await getApplicationDocumentsDirectory();
      final File file=File('${directory.path}/trackedSensors');
      if (!file.existsSync()) {
        file.writeAsStringSync('{"tracked": []}');
      }
      data=await file.readAsString();
      dict=jsonDecode(data);
    }
    on FormatException {
      print("WARING: Corrupted file!");
      return;
    }
    print(dict);
    room.initTracked(dict);
  }
  _toggleTracked(String metric) async {
    String data;
    Map dict;
    try {
      final Directory directory=await getApplicationDocumentsDirectory();
      final File file=File('${directory.path}/trackedSensors');
      data=await file.readAsString();
      dict=jsonDecode(data);
    }
    on FormatException {
      print("WARING: Corrupted file!");
      return;
    }
    bool on=room.toggleTracked(metric);
    String id=room.getIdOf(metric);
    List lst=dict['tracked'];
    if (on) {
      if (!lst.contains(id)) dict['tracked'].add(id);
    }
    else {
      if (lst.contains(id)) dict['tracked'].remove(id);
    }

    try {
      final Directory directory=await getApplicationDocumentsDirectory();
      final File file=File('${directory.path}/trackedSensors');
      file.writeAsString(jsonEncode(dict));
    }
    on FormatException {
      print("WARING: Corrupted file!");
      return;
    }
    print(dict);
  }

  _RoomPageState(this.room) {
    _trackedFromJson();
    info=room.update();
    timer=Timer.periodic(Duration(seconds: 2),(Timer t)=>setState(() {
      if (active) {
        room.update();
        if (statusCode == 401) Navigator.pushNamedAndRemoveUntil(context, "/err/401", ModalRoute.withName('/'));
      }
    }));
    active=true;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch(state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        active=false;
      break;
      case AppLifecycleState.resumed:
        active=true;
      break;
    }
  }

  void _logout() async {
    timer?.cancel();
    String post=url+"api/v1/logout";
    await apiGet(post);

    if (statusCode==401) Navigator.pushNamedAndRemoveUntil(context, "/err/401", ModalRoute.withName('/'));
    else Navigator.popUntil(context, ModalRoute.withName('/'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sala ${room.dept}.${room.floor}.${room.num}"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: _logout,
          )
        ],
      ),
      body: FutureBuilder<Room>(
        future: info,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Column(
                    children: _buildSensorData()
                ),
              );
            }
          }
          else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Spacer(flex: 3),
                  Image.asset("assets/images/logo.png",height: 48,width: 48),
                  Spacer(flex: 1),
                  CircularProgressIndicator(),
                  Spacer(flex: 3),
                ],
              )
          );
        }
      )
    );
  }

  List<Widget> _buildSensorData() {
    List<Widget> sensors=[];
    for (String metric in room.getMetrics()) {
      sensors.add(Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        height: 220,
        width: double.maxFinite,
        child: Card(
          elevation: 5,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                    width: 2.0, color: room.getColor(metric)),
              ),
              color: Colors.white,
            ),
            child: Padding(
              padding: EdgeInsets.all(7),
              child: Stack(children: <Widget>[
                Align(
                  alignment: Alignment.centerRight,
                  child: Stack(
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.only(left: 10, top: 5),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(room.isTracked(metric)?Icons.notifications:Icons.notifications_none),
                                    color: (room.isTracked(metric)?Colors.blue:Colors.grey),
                                    onPressed: () {
                                      setState(() {
                                        _toggleTracked(metric);
                                      });
                                    },
                                  ),
                                  _metricIcon(metric),
                                  SizedBox(width: 5),
                                  _metricNameSymbol(metric),
                                  Spacer(),
                                  _sensorChange(metric),
                                  SizedBox(width: 10),
                                  _changeIcon(metric),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(child:_sensorValueData(metric)),
                                  room.getGauge(metric, room.getValue(metric)),
                                  _changeGraph(metric)
                                ].where((Object o)=>o!=null).toList(),
                              )
                            ],
                          ))
                    ],
                  ),
                )
              ]),
            ),
          ),
        ),
      ));
    }

    return sensors;
  }

  Widget _metricIcon(metric) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Align(
          alignment: Alignment.centerLeft,
          child: (room.getIconPath(metric)==null?null:Image.asset(room.getIconPath(metric)))),
    );
  }
  Widget _metricNameSymbol(metric) {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          text: '$metric',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
          children: <TextSpan>[
            TextSpan(
              text: '\n${room.getUnit(metric)}',
              style: TextStyle(
              color: Colors.grey,
              fontSize: 15,
              fontWeight: FontWeight.bold)
            ),
          ],
        ),
      ),
    );
  }
  Widget _sensorChange(metric) {
    double gain= room.getGain(metric).toDouble();
    double gainPercentage= room.getGainPercentage(metric).toDouble() * 100;
    String gainStr = (gain < 0) ?gain.toStringAsFixed(2) : "+"+gain.toStringAsFixed(2);
    String gainPercentageStr = (gainPercentage < 0) ?gainPercentage.toStringAsFixed(2) : "+"+gainPercentage.toStringAsFixed(2);
    return Align(
      alignment: Alignment.topRight,
      child: RichText(
        text: TextSpan(
          text: '$gainPercentageStr%',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: (gainPercentageStr.contains('-') ? Colors.red : Colors.green), fontSize: 20),
          children: <TextSpan>[
            TextSpan(
                text: '\n$gainStr',
                style: TextStyle(
                  color: (gainStr.contains('-') ? Colors.red : Colors.green),
                  fontSize: 15,
                  fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
  Widget _changeIcon(metric) {
    double gainPercentage= room.getGainPercentage(metric).toDouble() * 100;
    String gainPercentageStr = (gainPercentage < 0) ?gainPercentage.toStringAsFixed(2) : "+"+gainPercentage.toStringAsFixed(2);
    return Align(
        alignment: Alignment.topRight,
        child: gainPercentageStr.contains('-')
        ? Icon(
      Typicons.arrow_sorted_down,
      color: Colors.red,
      size: 30,
    )
        : Icon(
      Typicons.arrow_sorted_up,
      color: Colors.green,
      size: 30,
    ));
  }
  Widget _sensorValueData(metric) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Row(
          children: <Widget>[
            RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                text: '\n${room.getValue(metric)}',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 30,
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: '\n${room.getTime(metric)}',
                      style: TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: '\n${room.getDate(metric)}',
                      style: TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                          fontSize: 15,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _changeGraph (metric){
    return Expanded(
      child: Align(
        alignment: Alignment.bottomRight,
        child: new Container(
          width: 120.0,
          height: 80.0,
          padding: EdgeInsets.only(right: 8),
          child: new Sparkline(
            data: room.getPastValues(metric).map((s) => s as double).toList(),
            lineWidth: 5.0,
            lineGradient: new LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [room.getColor(metric), Colors.grey],
            ),
          ),
        ),
      )
    );
  }
}